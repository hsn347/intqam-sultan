# Authoritative Specification Mining: Command Hall Lifecycle

**Analysis Target**: Command Hall (قاعة القيادة) Subtasks Lifecycle, March Tracking, Reward Claiming, and Army Group Progression.  
**Authoritative Source**: Official Game Client Lua Codebase (`game_file/src/`).  
**Investigator**: `teamwork_spec_miner` (Specification Miner).  
**Date**: 2026-11-01.

---

## 1. Executive Summary

A deep investigation of the official game client Lua code in `game_file/` reveals the authoritative mechanics of the Command Hall system:
1. **Task Status Enum (`gCommandHallTaskStatue`)**: Defined in `wholeDefine.lua` with only three valid values: `PREPARE = 1`, `BEGIN = 2`, `FINISH = 3`. Status `3` (`FINISH`) denotes that task requirements are completed and rewards are ready to be claimed via `REQ_COMMAND_HALL_COMMIT_TASK`.
2. **March Duration & Tracking**: Marches dispatched to Command Hall World Map NPCs (Type 2 Pioneer, Type 5 Battle) use `moveLineType = 15` (`gMapMoveLineType.moveLineTypeCommandHallNpc`) and server queue type `51` (`gMapMoveLineServerType.commandHallNpc`). `queueTimeUtil.lua` clamps march travel time to `COMMANDHALL_REBEL_ARMY_MARCH_TIME`, which defaults to **exactly 5 seconds**. The bot's recorded 300-second freeze was caused by a loop waiting indefinitely for an unrefreshed local memory state (`TASK_STATUE_PREPARE`), rather than an actual in-game march timer.
3. **Synchronization & Reward Claiming Protocol**: The server pushes `NOTIFY_COMMAND_HALL` (ID `608`) carrying `data.initData` upon battle resolution. Reward claiming is dispatched via CMD 2274 SubCMD 8 (`REQ_COMMAND_HALL_COMMIT_TASK`) with `{commitType: task.type, index: task.index}`, returning `rspdata.reward` and `rspdata.initData`. Non-combat instant tasks (3, 4, 6) can also be completed via SubCMD 5 (`REQ_COMMAND_HALL_FINISH_TASK`).
4. **Wave Renewal & Progression**: Rebel Army Groups (Type 1) progress across 51 orders (`rabellegionconfig.lua`). Defeating an Army Group (`hurtHp >= rabelHp`) triggers claim via SubCMD 8 (`commitType = 1`), which **instantly** advances `armyGroupID = armyGroupID + 1` and immediately generates the next wave in `rspdata.initData` with 0 cooldown within the same day.

---

## 2. Detailed Findings

### 2.1 Task Status / Statue Lifecycle (Question 1)

#### Enum Definition
In `game_file/src/app/constdef/wholeDefine.lua` (lines 1371–1374):
```lua
1371: _ENV = nil
1372: ;(nil).PREPARE = 1
1373: ;(nil).BEGIN = 2
1374: gCommandHallTaskStatue, (nil).FINISH = nil, 3
```

In `game_file/src/app/constdef/wholeDefine.lua` (lines 1365–1370), the associated task types (`gCommandHallTaskType`) are defined:
```lua
1365: ;(nil).REBEL_ARMY_GROUP_TASK = 1
1366: ;(nil).REBEL_ARMY_PIONEER_TASK = 2
1367: ;(nil).DIALOGUE_TASK = 3
1368: ;(nil).RESCUE_TASK = 4
1369: ;(nil).BATTLE_TASK = 5
1370: gCommandHallTaskType, (nil).SNIPE_HUNTER_TASK = nil, 6
```

#### Meaning of Each Status Value
| Value | Enum Name | Meaning in Lua & Client Behavior |
|:---:|:---|:---|
| `1` | `PREPARE` | Task is in preparation / pending initial generation. |
| `2` | `BEGIN` | Task is active and in-progress. If world-map task (Types 2, 5), the monster NPC is rendered on the map at `task.obj.x, task.obj.y` (`worldMapComCommandHallNpc.lua:178`). Button displays "Attack/Go" with stamina cost (`CommandHallTaskPanel.lua:94-98`). |
| `3` | `FINISH` | Task objective is met (monster killed, dialogue finished, or minigame won). Task is **ready for reward claiming**. Button displays "Claim" (`common_text_1146`) with 0 cost (`CommandHallTaskPanel.lua:90-93`). |

#### Transition to Completed / Ready to Claim
1. **Combat Tasks (Type 2 Pioneer, Type 5 Battle)**:
   - When the client's march arrives at the NPC (after ~5s), the server resolves the battle.
   - Server pushes `NOTIFY_COMMAND_HALL` (ID 608) with `notifyType = 4` (PIONEER) or `5` (COMMON).
   - In `data.initData`, the task's `statue` transitions from `2` (`BEGIN`) to `3` (`FINISH`).
   - World map NPC plays death animation (`doDieingAnimation`, `gMapObjStateTypeHurtDie`) and is removed (`worldMapComCommandHallNpc.lua:280-286`).
   - Client displays red dot / chest icon on the Command Hall UI (`CommandHallMainPanel.lua:229-233, 419-424`).
2. **Rebel Army Group (Type 1)**:
   - Tracks `task.rabelHp` and `task.hurtHp`.
   - When `task.hurtHp >= task.rabelHp`, `curHp <= 0` (`Com_MainReward.lua:193-199`).
   - `statue` transitions to `3` (`FINISH`), switching the UI to the Claim state (`Com_MainReward.lua:84-85`).
3. **Instant Tasks (Type 3 Dialogue, Type 4 Rescue, Type 6 Snipe)**:
   - Invoked via `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) (`CommandHallMainPanel.lua:589`, `CommandHallTalkPanel.lua:66`).
   - Server immediately fulfills the task and returns rewards.

---

### 2.2 Marching Tasks Lifecycle: Types 2 & 5 (Question 2)

#### March Dispatch Packet
- Command: `CMD 1007` (`CMD_KINGDOM_QUEUE_MODULE`), `SubCMD 2` (`ADD_KINGDOM_QUEUE`).  
  Cited from `game_file/src/app/constdef/cmdDef.lua`:
  ```lua
  237: ;(nil).CMD_KINGDOM_QUEUE_MODULE = "1007"
  238: ;(nil).ADD_KINGDOM_QUEUE = "2"
  ```
- Parameters:
  - `moveLineType = 15` (`gMapMoveLineType.moveLineTypeCommandHallNpc`, `mapDef.lua:395`).
  - `matrixType = 1` (`gMapMoveLineMatrixType.moveLineMatrixTypeTroop`, `mapDef.lua:411; worldMapFunction.lua:355`).
  - Server queue type: `gMapMoveLineServerType.commandHallNpc = 51` (`mapDef.lua:367; worldMapFunction.lua:645`).

#### March Duration: The 5-Second Cap
In `game_file/src/app/module/world/queueTimeUtil.lua` (lines 327–333):
```lua
327: 	if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
328: 		local commandHallUtil = include("commandHallUtil")
329: 		local marchTime = commandHallUtil.getRebelArmyMarchTime()
330: 		if totalTime > marchTime then
331: 			totalTime = marchTime
332: 		end
333: 	end
```
And in `game_file/src/app/module/commandHall/commandHallUtil.lua` (lines 310–314):
```lua
310: function commandHallUtil.getRebelArmyMarchTime(...)
311: 	local constantRead = include("constantRead")
312: 	local COMMANDHALL_REBEL_ARMY_MARCH_TIME = constantRead.getConstValue("COMMANDHALL_REBEL_ARMY_MARCH_TIME", 5)
313: 	return math.floor(COMMANDHALL_REBEL_ARMY_MARCH_TIME)
314: end
```
**Conclusion**: Regardless of map distance, marches to Command Hall NPCs have a hard upper limit of `COMMANDHALL_REBEL_ARMY_MARCH_TIME`, which defaults to **5 seconds**!

#### Tracking Structure in Client Memory
- Stored in `kingdomMapCell.localUserQueueMgr` (`game_file/src/app/module/world/localQueue/localUserQueueMgr.lua`).
- Looked up via `hasFromUserCommandHallQueue` (`localUserQueueMgr.lua:261-271`):
  ```lua
  261: function localUserQueueMgr:hasFromUserCommandHallQueue(uid, index, taskType)
  265: 		for _, queue in pairs(self.fromUserQueueMap[uid]) do
  266: 			if gMapMoveLineType.moveLineTypeCommandHallNpc == queue:getMoveLineType() and (not index or queue.taskData and index == queue.taskData.index) and (not taskType or queue.taskData and taskType == queue.taskData.type) then
  267: 				return true, queue:getId()
  268: 			end
  269: 		end
  ```
- Queue metadata cell: `kingdomQueueObjCell` (`kingdomQueueObjCell.lua:71-91`):
  - `statusStartTime`: Timestamp when march began.
  - `statusEndTime`: Timestamp when march arrives at target (`statusStartTime + totalTime`).
  - `getStatusRemainTime()`: Calculates remaining seconds until arrival (`statusEndTime - systemTime`).

#### How Client Knows March Arrived / Battle Completed
1. **Local Timer**: `statusEndTime <= serviceFunctions.systemTime()`. Since travel time is <= 5 seconds, arrival is almost immediate.
2. **Server Push Packet**: Server sends `NOTIFY_COMMAND_HALL` (`CMD "608"`, `gNotifyID.COMMAND_HALL` in `notifyIDDef.lua:321`).
   - Handler in `commandHallCtrl.lua:47-184`:
     - Updates `self.initData` with `data.initData` (line 49).
     - Receives `data.result` (`win`, `taskID`, `reward`).
     - Emits `MESSAGE_COMMANDHALL_COMMITTASK_UPDATE` (line 74, 165).
3. **Server Queue Removal**: Server sends `NOTIFY_LOCAL_QUEUE_SYNC` (`CMD "202"`, `notifyIDDef.lua:33`) removing the queue (`kingdomMapCtrl.lua:938-941`).

---

### 2.3 Synchronization & Reward Claiming Protocol (Question 3)

#### Synchronization with CMD 2274 SubCMD 1 (`REQ_COMMAND_HALL_INIT`)
In `game_file/src/app/module/commandHall/commandHallCtrl.lua`:
```lua
240: function commandHallCtrl:reqInit()
241: 	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_INIT)
242: end
243: function commandHallCtrl:reqInitRsp(content)
248: 	if content.err == gErrDef.Err_None then
249: 		self:setInitData(content.rspdata.initData, true)
250: 	end
251: 	_ENV = self
252: 	self.msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
253: 	SoraDSendMessage(self)
254: end
```
- **When sent**:
  1. On login / entering game (`commandHallCtrl:EnterGame()`, line 25).
  2. When opening Command Hall UI if `self.initData` is not loaded (`CommandHallMainPanel.lua:80-85`).
  3. Authoritative refresh: Because server responses return full `rspdata.initData`, sending SubCMD 1 is a guaranteed 0-risk sync that refreshes all subtasks and their `statue` flags.

#### Claiming Rewards with CMD 2274 SubCMD 8 (`REQ_COMMAND_HALL_COMMIT_TASK`)
In `game_file/src/app/module/commandHall/commandHallCtrl.lua` (lines 370–393):
```lua
370: function commandHallCtrl:reqCommitTask(commitType, index)
371: 	serverproxy = nil
372: 	;(nil).commitType = commitType
373: 	;(nil).index = index
374: 	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_COMMIT_TASK, nil)
375: end
376: function commandHallCtrl:reqCommitTaskRsp(content)
378: 	if content.err == gErrDef.Err_None then
379: 		local oldTaskList = self.taskList
380: 		local rspdata = content.rspdata
381: 		self:setInitData(rspdata.initData, true)
382: 		local diffList = self:getDiffList(oldTaskList, self.taskList)
383: 		local commitType = content.data.commitType
...
390: 		if rspdata.reward then
391: 			SoraDMailGainItems(rspdata.reward, true)
392: 		end
393: 	end
394: end
```
- **Inputs**:
  - `commitType` (int): The task type (`gCommandHallTaskType`):
    - `1` = `REBEL_ARMY_GROUP_TASK`
    - `2` = `REBEL_ARMY_PIONEER_TASK`
    - `3` = `DIALOGUE_TASK`
    - `4` = `RESCUE_TASK`
    - `5` = `BATTLE_TASK`
    - `6` = `SNIPE_HUNTER_TASK`
  - `index` (int): The task index in `initData` / `taskList` (`task.index`).
- **Outputs**:
  - `rspdata.reward`: Items/chests granted.
  - `rspdata.initData`: Fresh state of the entire Command Hall module, with claimed tasks removed or replaced.
- **In-Memory State Sync**:
  - `self:setInitData(rspdata.initData, true)` rebuilds `taskList`, `index2taskIndex`, and `pos2taskIndex` (`commandHallCtrl.lua:586-618`).

---

### 2.4 Task Renewal and Army Group Progression (Question 4)

#### Rebel Army Group (Type 1) Defeat Packet
- When the Rebel Army Group's HP reaches 0 (`hurtHp >= rabelHp`), `task.statue` becomes `3` (`FINISH`).
- Claim packet sent:
  `CMD 2274, SubCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) with:
  ```json
  { "commitType": 1, "index": task.index }
  ```
  Cited from `game_file/src/fgui/gcomponent/CommandHall/Com_MainReward.lua`:
  ```lua
  215: commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
  223: if self.taskData.statue == gCommandHallTaskStatue.FINISH then
  232: 	dispatch()
  235: else
  236: 	commandHallCtrl:reqAttackArmyGroup()
  ```

#### How Advancing `armyGroupID` Refreshes the Task List
- Official configuration: `game_file/src/app/localtb/config_server/rabellegionconfig.lua` defines 51 groups/waves (index 1 to 51).
- Each group specifies:
  - `taskID` (1001..1051)
  - `rabelHp` (100 in wave 1, increasing up to 8000 in wave 51)
  - `fixedTask`: Predefined subtasks for that wave (e.g. `[6091, 3091]` in wave 2; `[5091, 4091, 3092]` in wave 3)
  - `random`: 0 (fixed tasks) or 1 (random tasks based on `qualityPro`)
  - `taskDamage`: Damage dealt to the Rebel Army Group HP per subtask type (e.g., pioneer = 100~5000; common tasks = 5~400).
- When `REQ_COMMAND_HALL_COMMIT_TASK` with `commitType = 1` succeeds:
  - The server automatically advances `armyGroupID = armyGroupID + 1`.
  - The server generates the new wave's `armyGroupTaskData`, new `armyPioneerTaskData`, and new `commonTaskData` in `rspdata.initData`.
  - `commandHallCtrl:reqCommitTaskRsp` receives `rspdata.initData`, calls `setInitData`, and populates the new wave's tasks immediately into `self.taskList`.
  - In `CommandHallMainPanel.lua` (lines 405–413), new tasks from `addList` are rendered.

#### Wave Timers and Renewal Cadence
1. **Intra-day Wave Progression is INSTANT**:
   - There is **NO cooldown or waiting timer** between waves within the player's daily wave limit.
   - The moment the Army Group is claimed, the next wave spawns instantly in the same response (`rspdata.initData`).
2. **Daily Wave Quota Exhaustion**:
   - When all daily waves are defeated, `armyGroupTaskData` is empty (`next(task) == nil`), and `tomorrowArmyGroupTaskData` is set.
   - The countdown timer shown is `serviceFunctions.getTodayRemainTime()` (`Com_MainReward.lua:158-161`), counting down to the daily reset at 00:00 server time.
3. **Periodic Common Task Refresh (Random Orders 48-51)**:
   - For circulating waves (`isCommandLvRandom(order) == true`):
   - If all subtasks are finished, `initData.nextRefreshTime` indicates when new tasks spawn (`commandHallCtrl.lua:637-640`).
   - Server pushes `NOTIFY_COMMAND_HALL` with `notifyType = 1` (`TIME_REFRESH`) when the timer reaches 0.

---

## 3. Root Cause of the 300-Second Freeze in `tasks/command_hall.py`

In `tasks/command_hall.py`:
- In `_handle_march_tasks` (lines 940–944):
  ```python
  if res is not None:
      dispatched += 1
      task["statue"] = TASK_STATUE_PREPARE  # Sets status to 1 in local memory
  ```
- In `run()` loop (lines 971, 1025–1041):
  ```python
  has_active_marches = (total_marches > 0)
  has_preparing_tasks = any(self._safe_int(t.get("statue", 0)) == TASK_STATUE_PREPARE for t in tasks)
  if not pending_tasks and not has_active_marches and not has_preparing_tasks and elapsed >= 30:
      break
  ```
Because `total_marches > 0` was `True` and `has_preparing_tasks` remained `True`, the exit condition was never met. The bot sat sleeping for `LOOP_MAX_DURATION_SECONDS = 300` (5 minutes), because:
1. It assumed the march would take a long time, whereas Lua's `COMMANDHALL_REBEL_ARMY_MARCH_TIME` is **5 seconds**.
2. It never queried `REQ_COMMAND_HALL_INIT` (CMD 2274 SubCMD 1) after the 5-second march completed.
3. It left the local memory task in `TASK_STATUE_PREPARE` (1), so `_claim_finished_tasks` (which only checks `statue == 3`) never claimed the reward, ultimately exiting after 300 seconds with **0 rewards**.

---

## 4. Features Discovered

| # | Category | Feature | Description | Inputs | Outputs | Error Behavior | Discovered Via |
|---|----------|---------|-------------|--------|---------|----------------|----------------|
| 1 | Network Protocol | `CMD_COMMAND_HALL_MODULE` (2274) | Master Command Hall module ID | Protocol CMD string | Module routing | Returns err code if invalid | `cmdDef.lua:3242` |
| 2 | Network Protocol | `REQ_COMMAND_HALL_INIT` (SubCMD 1) | Requests initial or synchronized Command Hall state | None / empty | `rspdata.initData` | Standard error handling | `cmdDef.lua:3243`, `commandHallCtrl.lua:240-254` |
| 3 | Network Protocol | `REQ_COMMAND_HALL_UPGRADE_COMMAND_LV` (SubCMD 2) | Upgrades Command Hall level and grants level-up rewards | None / empty | `rspdata.initData`, `rspdata.reward` | `Err_COMMAND_HALL_FULL_LV` (716003), `Err_COMMAND_HALL_NOT_ENOUGH_EXP` (716004) | `cmdDef.lua:3244`, `commandHallCtrl.lua:255-276` |
| 4 | Network Protocol | `REQ_COMMAND_HALL_UPGRADE_POWER_LV` (SubCMD 3) | Upgrades Command Hall power tier and grants tier rewards | None / empty | `rspdata.initData`, `rspdata.reward` | Standard error handling | `cmdDef.lua:3245`, `commandHallCtrl.lua:277-298` |
| 5 | Network Protocol | `REQ_COMMAND_HALL_FINISH_TASK` (SubCMD 5) | Instantly completes non-combat tasks (Dialogue 3, Rescue 4, Snipe 6) | `{"index": task.index}` | `rspdata.initData`, `rspdata.reward` | `Err_COMMAND_HALL_TASK_TYPE_ERROR` (716007) | `cmdDef.lua:3247`, `commandHallCtrl.lua:299-327` |
| 6 | Network Protocol | `REQ_COMMAND_HALL_SET_DEFEND` (SubCMD 6) | Sets defensive troops and hero for castle defense against army group | `armyInfo, heroInfo, armsInfo, divineBeastInfo` | `rspdata.initData` | `Err_COMMAND_HALL_ARMY_ILLEGAL` (716010) | `cmdDef.lua:3248`, `commandHallCtrl.lua:328-342` |
| 7 | Network Protocol | `REQ_COMMAND_HALL_ATTACK_ARMY_GROUP` (SubCMD 7) | Attacks the invading Rebel Army Group (Type 1) | `armyInfo, heroInfo, armsInfo, divineBeastInfo` | `rspdata.initData` | `Err_COMMAND_HALL_NOT_ENOUGH_PHYSICAL` (716008) | `cmdDef.lua:3249`, `commandHallCtrl.lua:343-369` |
| 8 | Network Protocol | `REQ_COMMAND_HALL_COMMIT_TASK` (SubCMD 8) | Claims rewards for completed tasks (`statue == 3`) | `{"commitType": task.type, "index": task.index}` | `rspdata.initData`, `rspdata.reward` | `Err_COMMAND_HALL_NOT_FINISH_TASK` (716005) | `cmdDef.lua:3250`, `commandHallCtrl.lua:370-393` |
| 9 | Network Protocol | `REQ_COMMAND_HALL_REFRESH_POS` (SubCMD 9) | Refreshes world map NPC position if tile is obstructed | `{"x": pos.x, "y": pos.y}` | `rspdata.x, rspdata.y` | Standard error handling | `cmdDef.lua:3251`, `commandHallCtrl.lua:431-460` |
| 10 | Network Protocol | `REQ_COMMAND_HALL_REFRESH_POS2` (SubCMD 10) | Navigates client to refreshed world map NPC coordinates | `{"x": pos.x, "y": pos.y}` | `rspdata.x, rspdata.y` | Standard error handling | `cmdDef.lua:3252`, `commandHallCtrl.lua:461-490` |
| 11 | Network Push | `NOTIFY_COMMAND_HALL` (608) | Push notification for Command Hall events | Event payload with `notifyType` and `initData` | Live memory update via `setInitData` | Logged and isolated | `cmdDef.lua:650`, `notifyIDDef.lua:321`, `commandHallCtrl.lua:39-184` |
| 12 | World March | `ADD_KINGDOM_QUEUE` (CMD 1007 SubCMD 2) | Dispatches march against Command Hall NPC | `moveLineType = 15`, `matrixType = 1`, target coords | Active queue in `localUserQueueMgr` | `Err_COMMAND_HALL_QUEUE_STATUE_ERROR` (716013) | `cmdDef.lua:238`, `mapDef.lua:395`, `kingdomMapCtrl.lua:180` |
| 13 | World March Speed | `COMMANDHALL_REBEL_ARMY_MARCH_TIME` | Hard-coded march travel time cap (5s) | Distance and march parameters | `totalTime = math.min(totalTime, 5)` | None | `queueTimeUtil.lua:327-333`, `commandHallUtil.lua:310-314` |
| 14 | Task State | `gCommandHallTaskStatue` | Task lifecycle states (PREPARE=1, BEGIN=2, FINISH=3) | Task state transitions | Drives UI claim vs attack state | `Err_COMMAND_HALL_NOT_FINISH_TASK` if claimed prematurely | `wholeDefine.lua:1371-1374`, `CommandHallTaskPanel.lua:90` |
| 15 | Task Type | `gCommandHallTaskType` | Subtask classification (1:GROUP, 2:PIONEER, 3:DIALOGUE, 4:RESCUE, 5:BATTLE, 6:SNIPE) | Task type ID | Dictates execution pipeline (instant vs march) | `Err_COMMAND_HALL_TASK_TYPE_ERROR` (716007) | `wholeDefine.lua:1365-1370`, `commandHallUtil.lua:114-126` |
| 16 | Wave Progression | `rabellegionconfig` | 51 waves of Rebel Army Groups with HP, damage, and subtasks | `armyGroupID` (1..51) | Instant spawn of next wave upon claim | Daily reset when exhausted | `rabellegionconfig.lua:1-936`, `commandHallRead.lua:351-424` |

---

## 5. Edge Cases

| # | Feature | Input / Scenario | Observed / Authoritative Behavior |
|---|---------|------------------|-----------------------------------|
| 1 | Army Group Defeat Claim | All subtasks of current wave completed but Rebel Army Group not claimed | Army Group `statue` is `3` (`FINISH`) or `hurtHp >= rabelHp`. Claiming it via `commitType = 1` immediately advances `armyGroupID` and spawns the next wave. If left unclaimed, next wave will never spawn. |
| 2 | March Speed Cap | Monster coordinates are far away from player city | `queueTimeUtil.lua` caps the march time to 5 seconds (`totalTime = math.min(totalTime, 5)`). The march arrives at destination in 5 seconds regardless of coordinate distance. |
| 3 | Premature Claim | Sending `REQ_COMMAND_HALL_COMMIT_TASK` while `statue == 2` (`BEGIN`) | Server returns error `Err_COMMAND_HALL_NOT_FINISH_TASK` (716005). Claiming must only occur when `statue == 3`. |
| 4 | Pioneer Monster Defeat | Defeating Type 2 Pioneer Monster | In addition to task victory rewards, deals massive damage (100 to 5000 HP) directly to the Rebel Army Group `rabelHp` (`rabellegionconfig.lua:7-16`). |
| 5 | Instant Tasks Without Army | Type 3 (Dialogue), Type 4 (Rescue), Type 6 (Snipe) | `checkTaskTypeNeedArmy` returns `false`. These tasks do not require an army march and can be directly finished via `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) with 0 march time. |
| 6 | Daily Quota Exhausted | Player defeats all available waves for the day | `armyGroupTaskData` is empty; `tomorrowArmyGroupTaskData` is populated. `Group_palaceTime` displays `getTodayRemainTime()` until daily reset (00:00 server time). |
| 7 | Missing Push Packet | Network drop or client disconnect during march | Client can safely send `REQ_COMMAND_HALL_INIT` (CMD 2274 SubCMD 1) after 5-7 seconds. Response `rspdata.initData` authoritatively reflects `statue == 3` (`FINISH`) ready for claim. |
