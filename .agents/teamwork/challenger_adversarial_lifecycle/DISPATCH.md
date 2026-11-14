## 2026-11-01T15:06:18Z
You are teamwork_challenger.
Your working directory is: e:\intqam-sultan\.agents\teamwork\challenger_adversarial_lifecycle\
You MUST read the authoritative request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

You are assigned to perform adversarial edge-case stress testing on `tasks/command_hall.py`.
Read:
- `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\handoff.md`
- `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\changes.md`

Your mission is to write and execute an adversarial test script in `tools/` (e.g. `tools/test_adversarial_lifecycle.py`) to verify resilience:
1. Zero Troops & March Blocker:
   - When 0 troops or no march queues exist, verify that the task safely executes zero-army instant tasks (Types 3, 4, 6), skips march tasks (Types 2, 5), claims rewards, and exits cleanly in < 5 seconds without raising exceptions.
2. Network Sync Failure Post-March:
   - Simulate a network timeout or `err != "0"` during post-march `force_network` sync.
   - Verify the task catches the error gracefully, does not crash or stall, and exits cleanly.
3. Malformed/Empty Server Data:
   - Test empty `commandHall`, missing `armyGroupTaskData`, corrupted coordinates, non-integer IDs.
   - Verify 100% crash immunity.
4. Strict Zero-Gold spend invariant:
   - Verify that gold balance never decreases in any scenario.
5. Execute your adversarial test and the full test suite:
   ```powershell
   python tools/test_adversarial_lifecycle.py
   python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py
   ```

Write your findings to `e:\intqam-sultan\.agents\teamwork\challenger_adversarial_lifecycle\analysis.md` and deliver `e:\intqam-sultan\.agents\teamwork\challenger_adversarial_lifecycle\handoff.md` with an explicit verdict: `APPROVE` or `REQUEST_CHANGES`.
Send a completion message back when done.
