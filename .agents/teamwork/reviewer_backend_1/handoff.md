# Handoff Report: Backend Review and Adversarial Audit for Command Hall Task

**Agent**: Backend Reviewer & Adversarial Critic (`reviewer_backend_1`)
**Timestamp**: 2026-11-01T09:33:00Z
**Review Verdict**: **APPROVE**
**Integrity Status**: **CLEAN (Zero Integrity Violations)**

---

## 1. Observation

### A. Codebase Inspection & Line-by-Line Evidence
1. **Task Class Structure (`tasks/command_hall.py`)**:
   - `tasks/command_hall.py:77-103`: `CommandHallTask` inherits from `BaseTask` (`tasks.base_task.BaseTask`).
   - `tasks/command_hall.py:83-84, 97`: Class attributes `name = "command_hall"`, `alias = "command_hall"`, and `self.name = "command_hall"`.
   - `tasks/command_hall.py:100-103`: `@property def is_active(self) -> bool: return bool(self.config.get("enabled", False))`.
   - `tasks/command_hall.py:104-116`: `can_run()` verifies `self.is_active`, gateway connection (`self.conn.is_connected`), and live memory presence (`self.init_data`).

2. **0-Network Pre-Flight & Human Jitter Fallback (`tasks/command_hall.py`)**:
   - `tasks/command_hall.py:175-201`: `_ensure_synced_data()` first calls `self.get_ctrl("commandHall")`. If `taskList` or `commandLv` is present in memory, it returns immediately without network interaction (0-Network).
   - If missing, it executes `safe_query(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_INIT, {}, min_delay=0.5, max_delay=0.9)` and caches to `self.conn.init_data["commandHall"]`.
   - Subsequent calls read directly from `self.conn.init_data["commandHall"]` without contacting the server.
   - `tasks/command_hall.py:118-143`: In-memory getters `current_stamina` (reads `lordInfoCtrl.base.health`) and `available_troops_count` (reads `armyCtrl.totalArmy`).

3. **5-Minute Continuous Loop & Priorities (`tasks/command_hall.py`)**:
   - `tasks/command_hall.py:65`: `LOOP_MAX_DURATION_SECONDS = 300` (5 minutes).
   - `tasks/command_hall.py:409`: `while (time.time() - start_time) < LOOP_MAX_DURATION_SECONDS:`.
   - Priority 1 (`lines 202-230, 422, 435`): `_claim_finished_tasks()` claims completed tasks (`statue == 3`) using `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`), with human jitter `(0.5, 0.9)`.
   - Priority 2 (`lines 232-261, 426`): `_check_and_upgrade_level()` upgrades command hall level when `cur_exp >= need_exp` up to Lv.21 using `CMD 2274 / SUBCMD 2` (`REQ_COMMAND_HALL_UPGRADE_COMMAND_LV`).
   - Priority 3 (`lines 285-288, 339-342`): Zero-gold & zero-speedup checks filter out tasks where `consumeGold > 0` or `gold > 0` or speedup items are specified.
   - Priority 4 (`lines 262-315, 430`): `_execute_instant_tasks()` executes non-army subtasks (Type 3 Dialogue, Type 4 Rescue, Type 6 Snipe) via `CMD 2274 / SUBCMD 5` (`REQ_COMMAND_HALL_FINISH_TASK`), checks stamina >= 5 without spending gold, and immediately triggers reward claiming upon completion.
   - Priority 5 (`lines 317-388, 439`): `_handle_march_tasks()` checks `available_marches` (from `queueCtrl`), `available_troops_count` (from `armyCtrl`), and stamina. If troops == 0 or marches == 0 or stamina < 5: sets `blocked_on_march = True`.
   - Safe Exit (`lines 444-450`): Because all instant tasks were executed and claimed prior to line 439, hitting the march block immediately logs clean exit message and breaks the loop without throwing errors. If march available, dispatches troop to `(target_x, target_y)` with `moveLineType = 15` (`MOVE_LINE_TYPE_COMMAND_HALL_NPC`) and `matrixType = 1` via `CMD 1007 / SUBCMD 2`.

4. **Fault Isolation & Clean Logging**:
   - All queries are wrapped in `safe_query` catching non-fatal exceptions.
   - `run()` catches `asyncio.CancelledError` and re-raises for clean shutdown.
   - All other unexpected exceptions are isolated and returned as `TaskResult.fail(...)`.
   - Every log message starts with `[CommandHall]` (e.g. `[CommandHall] 📡 ...`, `[CommandHall] 🎁 ...`, `[CommandHall] ⚡ ...`, `[CommandHall] ⚔️ ...`, `[CommandHall] 🏁 ...`).

5. **Pipeline Integration**:
   - `tasks/__init__.py:25, 49`: `CommandHallTask` imported and exported in `__all__`.
   - `bot_manager.py:64, 88`: `CommandHallTask` imported and placed in `REGISTERED_TASKS` at index 18 directly before `DailyQuestTask` (index 19).
   - `bot_manager.py:187-189`: `"command_hall": {"enabled": False}` registered in `DEFAULT_BOT_CONFIG["tasks"]`.
   - `bot_manager.py:275, 283`: `"command_hall"` included in `reload_config_from_db()` field sync tuples.
   - `api_server.py:384`: Whitelisted in `CastleConfigModel` as `command_hall: Optional[SimpleToggleConfig] = None`.
   - `database/castles.db`: Direct SQLite query verified 4/4 castles have `{"enabled": False}` in both `root.command_hall` and `tasks.command_hall`.
   - `core/game_client.py`: Verified file mtime is `2026-11-01 08:55:49.165505`, unchanged.

6. **Test Suite Execution**:
   - Executed `python tools/test_command_hall_task.py`:
     ```
     Ran 6 tests in 5.837s
     OK
     ```
   - Executed AST syntax parser on all 6 modified files: all passed.

---

## 2. Logic Chain

1. **Inheritance and Architecture Compliance**:
   Observation 1 confirms that `CommandHallTask` adheres strictly to `BaseTask` conventions. By subclassing `BaseTask` and defining `name = "command_hall"`, `alias = "command_hall"`, and an explicit `is_active` property defaulting to `False`, the task follows the unified task architectural standard (GEMINI.md Rule 6).

2. **Ban Prevention & 0-Network Safety**:
   Observation 2 demonstrates that live memory is queried first via `self.get_ctrl("commandHall")`. When live memory already contains `taskList` or `commandLv`, zero network requests are made. When unsynchronized, exactly one initialization query (CMD 2274 SubCMD 1) is dispatched with human delay jitter `(0.5, 0.9)`, and the resulting payload is immediately cached in `conn.init_data["commandHall"]`. In-memory state sync occurs locally after every task execution and reward claim, eliminating redundant polling and preventing server anti-cheat detection (GEMINI.md Rule 2).

3. **Subtask Ordering & March Inability Safe Exit**:
   Observation 3 proves that task execution follows the required order: claim existing rewards -> level progression check -> zero-army instant tasks -> claim newly completed rewards -> march tasks. When marches or troops are unavailable, `_handle_march_tasks` sets `blocked_on_march = True` after the instant tasks are already completed and claimed. The task then logs a clean diagnostic message and exits gracefully, preventing bot stall or infinite loops.

4. **Zero-Gold & Zero-Speedup Enforcement**:
   Observation 3 verifies that `consumeGold`, `gold`, `consumeSpeedup`, and `speedup` attributes are explicitly checked in both instant tasks and march tasks. Low stamina (< 5) causes the task to skip or exit rather than spending gold, fully complying with user safety constraints.

5. **Registration & Daily Quest Synergy**:
   Observation 5 confirms that `CommandHallTask` is placed immediately before `DailyQuestTask` in `bot_manager.REGISTERED_TASKS`. Because Command Hall subtasks grant daily activity points (Quest ID `4100033`), running Command Hall immediately before `DailyQuestTask` ensures that daily quest chests unlocked by command hall actions are collected within the exact same cycle.

6. **Database Integrity & Zero-Loss Protocol**:
   Observation 5 verifies direct SQLite queries across `database/castles.db`. All 4 castles contain the `command_hall` configuration with `{"enabled": False}` in both `root` and `tasks` dictionaries, fulfilling GEMINI.md Rule 5.

7. **Constraint Verification**:
   Observation 5 confirms that `core/game_client.py` has not been altered, respecting the strict user constraint.

---

## 3. Adversarial Challenges & Stress-Test Results

| Challenge | Attack Scenario | Blast Radius | Actual Behavior / Defense | Status |
|---|---|---|---|---|
| **C1: Corrupt taskList structure** | `taskList` in live memory is a string or non-iterable object | Potential exception in iteration | `_extract_task_list` validates types (`isinstance(raw_list, (list, dict))`), returns `[]` safely | **PASS** |
| **C2: String-encoded numbers in packet fields** | Server returns `{"index": "1", "type": "3", "statue": "2"}` | Type error in comparisons | Handled via `int(...)` conversions throughout; tested and verified | **PASS** |
| **C3: Missing / non-digit soldier entries in armyCtrl** | `totalArmy` contains non-digit keys or corrupt strings | `ValueError` during sum | `available_troops_count` filters with `str(v).isdigit()` before `int(v)`; verified | **PASS** |
| **C4: Null / missing lordInfoCtrl** | `lordInfoCtrl` is None in memory | `AttributeError` on `.get()` | Safe `.get_ctrl()` fallback chain and `self.stamina` fallback returns 0; verified | **PASS** |
| **C5: Sudden bot cancellation signal** | `asyncio.CancelledError` raised during 5-minute sleep | Bot hangs or swallows cancellation | `run()` catches `asyncio.CancelledError` and explicitly re-raises it; verified | **PASS** |
| **C6: March exhaustion blocking** | All march queues busy or 0 troops in castle | Bot loops fruitlessly for 5 minutes | Instantly finishes zero-army tasks, claims rewards, and exits cleanly via `break`; verified | **PASS** |

---

## 4. Integrity Violation Audit

- **Hardcoded test outputs in source code**: None detected. All operations dynamically inspect connection payloads and live memory.
- **Dummy or facade implementations**: None detected. Full packet protocol implemented (`CMD 2274` SubCMDs `1, 2, 5, 8` and `CMD 1007` SubCMD `2`).
- **Shortcuts bypassing the task**: None detected.
- **Fabricated verification outputs**: None detected. Programmatic tests independently executed and verified.
- **Self-certifying work without independent verification**: Independent SQLite inspection and test suites executed.

---

## 5. Conclusion

The Backend implementation for the Command Hall task (`tasks/command_hall.py`, `tasks/__init__.py`, `bot_manager.py`, `api_server.py`, `tools/migrate_command_hall_config.py`, and `tools/test_command_hall_task.py`) is complete, robust, secure against game bans, and adheres strictly to all workspace rules and requirements.

**Review Verdict**: **APPROVE**

---

## 6. Verification Method

To independently verify this verdict:

1. **Run the Command Hall unit and integration test suite**:
   ```bash
   python tools/test_command_hall_task.py
   ```
   *Expected*: `Ran 6 tests in ~5.8s ... OK`

2. **Verify 100% database migration in SQLite**:
   ```bash
   python -c "import sqlite3, json; conn = sqlite3.connect('database/castles.db'); rows = conn.execute('SELECT email, config FROM castle_states').fetchall(); print(all('command_hall' in json.loads(r[1]) and 'command_hall' in json.loads(r[1]).get('tasks', {}) for r in rows))"
   ```
   *Expected*: `True`

3. **Verify core/game_client.py was untouched**:
   ```bash
   python -c "import os, datetime; print(datetime.datetime.fromtimestamp(os.path.getmtime('core/game_client.py')))"
   ```
   *Expected*: `2026-11-01 08:55:49.165505`

4. **Verify AST syntax validity across touched files**:
   ```bash
   python -c "import ast; [ast.parse(open(f, encoding='utf-8').read()) for f in ['tasks/command_hall.py', 'tasks/__init__.py', 'bot_manager.py', 'api_server.py']]; print('AST OK')"
   ```
   *Expected*: `AST OK`
