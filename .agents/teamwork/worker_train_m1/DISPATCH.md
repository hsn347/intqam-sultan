## 2026-11-01T03:52:13Z
You are Worker 1 (Training Sync Worker) in the Teamwork swarm.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_train_m1\
Your mission is to implement Milestone 1: Training & Daily Train Synchronization (R1).

Strict Write Ownership: You have exclusive write access to:
- e:\intqam-sultan\tasks\train.py
- e:\intqam-sultan\tasks\daily_train.py
DO NOT touch any other source files.

Inputs to read first:
- e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
- e:\intqam-sultan\.agents\teamwork\PROJECT.md
- e:\intqam-sultan\GEMINI.md
- e:\intqam-sultan\AGENTS_CONSTITUTION.md
- e:\intqam-sultan\.agents\teamwork\explorer_training_sync\report.md
- e:\intqam-sultan\.agents\teamwork\explorer_training_sync\handoff.md

Requirements:
1. Everyday Quest Pre-flight: In daily_train.py, check conn.init_data['everydayTaskCtrl']['eventInfo'] (types '12' to '16') and questCtrl['point_finish_list']. If event count >= 5, skip with 0-network calls.
2. Smart Training Delegation: In daily_train.py, check if user enabled main train for that troop type with tier > 0. If so, defer to main train with clean logging (main train will produce >= 250 units and complete the quest).
3. QueueCtrl In-Memory Sync: Upon successful training query (CMD 1005 / SubCMD 2) in either daily_train or train, immediately create/update the queue entry in conn.init_data['queueCtrl'] with proper starttime, totaltime, bid, cnt, armylevel. Also update armyCtrl.trainArmy, and deduct resources in cityCtrl.reslist.
4. Barracks 0-Network Pre-flight: In train.py, check queueCtrl before querying. If the barracks queue is active, skip with 0-network calls. Completely eliminate Error 4002.
5. Connection & Capacity Guard: In train.py and daily_train.py, verify conn.is_connected before any query. If disconnected or capacity <= 0, abort immediately without infinite retry loops.
6. In-Memory Harvesting Sync: In _harvest_all_ready_barracks, when CMD 1005 / SubCMD 5 succeeds, immediately delete the completed queue from queueCtrl and clear the building from armyCtrl.trainArmy in memory.
7. Verify your implementation by running python test_task_method.py commands or unit tests.
