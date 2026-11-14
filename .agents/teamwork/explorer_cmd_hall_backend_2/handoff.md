# Handoff Report: Command Hall Backend Architecture & Gap Analysis

**From**: teamwork_explorer (`explorer_cmd_hall_backend_2`)  
**To**: Orchestrator / Implementer  
**Date**: 2026-11-01  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_backend_2`  
**Reference Documents**: `ORIGINAL_REQUEST.md`, `GEMINI.md`, `PROJECT_STRUCTURE.md`, `analysis.md`

---

## 1. Observation

1. **Missing Troops & Heroes in March Payload**:
   In `tasks/command_hall.py` lines 527–540:
   ```python
   march_payload = {
       "to": {"x": target_x, "y": target_y},
       "moveLineType": MOVE_LINE_TYPE_COMMAND_HALL_NPC,
       "matrixType": MOVE_LINE_MATRIX_TYPE_TROOP,
       "taskIndex": task_index,
       "taskType": task_type,
   }
   res = await self.safe_query(
       CMD_KINGDOM_QUEUE_MODULE,
       REQ_ADD_KINGDOM_QUEUE,
       march_payload,
       ...
   )
   ```
   Directly observed: `march_payload` has NO `army` (troops list) field, and NO `heroInfo` field.
   In official game client `game_file/src/app/game/worldMap/worldMapFunction.lua:206-222` and `WorldDispatchArmyViewPanel.lua:1360-1370`, the dispatch requires:
   - `army`: `[ {"id": unit_id, "num": count}, ... ]`
   - `heroInfo`: `[ {"heroID": hero_id} ]`
   - `armsInfo`: `[]`
   - `divineBeastInfo`: `[]`
   - `data`: `{"commandHallTaskType": task_type, "commandHallTaskID": task_id}`.

2. **Absence of Hero Selection & Gathering Hero Exclusion**:
   - `tasks/command_hall.py` has zero hero retrieval or filtering logic.
   - In `conn.init_data["heroSysCtrl"]["heroList"]`, heroes have `heroID`, `state`, `quality`, `level`.
   - In `app/constdef/heroDef.lua:56-62`, `HERO_STATE_NORMAL = 1` and `HERO_STATE_DEFEND = 5` are eligible, while `HERO_STATE_BATTLE = 4`, `HERO_STATE_DEAD = 2`, `HERO_STATE_CAPTURED = 3` are ineligible.
   - In `app/localtb/config_client/hero_type_info.lua:1-6` and `hero_view_info.lua`, `heroType == 1` represents Auxiliary / Support / Gathering heroes (`hero_typename_01` = "نوع الدعم"), specifically IDs `[1711, 1717, 1724, 1733]`. Types `2, 3, 4, 5` represent combat heroes.

3. **Absence of Rebel Army Group (Type 1) Attack**:
   - In `tasks/command_hall.py` line 497: `if task_type not in (TASK_TYPE_REBEL_PIONEER, TASK_TYPE_BATTLE): continue`.
   - `TASK_TYPE_REBEL_GROUP = 1` is completely excluded from execution.
   - In `game_file/src/app/module/commandHall/commandHallCtrl.lua:343-350` and `fgui/gcomponent/CommandHall/Com_MainReward.lua:235`, Type 1 is attacked via `CMD 2274 / SubCMD 7` (`REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`) with 0 stamina consumption. Defeating it renews the task list. When finished (`statue == 3`), its reward is claimed via `CMD 2274 / SubCMD 8` (`commitType: 1, index: task.index`).

4. **Dialogue and Silent Sniper Verification**:
   - In `fgui/views/CommandHall/CommandHallTalkPanel.lua:65-67`, dialogue options are client-side UI only. At dialogue completion, `commandHallCtrl:reqFinishTask(index)` (`CMD 2274 / SubCMD 5`) is called with `{"index": task.index}`.
   - In `commandHallCtrl.lua:185-197` and `CommandHallMainPanel.lua:590-616`, completing Silent Sniper sends `commandHallCtrl:reqFinishTask(index)` (`CMD 2274 / SubCMD 5`) directly.
   - Both tasks convert to `statue == 3` (FINISH) and their rewards are claimed via `CMD 2274 / SubCMD 8`.

5. **Pipeline and Database State**:
   - Inspected `bot_manager.py:88`: `CommandHallTask` is registered in `REGISTERED_TASKS`, `DEFAULT_BOT_CONFIG:187`, and `reload_config_from_db():282`.
   - Inspected `api_server.py:384`: `command_hall: Optional[SimpleToggleConfig] = None` is whitelisted.
   - Inspected `database/castles.db` (`castle_states` table): all 4 accounts have `command_hall` populated in `config` and `tasks`.
   - Inspected `dashboard/src`: Types, Hooks, Locales (ar, en, tr), and Dual-Save in `TaskTabContent.tsx` are already implemented. Only the backend task `tasks/command_hall.py` requires enhancement.

---

## 2. Logic Chain

1. **Step 1 (March Dispatch Legitimacy)**: Because official game servers validate the presence of army units and hero assignments in `CMD 1007 / SubCMD 2` marches, sending an empty payload causes either command rejection (`Err_COMMAND_HALL_ARMY_ILLEGAL`) or instant battle defeat. Therefore, `tasks/command_hall.py` must populate `army` and `heroInfo`.
2. **Step 2 (March Capacity & Troop Selection)**: Because sending more troops than allowed causes dispatch failure, and sending too few causes battle defeat against high-level NPCs, calculating march capacity from Drill Grounds building (`bid: 121` in `cityCtrl.blist`, base capacity 3000+) and selecting available units up to `min(total_available, march_capacity)` guarantees valid and victorious marches.
3. **Step 3 (Combat Hero Prioritization)**: Because gathering heroes (IDs `1711, 1717, 1724, 1733` with `heroType == 1`) provide non-combat gathering buffs, excluding them and picking combat heroes (`heroType in (2, 3, 4, 5)`) with `state in (1, 5)` sorted by highest quality and level fulfills R1 and maximizes combat effectiveness.
4. **Step 4 (Rebel Army Group Integration)**: Because `armyGroupTaskData` represents the castle-attacking rebel army (Type 1), attacking it via `CMD 2274 / SubCMD 7` consumes 0 stamina, requires no world map queue, and resets the task list upon victory, fulfilling R2.
5. **Step 5 (Dialogue & Sniper Protocol Matching)**: Because dialogue choices and sniper mini-game are client-side presentations that culminate in `CMD 2274 / SubCMD 5` (`REQ_COMMAND_HALL_FINISH_TASK`), invoking SubCMD 5 with `{"index": task.index}` executes them directly over network packets without graphical simulation, fulfilling R3.
6. **Step 6 (Zero-Gold & Memory Isolation)**: Because the game rules and `GEMINI.md` forbid gold spending and excessive network queries, enforcing `stamina >= 5` checks, deducting dispatched troops/queues/stamina locally in memory, and isolating all exceptions within `try...except` fulfills R4.

---

## 3. Caveats

1. **Drill Grounds Availability**: In low-level castles without a Drill Grounds building, the base capacity defaults safely to 3,000 units.
2. **Hero Availability**: If all combat heroes are currently in active marches (`state == 4`) or absent, the march can safely dispatch with troops and an empty hero list (`heroInfo: []`).
3. **Rebel Army Group (Type 1) Battle Outcome**: While Type 1 costs 0 stamina, if a castle has 0 troops, sending an attack might fail with `Err_COMMAND_HALL_ARMY_ILLEGAL`; the implementation should check `available_troops_count > 0` before sending `CMD 2274 / SubCMD 7`.

---

## 4. Conclusion

The existing `tasks/command_hall.py` provides a solid foundational structure (`BaseTask` inheritance, `0-Gold` filtering, 5-minute loop, level upgrading, reward claiming), but requires targeted backend refactoring to fulfill R1, R2, R3, and R4:
1. Add `_select_combat_heroes()` to pick qualified combat heroes while excluding gathering heroes (1711, 1717, 1724, 1733).
2. Add `_calculate_march_capacity()` and `_select_march_troops()` to compose valid unit arrays for marches.
3. Update `_handle_march_tasks()` to include `army`, `heroInfo`, and metadata in `CMD 1007 / SubCMD 2`.
4. Add `_handle_rebel_group_attack()` for Type 1 (`CMD 2274 / SubCMD 7`) and claim its rewards.
5. Ensure `_execute_instant_tasks()` handles Type 3 (Dialogue), Type 4 (Rescue), and Type 6 (Sniper) uniformly via `CMD 2274 / SubCMD 5`.
6. Maintain in-memory state synchronization and zero-gold protections.

---

## 5. Verification Method

1. **Static Analysis & Unit Test**:
   - Inspect `tasks/command_hall.py` methods and verify all 6 subtask types are handled.
   - Run adversarial unit test suite: `python tools/test_challenger_command_hall.py` and `python tools/test_reverification_challenger_deep.py`.
2. **Field Live Execution**:
   - Run live test on database castles: `python tools/field_test_command_hall.py`.
   - Verify that:
     * `_ensure_synced_data` retrieves or synchronizes `commandHall` data.
     * Type 1 attack is executed when present.
     * March payload contains formatted `army` and `heroInfo`.
     * Instant tasks (3, 4, 6) complete via SubCMD 5.
     * Rewards are claimed via SubCMD 8.
     * Zero gold and zero speedups are consumed.
