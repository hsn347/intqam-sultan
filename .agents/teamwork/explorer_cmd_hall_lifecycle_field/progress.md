# Progress — Command Hall Lifecycle Field & Memory Investigation

Last visited: 2026-11-01T14:40:00Z
Status: Investigation complete, synthesizing findings into analysis.md and handoff.md

## Completed Activities
1. Inspected all test and inspection scripts in `tools/` (`test_command_hall_live.py`, `field_test_command_hall.py`, `test_task_method.py`, `test_live_field_command_hall_verification.py`, `inspect_cmd2274_res.py`, etc.).
2. Pinpointed exact root cause of the 300-second freeze and 0 rewards exit:
   - `tasks/command_hall.py:66` `LOOP_MAX_DURATION_SECONDS = 300`.
   - `_handle_march_tasks()` sets `task["statue"] = TASK_STATUE_PREPARE` and increments `total_marches`.
   - `has_active_marches = (total_marches > 0)` and `has_preparing_tasks = any(...)` remain persistently True.
   - `_ensure_synced_data()` caches in-memory `hall_data` and never queries CMD 2274 SubCMD 1 again.
   - March completion is never tracked; loop sleeps 4-7s repeatedly until 300s timeout expires; terminates with 0 rewards.
3. Connected directly to live game servers for accounts in `database/castles.db` (`beetoo1@hotmail.com` and `beetoo3@hotmail.com`):
   - Extracted exact live schema of `conn.init_data` and CMD 2274 SubCMD 1 response.
   - Confirmed `commandHall` is NOT in `conn.init_data` upon gate handshake (only 277 standard controllers loaded).
   - Documented exact structures of `armyGroupTaskData` (type 1), `armyPioneerTaskData` (type 2), `commonTaskData` (list of type 5 tasks), `finishTaskData` dictionary.
   - Verified that `beetoo1` has 0 troops (tests zero-army safe exit), while `beetoo3` has 14,380 combat troops, qualified heroes, and 3 active battle tasks in wave 12 (perfect for live march tracking).
4. Explored decompiled game client source code (`commandHallCtrl.lua`, `commandHallUtil.lua`, `kingdomMapCtrl.lua`, `kingdomQueueObjCell.lua`, `queueTimeUtil.lua`, `mapDef.lua`, `cmdDef.lua`):
   - Confirmed `COMMANDHALL_REBEL_ARMY_MARCH_TIME` defaults to 5s, `COMMANDHALL_COMMON_TASK_MARCH_TIME` defaults to 2s.
   - March duration is capped at ~5-15s, making 300s sleep absurd.
   - CMD 1007 SubCMD 2 returns `{"err": 0}`, queue updates arrive via `NOTIFY_LOCAL_QUEUE_SYNC` (202), and CMD 1007 SubCMD 1000 can request queue sync.
   - Command Hall state must be synced via CMD 2274 SubCMD 1 (`REQ_COMMAND_HALL_INIT`).
   - Reward claim is CMD 2274 SubCMD 8 (`REQ_COMMAND_HALL_COMMIT_TASK`) with `commitType` and `index`.
5. Formulated end-to-end field testing strategy for `tools/` with zero gold spent, dynamic polling, and reward verification.
