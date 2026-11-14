## 2026-11-01T13:02:53Z
You are Reviewer 1: Logic & Correctness Reviewer (teamwork_reviewer).
Your working directory is: e:\intqam-sultan\.agents\teamwork\reviewer_logic_m2\

You MUST read the authoritative request first:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Also read the project architecture:
e:\intqam-sultan\.agents\teamwork\PROJECT.md
And worker handoff:
e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_m1\handoff.md

Your mission:
1. Review `tasks/command_hall.py` for algorithmic correctness, completeness, and interface conformance:
   - Are all 6 subtask types handled properly?
   - Type 1: Rebel Army Group (`REBEL_ARMY_GROUP_TASK`):
     * Does `_handle_rebel_group_attack()` check `armyGroupTaskData`?
     * Does it attack via `CMD 2274 / SubCMD 7` at 0 stamina when `statue == TASK_STATUE_BEGIN` and `rabelHp > hurtHp`?
     * Does it commit the reward via `CMD 2274 / SubCMD 8` (`commitType: 1`) when defeated (`hurtHp >= rabelHp` or `statue == TASK_STATUE_FINISH`), which refreshes the task list?
   - Types 2 & 5: Pioneer & Battle March Tasks:
     * Does `_handle_march_tasks()` dispatch via `CMD 1007 / SubCMD 2` with `moveLineType = 15`, `matrixType = 1`?
     * Does the payload include genuine troops in `army` and combat heroes in `heroInfo`?
     * Does it claim rewards via SubCMD 8?
   - Types 3, 4, 6: Instant Zero-Army Tasks (Dialogue, Rescue, Silent Sniper):
     * Are they completed via `CMD 2274 / SubCMD 5` and claimed via SubCMD 8?
   - Hero Selection (`_select_combat_heroes`):
     * Are gathering heroes (`heroType == 1`: IDs `1711, 1717, 1724, 1733`) strictly excluded?
     * Are available combat heroes (`state in (1, 5)` not in queue) prioritized by quality/level?
   - Troop Selection & March Capacity:
     * Are wall traps (`801..825`) strictly excluded?
     * Is march capacity computed from Drill Grounds (`bid: 121`) and VIP?
2. Run test suites to verify correctness:
   `python tools/test_command_hall_task.py`
   `python tools/test_challenger_command_hall.py`
3. Document your review in `e:\intqam-sultan\.agents\teamwork\reviewer_logic_m2\handoff.md` with an explicit verdict: APPROVE or REQUEST_CHANGES. Send a message when complete.
