## 2026-11-01T12:47:06Z
You are the Backend Implementation Worker (teamwork_worker).
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_m1\
Your exclusive write ownership is: e:\intqam-sultan\tasks\command_hall.py (and test scripts in tools/ if needed). Do NOT modify core/game_client.py or unrelated files!

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

You MUST read the authoritative request first:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Also read the project architecture:
e:\intqam-sultan\.agents\teamwork\PROJECT.md
And the survey reports:
- e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_survey_1\analysis.md
- e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_backend_2\analysis.md
- e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_field_3\analysis.md

## Scope & Implementation Requirements for Milestone 1:
Refactor and enhance `tasks/command_hall.py` to comprehensively support all 6 subtask types:
1. Type 1: Rebel Army Group (`REBEL_ARMY_GROUP_TASK`)
2. Type 2 & Type 5: Pioneer & Battle March Tasks (`REBEL_ARMY_PIONEER_TASK`, `BATTLE_TASK`)
3. Type 3, Type 4, Type 6: Instant Zero-Army Tasks (`DIALOGUE_TASK`, `RESCUE_TASK`, `SNIPE_HUNTER_TASK`)
4. Hero Selection (`_select_combat_heroes`)
5. Troop Selection & March Capacity
6. Safety, Zero-Gold, 0-Network Pre-flight & Fault Isolation
7. Verification
