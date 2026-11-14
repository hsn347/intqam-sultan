## 2026-11-01T09:28:09Z
Your identity: Backend Reviewer (teamwork_reviewer).
Your assigned working directory: e:\intqam-sultan\.agents\teamwork\reviewer_backend_1\
Mandatory: Read the full authoritative user request at:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

Also read:
- e:\intqam-sultan\.agents\teamwork\orchestrator_3\SCOPE.md
- e:\intqam-sultan\.agents\teamwork\orchestrator_3\SURVEY_SYNTHESIS.md
- e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_backend\handoff.md
- e:\intqam-sultan\AGENTS_CONSTITUTION.md
- e:\intqam-sultan\GEMINI.md

Your Review Tasks:
1. Objectively and adversarially review `tasks/command_hall.py`:
   - Verify inheritance from `BaseTask`, naming (`name = "command_hall"`), and `is_active`.
   - Verify 0-Network Pre-flight check: checks `conn.init_data.get("commandHall")`, fallback `safe_query("2274", "1", {})` once with human jitter `(0.5, 0.9)`.
   - Verify 5-minute continuous loop (`start_time`, `while (time.time() - start_time) < 300:`).
   - Verify subtask handling order: finished rewards claimed (`statue == 3` via SubCMD 8), level progression checked via SubCMD 2, zero-army instant tasks (Types 3, 4, 6) executed via SubCMD 5.
   - Verify zero-gold / zero-speedup policy: skips any task requiring gold or speedups.
   - Verify stamina check: skips stamina-consuming tasks if stamina < 5 without spending gold.
   - Verify safe march handling: checks `queueCtrl` and `armyCtrl`. If marches == 0 or troops == 0, completes remaining zero-army tasks, claims finished rewards, logs message, and cleanly exits loop. If available, dispatches march via `CMD 1007 SubCMD 2` with `moveLineType = 15`.
   - Verify fault isolation and clean logging `[CommandHall]`.
2. Verify pipeline integration:
   - `tasks/__init__.py`: exports `CommandHallTask`.
   - `bot_manager.py`: registered in `REGISTERED_TASKS` before `DailyQuestTask`, added to `DEFAULT_BOT_CONFIG["tasks"]`, included in `reload_config_from_db()`.
   - `api_server.py`: whitelisted in `CastleConfigModel`.
   - `tools/migrate_command_hall_config.py`: updates all castles with 100% presence in `database/castles.db`.
3. Verify that `core/game_client.py` has NOT been modified!
4. Run tests: execute `python tools/test_command_hall_task.py`.

Deliverable:
Write your review report to:
`e:\intqam-sultan\.agents\teamwork\reviewer_backend_1\handoff.md`
Must state explicit verdict: `APPROVE` or `REQUEST_CHANGES`.
When complete, notify orchestrator with send_message.
