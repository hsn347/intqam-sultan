## 2026-11-01T09:13:23Z
Your identity: Backend Implementation Agent (teamwork_worker).
Your assigned working directory: e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_backend\
Mandatory: Read the full authoritative user request at:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

Also read the survey synthesis and architecture blueprint at:
- e:\intqam-sultan\.agents\teamwork\orchestrator_3\SURVEY_SYNTHESIS.md
- e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_mem_2\analysis.md

Files you own exclusively:
- tasks/command_hall.py
- tasks/__init__.py
- bot_manager.py
- api_server.py
- tools/migrate_command_hall_config.py
- database/castles.db (via migration script)

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Your Tasks:
1. Implement `tasks/command_hall.py`:
   - Inherit from `BaseTask` (`tasks/base_task.py`).
   - `self.name = "command_hall"`.
   - `is_active` reads `self.config.get("enabled", False)`.
   - 0-Network Pre-flight check:
     If `commandHall` not in `conn.init_data`, query `safe_query("2274", "1", {})` once to initialize memory with human jitter (`random.uniform(0.5, 0.9)`), caching to `conn.init_data["commandHall"]`.
   - Continuous loop of 5 minutes: `start_time = time.time()` while `(time.time() - start_time) < 300:`.
   - Priority 1: Check completed tasks (`statue == 3`). Claim rewards via `safe_query("2274", "8", {"commitType": task["type"], "index": task["index"]})`.
   - Priority 2: Check level progression. If `curExp >= needExp`, send `safe_query("2274", "2", {})`.
   - Priority 3: Zero-gold / zero-speedup filtering: skip any task requiring gold or speedups (`consume > 0` or speedup items).
   - Priority 4: Execute zero-army instant tasks: Types 3 (dialogue), 4 (rescue), 6 (snipe) via `safe_query("2274", "5", {"index": task["index"]})`.
   - Priority 5: March tasks (Types 2, 5): check 0-network available marches from `conn.init_data.get('queueCtrl')` and available troops in `conn.init_data.get('armyCtrl')`.
     If no marches or troops available, finish all remaining zero-army tasks, claim finished rewards, and cleanly exit the loop:
     "تتوقف وتخرج بعد إتمام باقي المهام الفرعية إذا اصطدمت بمتطلب إرسال فيلق على الخريطة ولم تكن هناك فيالق متاحة."
   - Sleep `random.uniform(4.0, 7.0)` seconds between iterations in the 5-minute loop.
   - Clean logging with prefix `[CommandHall]`. Fault isolation with `try...except`.
2. Export `CommandHallTask` in `tasks/__init__.py`.
3. In `bot_manager.py`:
   - Import `CommandHallTask`.
   - Register in `REGISTERED_TASKS` right before `DailyQuestTask`.
   - Add to `DEFAULT_BOT_CONFIG["tasks"]["command_hall"] = {"enabled": False}`.
   - Update `reload_config_from_db` to include `("command_hall", "command_hall")` in the sync tuple.
4. In `api_server.py`:
   - Add `command_hall: Optional[SimpleToggleConfig] = None` to `CastleConfigModel`.
5. Create `tools/migrate_command_hall_config.py` in `tools/`:
   - Update all castles in `database/castles.db` to have `"command_hall": {"enabled": False}` in both `config` and `config["tasks"]`.
   - Execute the script using terminal command.
   - Programmatically assert 100% presence in `database/castles.db` directly from SQLite.
6. HARD CONSTRAINT: DO NOT touch or modify `core/game_client.py`!
7. Verification:
   - Run python compile / import check on `tasks/command_hall.py`, `bot_manager.py`, `api_server.py`.
   - Run the DB migration script and verify that all castles in `database/castles.db` have `command_hall`.


## 2026-11-01T09:15:31Z
**Context**: Implementation of `tasks/command_hall.py`
**Content**: Additional authoritative details from spec_miner_cmd_hall_1:
1. Stamina check: Tasks consume 0 or 5 Lord Stamina. Check stamina in live memory (`lordInfoCtrl.power` or `lordInfoCtrl.stamina`). If stamina < 5, do NOT spend gold to buy stamina; skip stamina-consuming tasks.
2. March packet: For marching to Command Hall NPC (Types 2 and 5), the march uses `CMD 1007 SubCMD 2` with `moveLineType = 15` (`moveLineTypeCommandHallNpc`), `matrixType = 1`, target coordinates `(obj.x, obj.y)`.
3. If no marches available or stamina < 5, execute all remaining 0-stamina / non-march tasks, claim all finished tasks (statue == 3 via CMD 2274 SubCMD 8), and exit cleanly.
**Action**: Incorporate these refined checks into `tasks/command_hall.py`.


## 2026-11-01T09:23:49Z
**Context**: Milestone 2 Backend Implementation Check-in
**Content**: 10-minute check-in. Frontend worker has completed Milestone 3 with 0 errors. How is the implementation of `tasks/command_hall.py`, bot_manager integration, and the DB migration script progressing?
**Action**: Please share your current status update or provide the handoff report if ready.
