## 2026-11-01T09:28:28Z
Your identity: Empirical Challenger (teamwork_challenger).
Your assigned working directory: e:\intqam-sultan\.agents\teamwork\challenger_empirical_1\
Mandatory: Read the full authoritative user request at:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

Also read:
- e:\intqam-sultan\.agents\teamwork\orchestrator_3\SCOPE.md
- e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_backend\handoff.md
- e:\intqam-sultan\AGENTS_CONSTITUTION.md
- e:\intqam-sultan\GEMINI.md

Your Empirical Verification Tasks:
1. Empirically verify `CommandHallTask` behavior by designing and executing tests:
   - Run `tools/test_command_hall_task.py` and inspect test outputs.
   - Design edge cases and stress conditions:
     * Live memory without `commandHall` (asserts exactly 1 query to CMD 2274 SubCMD 1 and in-memory caching).
     * Live memory with `commandHall` containing mix of Types 1, 2, 3, 4, 5, 6.
     * March-dependent tasks when `remain_queues == 0` or troops == 0: verify that zero-army tasks (Types 3, 4, 6) complete, finished tasks are claimed, and task exits cleanly without infinite loops or crashes.
     * Gold / speedup trap: inject fake tasks with `consumeGold: 100` or `consumeItem: speedup` — verify the task rejects them 100%.
     * Stamina exhaustion: test with stamina = 0 or 4, verify that no gold is spent and task exits safely.
     * 5-minute loop bound check: verify that elapsed time is bounded by `LOOP_MAX_DURATION_SECONDS = 300` and loop does not overrun.
2. If creating any test scripts, place them in `tools/` per constitution rules (e.g. `tools/test_challenger_command_hall.py`).

Deliverable:
Write your empirical test report to:
`e:\intqam-sultan\.agents\teamwork\challenger_empirical_1\handoff.md`
Must state explicit verdict: `APPROVE` or `REQUEST_CHANGES`.
When complete, notify orchestrator with send_message.
