# Changes Report: Command Hall Lifecycle, March Tracking & Wave Progression Overhaul

**Target**: `tasks/command_hall.py`, `tools/test_command_hall_task.py`, `tools/test_challenger_command_hall.py`  
**Worker**: `teamwork_worker` (`worker_cmd_hall_lifecycle`)  
**Timestamp**: 2026-11-01T15:04:00Z  

---

## 1. Summary of Changes

A complete overhaul of the Command Hall (`CommandHallTask`) subtasks lifecycle, march tracking, network synchronization, and wave progression was implemented to permanently eliminate the 300-second freeze, enable dynamic march arrival tracking, force live network synchronization, and guarantee immediate reward claiming with multi-wave progression.

---

## 2. Detailed Modifications by File

### 2.1 `tasks/command_hall.py`

1. **Elimination of 300-Second Freeze and Introduction of Safety Timeout**:
   - Replaced `LOOP_MAX_DURATION_SECONDS = 300` with `SAFETY_TIMEOUT_SECONDS = 60` and `LOOP_MAX_DURATION_SECONDS = SAFETY_TIMEOUT_SECONDS` (preserving backward compatibility).
   - Removed the broken accumulator exit condition: `has_active_marches = (total_marches > 0)`.
   - Removed `has_preparing_tasks = any(... == TASK_STATUE_PREPARE)` and `elapsed >= 30`.
   - Added `is_task_actionable(t)` logic that accurately distinguishes genuinely actionable tasks from already attacked/claimed tasks. If no actionable tasks remain or no progress is made in an iteration, the task exits immediately with `"تم إنجاز كافة المهام المتاحة بالكامل"`.

2. **Official Lua March Speed Constants & Dynamic Tracking**:
   - Added authoritative constants derived from `queueTimeUtil.lua:327-333` and `commandHallUtil.lua:310-318`:
     - `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` (travel time cap for Rebel Army monsters = 5s)
     - `COMMANDHALL_COMMON_TASK_MARCH_TIME = 2` (travel time cap for common tasks = 2s)
     - `MARCH_DYNAMIC_WAIT_MIN = 6.0`
     - `MARCH_DYNAMIC_WAIT_MAX = 8.5`
   - In `run()`, when `_handle_march_tasks` dispatches marches (`dispatched > 0`), the bot dynamically waits 6.0 to 8.5 seconds (matching 5s travel + 1-2s battle resolution), instead of sleeping 300 seconds.

3. **Force Network Sync (`force_network=True`)**:
   - Enhanced `_ensure_synced_data(force_network=False)`:
     - When `force_network=False`: reads purely from in-memory live data (0-Network Pre-flight).
     - When `force_network=True`: bypasses cache, queries `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`), unpacks `rspdata.initData`, and refreshes `self.conn.init_data["commandHall"]` and `hall_data`.
   - Called immediately after the 6-8.5s march arrival window to retrieve updated task states (`statue == 3` / `TASK_STATUE_FINISH`).

4. **Immediate Reward Claiming**:
   - Enhanced `_claim_finished_tasks(hall_data)`:
     - Scans for all tasks with `statue == TASK_STATUE_FINISH` (3).
     - Also detects Type 1 Rebel Army Group when `hurtHp >= rabelHp`.
     - Claims rewards via `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) with `{"commitType": commit_type, "index": task_index}`.
     - Tracks claimed tasks in `self._claimed_tasks: Set[Tuple[int, int]]` and marks `task["statue"] = 0` locally to prevent duplicate requests.
     - Collects and accumulates `claimed_rewards` (> 0).

5. **Rebel Army Group (Type 1) Defeat & Wave Progression**:
   - Enhanced `_handle_rebel_group_attack()` and added `_handle_wave_progression_after_claim()`:
     - When Type 1 has `hurtHp >= rabelHp` or `statue == 3`, claims it via `CMD 2274 / SUBCMD 8` (`commitType = 1`).
     - Server response unpacks the next wave's tasks (`armyGroupID + 1`) into live memory.
     - Clears `_attacked_rebel_groups` and `_claimed_tasks` for the new wave.
     - The `run()` loop seamlessly continues executing the new wave's subtasks in the same session without delay.

### 2.2 `tools/test_command_hall_task.py`

1. **Enhanced Mock**: Added `custom_responses` hook support to `MockConnection`.
2. **Added `test_11_march_dynamic_tracking_force_sync_and_reward_claim`**:
   - Dispatches a Pioneer march (`CMD 1007 / SubCMD 2`).
   - Verifies dynamic wait between 6.0 and 8.5 seconds (asserts zero long sleeps).
   - Verifies `CMD 2274 / SUBCMD 1` force sync query is dispatched.
   - Verifies `CMD 2274 / SUBCMD 8` reward claim query is sent with `commitType = 2, index = 10`.
   - Asserts `claimed == 1` and clean exit.
3. **Added `test_12_wave_progression_upon_rebel_group_defeat`**:
   - Defeats Wave 1 Rebel Group, claims via `commitType = 1`.
   - Receives Wave 2 (`armyGroupID = 2`) with Dialogue subtask.
   - Executes and claims Wave 2 Dialogue subtask.
   - Asserts `claimed >= 2` and `armyGroupID == 2`.

### 2.3 `tools/test_challenger_command_hall.py`

1. **Imported `REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`**.
2. **Updated `test_07_loop_max_duration_bound`**: Updated to test the 60-second safety timeout bound (`SAFETY_TIMEOUT_SECONDS = 60`).
3. **Added `test_10_challenger_dynamic_march_tracking_and_zero_freeze`**:
   - Adversarial verification of dynamic march tracking (Battle task 5), force sync, immediate claim, and clean termination.
4. **Added `test_11_challenger_army_group_defeat_multi_wave`**:
   - Adversarial verification of multi-wave progression from Wave 5 to Wave 6.

---

## 3. Test Verification Results

| Test Suite | Tests Run | Result | Duration |
|---|---|---|---|
| `tools/test_command_hall_task.py` | 12 | **PASS (12/12)** | 7.9s |
| `tools/test_challenger_command_hall.py` | 11 | **PASS (11/11)** | 13.5s |
| `tools/test_cmd_hall_adversarial.py` | 13 | **PASS (13/13)** | 13.3s |
| **Total Test Suite** | **36** | **PASS (36/36)** | **34.1s** |
