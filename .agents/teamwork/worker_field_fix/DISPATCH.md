## 2026-11-01T18:49:29Z
You are teamwork_worker.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_field_fix\
You MUST read the authoritative request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

You have exclusive write ownership of `tasks/command_hall.py`.
Live field testing on actual game gateways (`beetoo3@hotmail.com`) identified two critical defects preventing march placement and reward claiming:
1. Missing Coordinate Translation (Gateway Error 8002):
   - In `tasks/command_hall.py` in `_handle_march_tasks` (around lines 974-980), raw server coordinates from `task.obj` are sent directly.
   - The Revenge of Sultans engine (`mapSyncUtilClient.lua:serverTOClientPos`) requires tile coordinates (`tile = server - 1`). When the client sends tile coordinates, the server adds `+1, +1`.
   - Fix:
     ```python
     server_x, server_y = coords
     target_x, target_y = max(0, server_x - 1), max(0, server_y - 1)
     ```
2. Silent Error Suppression:
   - Around line 1045, `if res is not None:` is used. Because `safe_query` returns the error dictionary `{"cmd": "1007", "subcmd": "2", "err": "8002"}`, the bot falsely assumes success, waits, finds the task still incomplete on the server, and loops until timeout with 0 rewards.
   - Fix:
     ```python
     is_success = (
         isinstance(res, dict)
         and str(res.get("err", "0")) in ("0", "", "None")
         and (res.get("queueId") or not res.get("err") or str(res.get("err")) == "0")
     )
     ```
     If not `is_success`: log the error and do NOT increment `dispatched` or deduct troops in memory.

Read `e:\intqam-sultan\.agents\teamwork\field_tester_m3\handoff.md` for complete details.

Apply these two fixes in `tasks/command_hall.py`.
Run all test suites and ensure 100% of unit, empirical, and adversarial tests pass:
```powershell
python tools/test_empirical_lifecycle.py
python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py tools/test_adversarial_lifecycle.py
python tools/test_adversarial_retest_r2.py
```
(If any mock in unit tests expects raw coordinates, update the mock helper to accept the `server - 1` coordinate).

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Write your changes report to `e:\intqam-sultan\.agents\teamwork\worker_field_fix\changes.md` and deliver `e:\intqam-sultan\.agents\teamwork\worker_field_fix\handoff.md`.
Send a completion message back when done.
