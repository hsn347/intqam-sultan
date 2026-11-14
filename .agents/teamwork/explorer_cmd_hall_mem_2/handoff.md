# Handoff Report: Command Hall Task Investigation & Blueprint

**Author**: Live Memory & Backend Explorer (`teamwork_explorer`)  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_mem_2\`  
**Milestone**: Milestone 1 — Command Hall Exploration & Architectural Blueprint  
**Recipient**: Orchestrator (`d19e9194-d159-4bbe-898e-8ab0b5e71f55`)

---

## 1. Observation

1. **Live Memory Dumps (`beetoo1_live_memory.json`, `beetoo3_live_memory.json`)**:
   - Total keys: 277 controllers.
   - `commandHall` / `commandHallCtrl` is **absent** from the initial login dump.
   - `everydayTaskCtrl` is present, containing `eventInfo` and `normalRecord`. In `game_file/src/app/localtb/config_client/daily_reward_data.lua:162-166`, subtask `4100033` is named `"commandhall_text_82"` ("قاعة القيادة"), mapped to `image = "img_commandhall_entrance.png"`, awarding 10 daily activity points upon completion.
   - `queueCtrl` is present: contains queue types `1202` (hospital), `1203` (chariot), `1204` (stables), `1205` (range), `1206` (barracks), `1212` (research). In `core/game_client.py:1438-1440`, active map marches arrive as `notifyID == 'NOTIFY_LOCAL_QUEUE_SYNC'` and are written to `self.init_data['queueCtrl'] = {"queues": notify_data}`.
   - `armyCtrl` is present: garrison troops are tracked in `totalArmy`, while outside troops are tracked in active map queues.

2. **Command Hall Network Commands (`game_file/src/app/constdef/cmdDef.lua:3242-3254`)**:
   - Module ID: `CMD_COMMAND_HALL_MODULE = "2274"`
   - `REQ_COMMAND_HALL_INIT = "1"` (data sync)
   - `REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"` (level upgrade & reward claim)
   - `REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"` (power level upgrade)
   - `REQ_COMMAND_HALL_FINISH_TASK = "5"` (payload: `{"index": index}`)
   - `REQ_COMMAND_HALL_COMMIT_TASK = "8"` (payload: `{"commitType": commitType, "index": index}`)

3. **Subtask Types & Statuses (`game_file/src/app/constdef/wholeDefine.lua:1364-1374`)**:
   - Types (`gCommandHallTaskType`):
     - `1`: `REBEL_ARMY_GROUP_TASK` (جيش المتمردين الجماعي)
     - `2`: `REBEL_ARMY_PIONEER_TASK` (طليعة جيش المتمردين — requires army)
     - `3`: `DIALOGUE_TASK` (حوار — instant / zero-army)
     - `4`: `RESCUE_TASK` (إنقاذ — instant / zero-army)
     - `5`: `BATTLE_TASK` (معركة — requires army)
     - `6`: `SNIPE_HUNTER_TASK` (قنص — mini-game / zero-army)
   - Statuses (`gCommandHallTaskStatue`):
     - `1`: `PREPARE` (إعداد)
     - `2`: `BEGIN` (جاهزة للتنفيذ)
     - `3`: `FINISH` (مكتملة وجاهزة للاستلام عبر REQ 8)

4. **Task Execution In Client Code (`game_file/src/fgui/views/CommandHall/CommandHallMainPanel.lua:306-307, 584-593`)**:
   - `statue == 3` (`FINISH`): triggers `commandHallCtrl:reqCommitTask(task.type, task.index)` (CMD 2274, REQ 8) to claim rewards.
   - Types 3, 4, 6: trigger `commandHallCtrl:reqFinishTask(task.index)` (CMD 2274, REQ 5) and finish immediately without sending map marches.
   - Level upgrade: in `commandHallCtrl.lua:219-230`, when `curExp >= needExp`, `reqUpgradeCommandLv()` (CMD 2274, REQ 2) is sent.

5. **`core/game_client.py` Review**:
   - `RosClient.query(cmd, subcmd, data)` handles dynamic query packets seamlessly.
   - Socket, authentication, and packet queues do not require modification. The constraint that `core/game_client.py` MUST NOT be touched is confirmed and respected.

---

## 2. Logic Chain

1. **Step 1 — Pre-flight Check (0-Network)**:
   - Observation: `commandHall` is absent from login dump but queryable via CMD 2274 / REQ 1.
   - Logic: Task checks `conn.init_data.get("commandHall")`. If missing, it invokes `safe_query("2274", "1", {})` with human jitter (0.5s - 0.9s) once to initialize memory, caching response in `conn.init_data["commandHall"]`.

2. **Step 2 — Reward Claiming Prioritization**:
   - Observation: Any task with `statue == 3` has ready rewards.
   - Logic: Before starting new actions, the task scans `taskList` for `statue == 3` and calls `safe_query("2274", "8", {"commitType": task["type"], "index": task["index"]})` with jitter.

3. **Step 3 — Level Progression**:
   - Observation: `curExp >= needExp` indicates unclaimed level-up rewards.
   - Logic: If eligible, task sends `safe_query("2274", "2", {})` to level up and receive upgrade rewards.

4. **Step 4 — Subtask Filtering & Execution**:
   - Observation: Requirement mandates zero-gold/zero-speedup and safe march handling.
   - Logic:
     - Filter out any task requiring gold or speedups (`consume > 0` or speedup required).
     - Execute all safe zero-march tasks (Types 3, 4, 6) immediately via `safe_query("2274", "5", {"index": task["index"]})`.
     - For march-dependent tasks (Types 2, 5), check 0-Network availability: `self.available_marches > 0` and garrison soldiers > 0.
     - If `self.available_marches <= 0`: Do NOT attempt to dispatch. Since all zero-march tasks (3, 4, 6) are already executed and claimed, trigger the required exit condition:
       `"تتوقف وتخرج بعد إتمام باقي المهام الفرعية إذا اصطدمت بمتطلب إرسال فيلق على الخريطة ولم تكن هناك فيالق متاحة."`

5. **Step 5 — 5-Minute Continuous Loop**:
   - Observation: Requirement specifies 5 minutes continuous operation per cycle.
   - Logic: Run loop with `start_time = time.time()` and `while (time.time() - start_time) < 300:`. Perform task polling, reward collection, subtask execution, and sleep with jitter (4-8s) between iterations. Cleanly exit if blocked on march and no other tasks are runnable.

6. **Step 6 — 6-Stage Pipeline Integration**:
   - Observation: GEMINI.md Rule 3 enforces the 6-stage pipeline.
   - Logic: Map each stage:
     1. `tasks/command_hall.py` + `tasks/__init__.py`
     2. `bot_manager.py` (`REGISTERED_TASKS`, `DEFAULT_BOT_CONFIG`, `reload_config_from_db`)
     3. `api_server.py` (`CastleConfigModel.command_hall`)
     4. `database/castles.db` migration
     5. `dashboard/src/types/index.ts` & `useCastles.ts`
     6. `TaskTabContent.tsx` (dual-save: `performSave` & `handleSave`) + `locales/ar.json`, `en.json`, `tr.json`.

---

## 3. Caveats

1. **First-run network query**: Because the official game server does not push `commandHall` inside CMD 1000 during login, exactly one initial `CMD 2274 / SUBCMD 1` query is required per session to populate live memory. All subsequent checks in the loop operate against live in-memory state.
2. **March types**: `REBEL_ARMY_GROUP_TASK` (Type 1) is a scheduled event march handled primarily by server timing; our active bot actions target Types 2, 3, 4, 5, 6.
3. **Read-Only Explorer role**: In accordance with the explorer archetype, no project source code was modified during this investigation.

---

## 4. Conclusion

The Command Hall system is thoroughly decoded and documented in `analysis.md`. The implementation blueprint for `tasks/command_hall.py` is ready for implementation by the backend builder agent, completely aligned with game client mechanics (CMD 2274, REQ 1/2/3/5/8), zero-gold safety rules, 0-network march checking via `queueCtrl`, 5-minute loop control, and the complete 6-stage pipeline.

---

## 5. Verification Method

1. **Verify Live Memory & Script Inspectability**:
   Run the verification python check:
   ```bash
   python -c "import json; d = json.load(open('docs/beetoo1_live_memory.json', encoding='utf-8')); print('queueCtrl queues:', len(d.get('queueCtrl', {})))"
   ```
2. **Verify Command Hall Protocol References in Game Files**:
   ```bash
   python -c "with open('game_file/src/app/constdef/cmdDef.lua', 'r', encoding='utf-8') as f: [print(l.strip()) for l in f if 'CMD_COMMAND_HALL_MODULE' in l or 'REQ_COMMAND_HALL' in l]"
   ```
3. **Verify Implementation Blueprint**:
   Inspect `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_mem_2\analysis.md` for class structure, 5-minute loop logic, and 6-stage pipeline configuration.
