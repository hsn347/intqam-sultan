## 2026-11-01T15:06:10Z
You are teamwork_challenger.
Your working directory is: e:\intqam-sultan\.agents\teamwork\challenger_empirical_lifecycle\
You MUST read the authoritative request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

You are assigned to perform empirical stress testing of the overhauled `tasks/command_hall.py`.
Read:
- `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\handoff.md`
- `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\changes.md`

Your mission is to write and execute an empirical test script in `tools/` (e.g. `tools/test_empirical_lifecycle.py`) to stress-test the new lifecycle:
1. Fast March Arrival & Forced Sync:
   - Simulate a world map march (Type 2 Pioneer and Type 5 Battle).
   - Verify that the task waits ~6-8.5 seconds (matching `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`s) and then sends `CMD 2274 / SUBCMD 1`.
   - Verify that server response updating `statue` to 3 triggers immediate `CMD 2274 / SUBCMD 8` claiming.
2. Freeze Elimination:
   - Assert with high precision that the total execution time of `run_once()` across various scenarios (no tasks, march tasks, wave renewal) never exceeds 20-30 seconds. Assert that the 300-second freeze is 100% eliminated.
3. Multi-Wave Progression:
   - Simulate defeat of Rebel Army Group (Type 1), returning wave N+1.
   - Verify that the task seamlessly processes wave N+1 tasks without restarting the bot.
4. Run all tests and your new empirical script:
   ```powershell
   python tools/test_empirical_lifecycle.py
   python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py
   ```

Write your findings to `e:\intqam-sultan\.agents\teamwork\challenger_empirical_lifecycle\analysis.md` and deliver `e:\intqam-sultan\.agents\teamwork\challenger_empirical_lifecycle\handoff.md` with an explicit verdict: `APPROVE` or `REQUEST_CHANGES`.
Send a completion message back when done.
