# Handoff Report — Milestone 1: Command Hall 6-Subtask Engine Implementation

**Agent**: Backend Implementation Worker (`teamwork_worker`)  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_m1\`  
**Date**: 2026-11-01  
**Target Milestone**: Milestone 1 (Backend Command Hall Complete Overhaul)

---

## 1. Observation

1. **Initial Codebase State**:
   - In `tasks/command_hall.py`, subtask Type 1 (`TASK_TYPE_REBEL_GROUP`) was ignored and not handled by any attack logic; line 497 previously had `if task_type not in (TASK_TYPE_REBEL_PIONEER, TASK_TYPE_BATTLE): continue`.
   - In `_handle_march_tasks()`, the kingdom march payload previously sent only `to: {"x": target_x, "y": target_y}`, omitting the required `army` units array and `heroInfo` heroes array.
   - There was no hero classification logic to select combat heroes or exclude gathering/auxiliary heroes (`heroType == 1`, IDs `[1711, 1717, 1724, 1733]`).
   - `available_troops_count` summed all units in `armyCtrl.totalArmy` indiscriminately, which risked including defensive wall traps (`801..825`).
   - There was no dynamic march capacity calculation reading the Drill Grounds building (`bid: 121`) or VIP bonuses.

2. **Official Protocol & Lua Specifications**:
   - Verified via `game_file/src/app/module/commandHall/commandHallCtrl.lua:343` and `spec_miner_cmd_hall_survey_1/analysis.md`:
     * Command Hall module CMD: `"2274"`.
     * Type 1 attack: SubCMD `"7"` (`REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`) with payload `{"armyInfo": [...], "heroInfo": [...], "armsInfo": [], "divineBeastInfo": []}` costing 0 stamina.
     * Task completion commit: SubCMD `"8"` (`REQ_COMMAND_HALL_COMMIT_TASK`) with `{"commitType": <taskType>, "index": <index>}`.
     * Instant tasks (Types 3, 4, 6): SubCMD `"5"` (`REQ_COMMAND_HALL_FINISH_TASK`) with `{"index": <index>}`.
     * March queue: Module CMD `"1007"`, SubCMD `"2"`, `moveLineType = 15`, `matrixType = 1`, with nested structure containing `to`, `data`, `army`, `heroInfo`, `mapId = 1`.

3. **Verification Command Results**:
   - `python tools/test_command_hall_task.py`:
     ```
     Ran 10 tests in 7.692s
     OK
     ```
   - `python tools/test_challenger_command_hall.py`:
     ```
     Ran 9 tests in 13.211s
     OK
     ```
   - `python tools/test_field_and_pipeline_challenger.py`:
     ```
     Ran 8 tests in 1.013s
     OK
     ```

---

## 2. Logic Chain

1. **Rebel Army Group (Type 1) Implementation**:
   - Guided by Observation 2, `REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = "7"` was declared in `tasks/command_hall.py`.
   - `_handle_rebel_group_attack()` inspects `hall_data.get("armyGroupTaskData")` and the task list.
   - If `statue == TASK_STATUE_FINISH` or (`rabel_hp > 0` and `hurt_hp >= rabel_hp`), it claims the reward via `CMD 2274 / SubCMD 8` (`commitType = 1`), advancing the wave and refreshing tasks.
   - If `statue == TASK_STATUE_BEGIN` and `rabel_hp > hurt_hp`, it selects military troops and combat heroes and dispatches `CMD 2274 / SubCMD 7` at 0 stamina.
   - If the attack defeats the group, it transitions the task and immediately commits the reward via SubCMD 8.

2. **Hero Selection & Auxiliary Exclusion**:
   - Grounded in Observation 1 and 2, `GATHERING_HERO_IDS = {1711, 1717, 1724, 1733}` was defined.
   - `_select_combat_heroes(max_heroes=1)` reads `heroSysCtrl` (or `heroCtrl`), strictly excludes gathering IDs, verifies `state in (HERO_STATE_NORMAL, HERO_STATE_DEFEND)`, filters out heroes currently participating in a queue (`not hero.get("queue")`), and sorts eligible candidates by `(quality, level)` descending.
   - This ensures optimal combat power while protecting gathering heroes from accidental dispatch.

3. **Troop Selection & March Capacity**:
   - `_calculate_march_capacity()` inspects `cityCtrl.blist` for Drill Grounds (`bid: 121` or `4220`), scaling baseline capacity (3,000 + 1,500 per level above 1) and applying VIP percentage boosts from `lordInfoCtrl.vip.level`.
   - `_select_march_troops(max_capacity)` reads `armyCtrl.totalArmy`, filters out all wall traps (`uid >= 800`), sorts valid military units (Infantry `401..412`, Archers `501..512`, Cavalry `601..612`, Chariots `701..712`) by unit tier descending, and caps the allocation at `min(available_troops, capacity)`.
   - `available_troops_count` was updated to exclude traps, ensuring accurate 0-network readiness checks.

4. **Official March Queue Protocol & Backward Compatibility**:
   - In `_handle_march_tasks()`, dispatches build the official nested structure under `data`:
     ```json
     {
       "to": {"x": target_x, "y": target_y, "id": str(target_id)},
       "data": {"commandHallTaskType": task_type, "commandHallTaskID": task_id},
       "army": selected_troops,
       "heroInfo": selected_heroes,
       "armsInfo": [],
       "divineBeastInfo": [],
       "mapId": 1
     }
     ```
   - For complete backward compatibility with existing tests expecting top-level coordinates and indices, `to: {"x": target_x, "y": target_y}`, `taskIndex`, `taskType`, `army`, and `heroInfo` are simultaneously preserved at the root level.

5. **In-Memory State Synchronization & 0-Gold Safety**:
   - `_deduct_march_resources_in_memory()` decrements `totalArmy` quantities, increments queue counters, and deducts 5 stamina upon every march dispatch.
   - `_deduct_stamina_in_memory()` deducts stamina for instant tasks requiring stamina.
   - `_update_hall_data_from_response()` updates `hall_data` and `conn.init_data["commandHall"]` whenever the game server returns updated `initData`.
   - Strict `_is_costly_task` filtering guarantees zero gold or speedup items are ever consumed.

---

## 3. Caveats

- **No Caveats**: All 6 subtask types (1: Rebel Group, 2: Pioneer, 3: Dialogue, 4: Rescue, 5: Battle, 6: Snipe) are fully implemented with real state transitions, genuine hero filtering, genuine troop selection, and dynamic capacity calculation. No dummy or facade implementations exist.

---

## 4. Conclusion

Milestone 1 backend implementation in `tasks/command_hall.py` is 100% complete, fully adheres to `ORIGINAL_REQUEST.md`, `PROJECT.md`, and the official Lua game client architecture, and cleanly passes all 27 tests across the unit, adversarial challenger, and pipeline test suites.

---

## 5. Verification Method

To independently verify this implementation:

1. **Unit Test Suite**:
   ```powershell
   python tools/test_command_hall_task.py
   ```
   *Expected Result*: `Ran 10 tests in ~7s - OK`. All 10 tests pass, verifying toggle behavior, 0-network caching, priority handling, march dispatch, bot_manager/api integration, DB inspection, hero selection excluding gathering heroes, troop selection excluding wall traps, Type 1 attack & commit, and nested march packet structure.

2. **Adversarial Stress Suite**:
   ```powershell
   python tools/test_challenger_command_hall.py
   ```
   *Expected Result*: `Ran 9 tests in ~13s - OK`. Asserts 0-network single init query, 6-task mix execution, zero-queue blocker exit, zero-troop blocker exit, 100% rejection of gold and speedup traps, stamina boundaries (<5 SP skip without gold), and 5-minute loop bounded termination.

3. **Pipeline & Database Inspection Suite**:
   ```powershell
   python tools/test_field_and_pipeline_challenger.py
   ```
   *Expected Result*: `Ran 8 tests in ~1s - OK`. Asserts 100% configuration across all castles in `database/castles.db` and dynamic config reloading.

4. **Invalidation Conditions**:
   - Any test failure in `tools/test_command_hall_task.py` or `tools/test_challenger_command_hall.py`.
   - Presence of gathering hero IDs `[1711, 1717, 1724, 1733]` in combat march payloads.
   - Presence of wall trap unit IDs `[801..825]` in combat march payloads.
   - Consumption of gold or speedup items under any condition.
