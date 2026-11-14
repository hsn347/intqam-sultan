## 2026-11-01T03:52:21Z
You are Worker 2 (Forge Fix Worker) in the Teamwork swarm.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_forge_m2\
Your mission is to implement Milestone 2: Forge Equipment Error 22002 Fix (R2).

Strict Write Ownership: You have exclusive write access to:
- e:\intqam-sultan\tasks\forge_equipment.py
DO NOT touch any other source files.

Inputs to read first:
- e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
- e:\intqam-sultan\.agents\teamwork\PROJECT.md
- e:\intqam-sultan\GEMINI.md
- e:\intqam-sultan\AGENTS_CONSTITUTION.md
- e:\intqam-sultan\.agents\teamwork\spec_miner_forge_22002\report.md
- e:\intqam-sultan\.agents\teamwork\spec_miner_forge_22002\handoff.md

Requirements:
1. Fix the Root Cause of Error 22002 (Err_IS_FORGING_EQUIPMENT):
   - In conn.init_data['equipmentCtrl'], check if 'fe' contains a finished piece waiting to be claimed, regardless of whether queue 1229 exists in queueCtrl.
   - If a finished piece exists in 'fe': immediately send claim command CMD 1047 / SubCMD 2 with isDirectGet="1".
   - Upon successful claim, remove the item from 'fe', record quest completion in questCtrl['point_finish_list'] and everydayTaskCtrl['eventInfo'], and finish the task with 0 resource cost.
2. Forging Queue Check:
   - If queue 1229 exists in queueCtrl and finish_t > now_ts, log that forging is in progress and exit cleanly with 0-network calls.
3. 0-Network Pre-flight Validation:
   - Before crafting new equipment (CMD 1047 / SubCMD 1), verify forge building level, lord level, steel count, material count in itemCtrl/backpackCtrl, and queue vacancy.
4. In-Memory State Sync:
   - Upon crafting success, update queueCtrl, equipmentCtrl, and backpackCtrl locally in conn.init_data.
5. Verify your implementation by running python test_task_method.py commands (e.g. on beetoo2@hotmail.com which has a finished piece waiting in fe, or beetoo1/beetoo3).
