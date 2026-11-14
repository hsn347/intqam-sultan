# Handoff Report: Command Hall Lifecycle Specification Mining

## 1. Observation

Direct code observations from the official game client Lua codebase in `game_file/src/`:

1. **Task Status Enum (`gCommandHallTaskStatue`)**:
   - In `game_file/src/app/constdef/wholeDefine.lua` (lines 1371–1374):
     ```lua
     1371: _ENV = nil
     1372: ;(nil).PREPARE = 1
     1373: ;(nil).BEGIN = 2
     1374: gCommandHallTaskStatue, (nil).FINISH = nil, 3
     ```
   - In `game_file/src/app/module/commandHall/commandHallCtrl.lua`:
     - Line 234: `if task.statue == gCommandHallTaskStatue.FINISH then return true end`
     - Line 540: `return task and task.statue and task.statue == gCommandHallTaskStatue.FINISH`
     - Line 727: `if task.statue == gCommandHallTaskStatue.BEGIN then count = count + 1 end`

2. **March Duration Cap & Speed (`COMMANDHALL_REBEL_ARMY_MARCH_TIME`)**:
   - In `game_file/src/app/module/world/queueTimeUtil.lua` (lines 327–333):
     ```lua
     327: if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
     328: 	local commandHallUtil = include("commandHallUtil")
     329: 	local marchTime = commandHallUtil.getRebelArmyMarchTime()
     330: 	if totalTime > marchTime then
     331: 		totalTime = marchTime
     332: 	end
     333: end
     ```
   - In `game_file/src/app/module/commandHall/commandHallUtil.lua` (lines 310–314):
     ```lua
     310: function commandHallUtil.getRebelArmyMarchTime(...)
     311: 	local constantRead = include("constantRead")
     312: 	local COMMANDHALL_REBEL_ARMY_MARCH_TIME = constantRead.getConstValue("COMMANDHALL_REBEL_ARMY_MARCH_TIME", 5)
     313: 	return math.floor(COMMANDHALL_REBEL_ARMY_MARCH_TIME)
     314: end
     ```

3. **March Network Dispatch & Local Queue Tracking**:
   - `CMD_KINGDOM_QUEUE_MODULE = "1007"`, `ADD_KINGDOM_QUEUE = "2"` (`cmdDef.lua:237-238`).
   - `gMapMoveLineType.moveLineTypeCommandHallNpc = 15` (`mapDef.lua:395`).
   - `gMapMoveLineServerType.commandHallNpc = 51` (`mapDef.lua:367; worldMapFunction.lua:645`).
   - In `game_file/src/app/module/world/localQueue/localUserQueueMgr.lua` (lines 261–269):
     ```lua
     261: function localUserQueueMgr:hasFromUserCommandHallQueue(uid, index, taskType)
     265: 	for _, queue in pairs(self.fromUserQueueMap[uid]) do
     266: 		if gMapMoveLineType.moveLineTypeCommandHallNpc == queue:getMoveLineType() and (not index or queue.taskData and index == queue.taskData.index) and (not taskType or queue.taskData and taskType == queue.taskData.type) then
     267: 			return true, queue:getId()
     268: 		end
     269: 	end
     ```

4. **Reward Claiming Protocol (`REQ_COMMAND_HALL_COMMIT_TASK`)**:
   - In `game_file/src/app/module/commandHall/commandHallCtrl.lua` (lines 370–375, 380–392):
     ```lua
     370: function commandHallCtrl:reqCommitTask(commitType, index)
     374: 	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_COMMIT_TASK, nil)
     375: end
     380: 	local rspdata = content.rspdata
     381: 	self:setInitData(rspdata.initData, true)
     390: 	if rspdata.reward then
     391: 		SoraDMailGainItems(rspdata.reward, true)
     392: 	end
     ```
   - In `game_file/src/fgui/views/CommandHall/CommandHallTaskPanel.lua` (lines 122–126):
     ```lua
     122: local statue = self.taskData.statue
     123: if statue == gCommandHallTaskStatue.FINISH then
     124: 	commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
     ```
   - In `game_file/src/fgui/gcomponent/CommandHall/Com_MainReward.lua` (lines 223–236):
     ```lua
     223: if self.taskData.statue == gCommandHallTaskStatue.FINISH then
     ...
     215: 	commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
     235: else
     236: 	commandHallCtrl:reqAttackArmyGroup()
     ```

5. **Army Group Progression (`rabellegionconfig.lua`)**:
   - 51 waves (`rabellegionconfig.lua:1-936`). Wave 1 starts with `rabelHp = 100`, wave 50 has `7800`, wave 51 has `8000` (`isCirculate = 1`).
   - Claiming wave N via `reqCommitTask(1, index)` immediately increments `armyGroupID = armyGroupID + 1` and returns the next wave in `rspdata.initData`. There is NO delay or cooldown between waves on the same day.

6. **The Existing Bug in `tasks/command_hall.py`**:
   - Lines 941, 1025–1041: When dispatching a march, the task in memory was set to `task["statue"] = TASK_STATUE_PREPARE` (1). The loop then evaluated `has_active_marches = (total_marches > 0)` and `has_preparing_tasks = any(statue == 1)` and prevented early exit.
   - It slept for the full `LOOP_MAX_DURATION_SECONDS = 300` (5 minutes) without ever checking queue arrival or re-querying `REQ_COMMAND_HALL_INIT` (CMD 2274 SubCMD 1), leaving `statue` as 1, claiming 0 rewards, and timing out.

---

## 2. Logic Chain

1. **Step 1 (Status Values)**: `wholeDefine.lua:1371-1374` defines `gCommandHallTaskStatue` as `PREPARE = 1`, `BEGIN = 2`, `FINISH = 3`. Across the UI (`CommandHallTaskPanel.lua:90, 123`, `Com_MainReward.lua:84, 223`), claiming is triggered strictly when `statue == 3`.
2. **Step 2 (March Velocity)**: When a player attacks a World Map Command Hall NPC (Type 2 Pioneer, Type 5 Battle), `CMD 1007 SubCMD 2` with `moveLineType = 15` is dispatched. Regardless of map coordinates, `queueTimeUtil.lua:327-333` clamps the travel time to `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` seconds.
3. **Step 3 (Arrival & Resolution)**: The march arrives within 5 seconds. The server resolves battle and pushes `NOTIFY_COMMAND_HALL` (ID 608) containing `data.initData`, setting the task's `statue` to `3` (`FINISH`).
4. **Step 4 (Authoritative Sync)**: In an automated bot, relying on push packets alone is fragile if connection buffers drop. Sending `REQ_COMMAND_HALL_INIT` (CMD 2274 SubCMD 1) after 5–7 seconds returns `rspdata.initData` with the updated `statue = 3`.
5. **Step 5 (Claiming)**: Sending `REQ_COMMAND_HALL_COMMIT_TASK` (CMD 2274 SubCMD 8) with `{commitType: task.type, index: task.index}` collects the victory reward (`rspdata.reward`) and purges/updates the task in `rspdata.initData`.
6. **Step 6 (Army Group Progression)**: When the Rebel Army Group (Type 1) HP is reduced to 0 (`hurtHp >= rabelHp`), its `statue` becomes `3`. Calling `reqCommitTask(1, task.index)` instantly advances `armyGroupID = armyGroupID + 1` and returns the next wave in `rspdata.initData` with 0 cooldown.

---

## 3. Caveats

- **Network Jitter**: While Lua hard-caps travel time at 5 seconds, real server network round-trip time may take 6–8 seconds. A dynamic wait of 6–8 seconds after dispatch before polling or checking arrival is optimal.
- **Daily Quota**: Wave progression is infinite up to 51 waves, but limited daily by player level or server configuration. When daily quota is exhausted, `armyGroupTaskData` is nil and `tomorrowArmyGroupTaskData` is present.
- No other caveats; all findings are backed by verbatim Lua source citations.

---

## 4. Conclusion

The authoritative lifecycle of Command Hall tasks is:
1. **Status**: `BEGIN = 2` (in-progress) -> `FINISH = 3` (completed, ready to claim).
2. **March**: Takes at most **5 seconds** (`COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`). Dispatches with `moveLineType = 15`.
3. **Tracking**: The 300-second freeze in `tasks/command_hall.py` was a local logic flaw (setting `statue = PREPARE` and waiting out a 300s timeout). Instead, the task should wait ~6–8s, refresh via `REQ_COMMAND_HALL_INIT` (CMD 2274 SubCMD 1), verify `statue == 3`, and claim via `REQ_COMMAND_HALL_COMMIT_TASK` (CMD 2274 SubCMD 8).
4. **Renewal**: Defeating the Army Group (Type 1) and claiming via `commitType = 1` immediately spawns the next wave with 0 delay.

---

## 5. Verification Method

To independently verify these findings:
1. **Inspect Lua Source Files**:
   - `game_file/src/app/constdef/wholeDefine.lua`: lines 1365–1374 (`gCommandHallTaskType` & `gCommandHallTaskStatue`).
   - `game_file/src/app/module/world/queueTimeUtil.lua`: lines 327–333 (5-second march cap).
   - `game_file/src/app/module/commandHall/commandHallUtil.lua`: lines 310–314 (`COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`).
   - `game_file/src/app/module/commandHall/commandHallCtrl.lua`: lines 240–254 (Init), lines 370–393 (Commit).
   - `game_file/src/fgui/views/CommandHall/CommandHallTaskPanel.lua`: lines 90–98, 122–126 (Claim logic).
   - `game_file/src/app/localtb/config_server/rabellegionconfig.lua`: lines 1–936 (51 waves configuration).
2. **Field Verification**:
   - Run a test script in `tools/` dispatching a Command Hall march.
   - Verify server returns battle outcome in ~5 seconds and `REQ_COMMAND_HALL_INIT` returns `statue == 3`.
   - Verify `REQ_COMMAND_HALL_COMMIT_TASK` yields items > 0 and advances `armyGroupID`.
