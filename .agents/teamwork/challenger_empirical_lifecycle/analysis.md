# Empirical Analysis Report: Command Hall Lifecycle Stress Testing

- **Author**: `teamwork_challenger` (Empirical Challenger)
- **Target**: `tasks/command_hall.py` (Overhauled by `worker_cmd_hall_lifecycle`)
- **Date**: 2026-11-01
- **Verdict**: **REQUEST_CHANGES** (1 Critical Vulnerability Found)

---

## 1. Executive Summary

The overhaul of `tasks/command_hall.py` by the worker successfully solved several core requirements from `ORIGINAL_REQUEST.md`:
1. **Dynamic March Wait Verified**: The legacy 300-second freeze after march dispatch was eliminated. Marches now dynamically wait 6.0 to 8.5 seconds (matching `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`s plus battle computation).
2. **Post-March Forced Network Sync Verified**: Immediately following march arrival, the task sends `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`, `force_network=True`), updating live memory with server state.
3. **Immediate Reward Claiming Verified**: Completed tasks (`statue == 3`) are claimed via `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`), collecting rewards (> 0).
4. **Execution Time Benchmarking**: Total loop duration in normal scenarios dropped from 300 seconds to 0.00s - 10.23s.

**HOWEVER, adversarial stress testing revealed a CRITICAL DEFECT**:
When a Rebel Army Group (Type 1) is defeated, the current code exhibits **duplicate claiming in the same iteration** and an **infinite loop spamming the game server with claim requests** if the server does not immediately provide a fresh monster for the next wave, or when all daily waves are exhausted. This violates **GEMINI.md Rule 2** (Zero Suspicious Requests / Ban Prevention) and **GEMINI.md Rule 4** (Event Loop / CPU protection).

---

## 2. Empirical Benchmark Matrix

Testing was performed via `tools/test_empirical_lifecycle.py` (11 tests) and verified against the existing 36 tests in `tools/test_command_hall_task.py`, `tools/test_challenger_command_hall.py`, and `tools/test_cmd_hall_adversarial.py`.

### Benchmark Results Across Scenarios

| Scenario | Objective | Simulated Sleep | Wall-Clock | Claims | Marches | Result |
|---|---|---|---|---|---|---|
| **Scenario A** | Empty Tasks / No tasks available | 0.00s | 0.0007s | 0 | 0 | **PASS** (Terminates immediately) |
| **Scenario B** | Completed tasks ready for claim | 1.23s | 0.0006s | 2 | 0 | **PASS** (Claims and exits cleanly) |
| **Scenario C** | March task (Type 2 Pioneer, 5s travel) | 10.23s | 0.0013s | 1 | 1 | **PASS** (6-8.5s dynamic wait + sync + claim) |
| **Scenario D** | Wave progression (Wave 1 -> Wave 2) | 2.47s | 0.0008s | 2 | 0 | **PASS** (Sunny day: fresh group in Wave 2) |
| **Scenario E** | Blocked resources (0 troops / 0 marches) | 0.00s | 0.0003s | 0 | 0 | **PASS** (Clean exit without hanging) |
| **Test 01** | Type 2 Pioneer March Arrival & Sync | 7.00s (single) | 0.008s | 1 | 1 | **PASS** (Order: March -> Sync -> Claim) |
| **Test 02** | Type 5 Battle March Arrival & Sync | 6.40s (single) | 0.008s | 1 | 1 | **PASS** (Order: March -> Sync -> Claim) |
| **Test 05** | 3-Wave Chain Progression | ~0s (mocked) | 0.009s | 4 | 0 | **PASS** (Wave 1 -> 2 -> 3) |
| **Test 09** | Gathering Hero Exclusion (1711, 1717...) | 0s | 0.010s | 0 | 1 | **PASS** (Zero gathering heroes in march) |
| **Test 10** | Safety Timeout Constant Integrity | 0s | 0.001s | N/A | N/A | **PASS** (`SAFETY_TIMEOUT = 60s`) |
| **Test 11** | **Adversarial Group Claim & Infinite Loop** | N/A | 0.012s | **10 duplicate claims** | 0 | **FAIL (CRITICAL BUG)** |

---

## 3. Forensic Root Cause Analysis of Critical Defect

### 3.1 Failure Manifestation
In `tools/test_empirical_lifecycle.py::test_11_adversarial_vulnerability_duplicate_claim_and_infinite_loop`:
```
AssertionError: 10 != 1 : CRITICAL VULNERABILITY: Rebel Army Group (index 1) was claimed 10 times!
Duplicate/infinite claiming detected! High account BAN risk!
Queries: [{'commitType': 1, 'index': 1}, {'commitType': 1, 'index': 1}, ...]
```
In a live environment, sending multiple claim packets for an already claimed boss within seconds triggers official game server fraud heuristics and results in an immediate castle ban (Rule 2).

### 3.2 Four Interconnected Code Deficiencies

#### Deficiency 1: Dual Claiming in a Single Loop Iteration
- In `tasks/command_hall.py:1048`:
  `claimed = await self._claim_finished_tasks(hall_data)`
  Checks `commit_type == TASK_TYPE_REBEL_GROUP and hurt_hp >= rabel_hp` (lines 654-658).
  Sends `CMD 2274 / SUBCMD 8` (`commitType = 1, index = task_index`).
  Then calls `self._handle_wave_progression_after_claim(hall_data, res)` (line 679).
- In `tasks/command_hall.py:1059` (only 11 lines later in the exact same iteration):
  `group_action = await self._handle_rebel_group_attack(hall_data)`
  Inside `_handle_rebel_group_attack` (line 745):
  `if status == TASK_STATUE_FINISH or (rabel_hp > 0 and hurt_hp >= rabel_hp):`
  It sends `CMD 2274 / SUBCMD 8` (`commitType = 1, index = task_index`) **A SECOND TIME**!

#### Deficiency 2: Indiscriminate Wiping of Claim Tracking
- In `tasks/command_hall.py:468-469`:
  ```python
  def _handle_wave_progression_after_claim(self, hall_data: Dict[str, Any], res: Any) -> None:
      ...
      self._attacked_rebel_groups.clear()
      self._claimed_tasks.clear()
  ```
  When `_claim_finished_tasks` claims the group and adds `(1, task_index)` to `_claimed_tasks`, it immediately calls `_handle_wave_progression_after_claim()`.
  This method calls `self._claimed_tasks.clear()`, wiping the recorded claim.
  When `_handle_rebel_group_attack` checks `if task_key in self._claimed_tasks:` in line 747, it evaluates to `False`, causing the immediate second claim.

#### Deficiency 3: Ignoring `status == 0` (Claimed State)
- In line 677 and line 761:
  `task["statue"] = 0  # وسم المهمة كمكتملة في الذاكرة المحلية`
  `group_task["statue"] = 0`
  The code sets `statue = 0` to denote that the task has been claimed.
- However, lines 654-658, line 745, and line 1137 check:
  `if rabel_hp > 0 and hurt_hp >= rabel_hp:`
  **without checking `status != 0`**!
  Even though `status` is 0, because `hurt_hp >= rabel_hp` remains true, the task is still evaluated as `is_claimable = True` and `is_task_actionable = True`.

#### Deficiency 4: Lingering Stale `armyGroupTaskData`
- In `tasks/command_hall.py:450`:
  `hall_data.update(init_data)`
  When all daily waves are cleared, or when a wave only contains common tasks, `init_data` from the server contains `tomorrowArmyGroupTaskData` or does not contain `armyGroupTaskData`.
  Because `dict.update()` only mutates keys present in `init_data`, `hall_data["armyGroupTaskData"]` remains untouched in memory with `hurtHp >= rabelHp`.
  Coupled with Deficiencies 1, 2, and 3, the bot loops endlessly claiming the defeated group until safety timeout (or account ban).

---

## 4. Required Action Items for Worker (`REQUEST_CHANGES`)

1. **Deduplicate Rebel Group Claiming**:
   Rebel Army Group (Type 1) claiming must occur in **only one place**. If `_claim_finished_tasks` claims it, `_handle_rebel_group_attack` must NOT send a duplicate claim.
2. **Strictly Respect `statue == 0`**:
   - In `_claim_finished_tasks`:
     ```python
     if status != 0 and (status == TASK_STATUE_FINISH or (commit_type == TASK_TYPE_REBEL_GROUP and rabel_hp > 0 and hurt_hp >= rabel_hp)):
     ```
   - In `_handle_rebel_group_attack`:
     ```python
     if status == 0 or task_key in self._claimed_tasks:
         return False
     ```
   - In `is_task_actionable`:
     ```python
     if st == 0:
         return False
     ```
3. **Clean Up Defeated Group Upon Claim**:
   When Type 1 is claimed, remove `armyGroupTaskData` from `hall_data` (`hall_data.pop("armyGroupTaskData", None)`) unless a fresh group with `hurtHp < rabelHp` and `statue == TASK_STATUE_BEGIN` is explicitly returned in `initData`.
4. **Wave-Scoped Claim Tracking**:
   Include `wave_id` in claim keys, e.g. `(wave_id, commit_type, task_index)`, so that claims are permanently remembered without requiring `self._claimed_tasks.clear()`.

---

## 5. Summary Verdict

| Component | Status | Finding |
|---|---|---|
| **Freeze Elimination** | **VERIFIED** | 300s sleep eliminated; loop finishes in < 15s. |
| **Fast March Arrival** | **VERIFIED** | 6.0-8.5s dynamic wait + forced sync verified. |
| **Reward Claiming** | **VERIFIED** | SubCMD 8 dispatches and claims rewards. |
| **Multi-Wave Progression** | **DEFECT** | Critical duplicate claim & infinite loop vulnerability on group defeat. |
| **Overall Verdict** | **REQUEST_CHANGES** | Worker must fix the 4 deficiencies outlined above. |
