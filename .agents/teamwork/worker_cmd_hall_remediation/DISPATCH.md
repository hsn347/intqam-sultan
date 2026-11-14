## 2026-11-01T15:19:50Z
You are teamwork_worker.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_remediation\
You MUST read the authoritative request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

You have exclusive write ownership of `tasks/command_hall.py`.
An empirical challenger identified a critical vulnerability in `tasks/command_hall.py` (duplicate claiming and infinite loop claiming defeated Rebel Army Group when server provides no new group or daily limit is reached).

Read the challenger's reports:
- `e:\intqam-sultan\.agents\teamwork\challenger_empirical_lifecycle\handoff.md`
- `e:\intqam-sultan\.agents\teamwork\challenger_empirical_lifecycle\analysis.md`
- Inspect `tools/test_empirical_lifecycle.py` (specifically `test_11`).

Implement the 4 required code fixes in `tasks/command_hall.py`:
1. Deduplicate Claiming:
   - Ensure Rebel Army Group (Type 1) claiming is handled in only ONE centralized place (preferably in `_claim_finished_tasks` or in `_handle_rebel_group_attack`, not both).
2. Check `status != 0`:
   - In `_claim_finished_tasks` (around line 654): ensure `status != 0` before checking `hurt_hp >= rabel_hp` or `statue == 3`.
   - In `_handle_rebel_group_attack` (around line 745): ensure `status != 0` before attempting claim.
   - In `is_task_actionable` (around line 1124): ensure `if st == 0: return False`.
3. Purge Defeated Group from Memory:
   - When a Rebel Army Group is claimed or when `tomorrowArmyGroupTaskData` is received, explicitly pop `armyGroupTaskData` from `hall_data` and `conn.init_data["commandHall"]` if no new group is provided or if `statue == 0`.
4. Wave-Scoped Claim Tracking:
   - Key claims by `(wave_id, commit_type, task_index)` (where `wave_id` is `armyGroupID` or current wave) instead of blindly clearing `self._claimed_tasks.clear()`.

Verification:
- Run `python tools/test_empirical_lifecycle.py` and verify all 11 tests pass (specifically `test_11` must pass with 0 duplicate claims and 0 infinite loop).
- Run the full regression test suite:
  ```powershell
  python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py tools/test_adversarial_lifecycle.py
  ```
- Ensure 100% of tests pass without regressions.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Write your changes report to `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_remediation\changes.md` and deliver `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_remediation\handoff.md`.
Send a completion message back when done.
