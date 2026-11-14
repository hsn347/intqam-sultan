# Handoff Report: Empirical Stress Testing of Command Hall Lifecycle

- **Agent**: `teamwork_challenger` (critic, specialist)
- **Role**: Empirical Challenger
- **Assignment**: Independent stress testing of overhauled `tasks/command_hall.py`
- **Timestamp**: 2026-11-01T15:18:00Z
- **Verdict**: **REQUEST_CHANGES**

---

## 1. Observation

1. **Fast March Arrival & Forced Sync Verified**:
   - `tasks/command_hall.py:70-73` sets `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`, `MARCH_DYNAMIC_WAIT_MIN = 6.0`, `MARCH_DYNAMIC_WAIT_MAX = 8.5`.
   - In `tools/test_empirical_lifecycle.py` tests `test_01` and `test_02`, Pioneer (Type 2) and Battle (Type 5) were dispatched via `CMD 1007 / SubCMD 2`.
   - Observed dynamic sleep times: `7.0s` and `6.4s` (strictly within `[6.0, 8.5]`).
   - Immediately following the sleep, `CMD 2274 / SubCMD 1` (`force_network=True`) was transmitted.
   - Upon receipt of `statue == 3`, `CMD 2274 / SubCMD 8` was transmitted, returning `claimed == 1`.
   - Total test execution time: 0.017s.

2. **Freeze Elimination Benchmarking Verified**:
   - Measured across 5 scenarios in `tools/test_empirical_lifecycle.py:test_03`:
     - Empty tasks: simulated sleep `0.00s`, wall-clock `0.0007s`.
     - Finished tasks: simulated sleep `1.23s`, wall-clock `0.0006s`.
     - March task with dynamic wait: simulated sleep `10.23s`, wall-clock `0.0013s`, max single sleep `8.20s`.
     - Multi-wave progression (sunny-day): simulated sleep `2.47s`, wall-clock `0.0008s`.
     - Blocked resources: simulated sleep `0.00s`, wall-clock `0.0003s`.
   - The legacy 300-second freeze is eliminated from normal operations.

3. **Critical Vulnerability Observed in Adversarial Testing**:
   - In `tools/test_empirical_lifecycle.py:test_11_adversarial_vulnerability_duplicate_claim_and_infinite_loop`:
     ```
     AssertionError: 10 != 1 : CRITICAL VULNERABILITY: Rebel Army Group (index 1) was claimed 10 times!
     Duplicate/infinite claiming detected! High account BAN risk!
     Queries: [{'commitType': 1, 'index': 1}, {'commitType': 1, 'index': 1}, ...]
     ```
   - When a Rebel Army Group is defeated:
     - In `tasks/command_hall.py:1048`, `_claim_finished_tasks` sends `CMD 2274 / SubCMD 8` (`commitType = 1, index = 1`).
     - In line 679, `_claim_finished_tasks` calls `_handle_wave_progression_after_claim`, which executes `self._claimed_tasks.clear()` (line 469).
     - In line 1059, in the EXACT SAME loop iteration, `_handle_rebel_group_attack` checks `if status == TASK_STATUE_FINISH or (rabel_hp > 0 and hurt_hp >= rabel_hp):` (line 745). Because `_claimed_tasks` was just wiped and `status != 0` is not checked, it sends `CMD 2274 / SubCMD 8` (`commitType = 1, index = 1`) a SECOND TIME.
     - When the server response does not contain a new `armyGroupTaskData` (e.g. daily quota exhausted or wave has only common tasks), `hall_data["armyGroupTaskData"]` retains the old defeated group because `hall_data.update(init_data)` (line 450) does not purge missing keys.
     - In subsequent loop iterations, because lines 654-658, line 745, and line 1137 check `hurt_hp >= rabel_hp` without verifying `status != 0`, the bot enters an infinite loop spamming the game server with claim requests until the safety timeout.

---

## 2. Logic Chain

1. From Observation 1, the dynamic 6.0-8.5s sleep and forced network sync (`CMD 2274 / SUBCMD 1`) accurately match official Lua march timings and succeed in retrieving updated server states.
2. From Observation 2, execution times in normal scenarios are well within acceptable bounds (< 15 seconds total).
3. From Observation 3, when Rebel Army Group (Type 1) is defeated:
   - Line 1048 (`_claim_finished_tasks`) and line 1059 (`_handle_rebel_group_attack`) both implement claim logic for Type 1.
   - Calling `self._claimed_tasks.clear()` in line 469 unconditionally deletes tracking of already-claimed tasks.
   - Lines 657, 745, and 1137 check `hurt_hp >= rabel_hp` without checking `status != 0` (even though lines 677 and 761 set `statue = 0` to denote a completed task).
   - Incomplete server updates leave stale `armyGroupTaskData` in memory.
4. Therefore, whenever a group is defeated and a replacement group is not immediately provided by the server, the bot double-claims in iteration 1 and repeatedly claims in an infinite loop across subsequent iterations.
5. In accordance with GEMINI.md Rule 2 ("المشروع خطير للغاية: أي خطأ أو طلب مشبوه قد يؤدي فوراً إلى حظر حسابات القلاع BAN"), this defect is a critical ban risk and cannot be accepted into production.

---

## 3. Caveats

- In sunny-day scenarios where the server always supplies a new `armyGroupTaskData` with `hurtHp = 0` on every single wave transition, the loop advances without immediately repeating the old group. However, in live production, daily wave limits (`tomorrowArmyGroupTaskData`) or waves consisting solely of Common Tasks will trigger the infinite loop defect.
- No other regressions were observed: all 36 tests in the existing suites pass without errors.

---

## 4. Conclusion

**Verdict: REQUEST_CHANGES**

The worker must address the 4 specific code fixes in `tasks/command_hall.py`:
1. **Deduplicate Claiming**: Ensure Rebel Army Group claiming is handled in only ONE location (either `_claim_finished_tasks` or `_handle_rebel_group_attack`, not both).
2. **Check `status != 0`**:
   - `_claim_finished_tasks:654`: Add `status != 0`.
   - `_handle_rebel_group_attack:745`: Add `status != 0`.
   - `is_task_actionable:1124`: Add `if st == 0: return False`.
3. **Purge Defeated Group from Memory**: Upon successful claim or receipt of `tomorrowArmyGroupTaskData`, explicitly pop `armyGroupTaskData` from `hall_data` and `conn.init_data["commandHall"]` if no new group is provided.
4. **Wave-Scoped Claim Tracking**: Key claims by `(wave_id, commit_type, task_index)` instead of blindly executing `self._claimed_tasks.clear()`.

---

## 5. Verification Method

To reproduce and verify the critical defect and the general lifecycle tests:

```powershell
# 1. Run the empirical lifecycle suite (demonstrates the vulnerability in test_11):
python tools/test_empirical_lifecycle.py

# 2. Run the existing 36 tests:
python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py
```

Expected result after fixes are implemented by worker:
- All 11 tests in `tools/test_empirical_lifecycle.py` must pass with 0 failures, 0 errors, and exactly 1 claim per group.
- All 36 existing tests must continue to pass.
