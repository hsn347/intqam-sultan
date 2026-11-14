## 2026-11-01T14:42:38Z
You are teamwork_worker.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\
You MUST read the authoritative request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

You have exclusive write ownership of:
- `tasks/command_hall.py`
- Unit tests in `tools/test_command_hall_task.py` and `tools/test_challenger_command_hall.py` (or new test files in `tools/`)

Read the findings and recommendations of the three explorers:
- `e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_lifecycle\analysis.md`
- `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_lifecycle_backend\analysis.md`
- `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_lifecycle_field\analysis.md`

Your task is to completely overhaul the lifecycle, march tracking, and reward claiming logic in `tasks/command_hall.py`:
1. Eliminate the 300-Second Freeze and Stagnant Loop:
   - Remove `LOOP_MAX_DURATION_SECONDS = 300` and the broken exit check `has_active_marches = (total_marches > 0)`.
   - Set a realistic safety timeout (e.g. 60 seconds maximum), and ensure the loop exits immediately once all subtasks are finished, claimed, or blocked.

2. Dynamic March Tracking:
   - Official Lua source (`queueTimeUtil.lua:327-333` and `commandHallUtil.lua:310-318`) proves that march travel time for Command Hall NPCs is hard-capped to `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` seconds (and common tasks to 2 seconds).
   - After dispatching a march (`CMD 1007 SubCMD 2`), wait a dynamic 6 to 10 seconds for the march to arrive and battle to resolve on the server.
   - Do NOT sleep 300 seconds!

3. Force Network Sync After March:
   - In `_ensure_synced_data()`, support `force_network=True` so that after a march is sent and the 5-8 second travel window expires, the bot immediately queries `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`).
   - Update `conn.init_data["commandHall"]` with the fresh `rspdata.initData`, reflecting `statue == 3` (`FINISH`).

4. Immediate Reward Claiming:
   - Claim all tasks with `statue == 3` via `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) with `{"commitType": task.type, "index": task.index}`.
   - Collect and record `claimed_rewards` (> 0).

5. Rebel Army Group (Type 1) Defeat & Wave Progression:
   - When Type 1 has `hurtHp >= rabelHp` or `statue == 3`, claim it via `CMD 2274 / SUBCMD 8` (`commitType = 1`).
   - The server response returns `rspdata.initData` with the next wave's tasks (`armyGroupID + 1`). Update memory and seamlessly continue executing the next wave if stamina/troops allow.

6. Testing & Verification:
   - Run existing unit tests (`tools/test_command_hall_task.py`, `tools/test_challenger_command_hall.py`) and verify that all tests pass without errors.
   - Add/update tests covering the new dynamic march tracking, force sync, and reward claim logic.
   - Document all test commands and results in your handoff.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Write your changes report to `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\changes.md` and deliver `e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_lifecycle\handoff.md`.
Send a message back when completed.
