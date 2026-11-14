## 2026-11-01T05:42:06Z
You are a Backend Implementation Worker.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_daily_quest_m1\
Your task assignment is Milestone 1: Daily Activity Quest Chest Collection Task (Requirement R1).

MANDATORY FIRST STEP:
Read the Original Request at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Read the Project Architecture at: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Read the Backend Explorer Handoff at: e:\intqam-sultan\.agents\teamwork\explorer_r2_backend\handoff.md
Read the Full Blueprint at: e:\intqam-sultan\.agents\teamwork\explorer_r2_backend\analysis.md
Read the Workspace Rules at: e:\intqam-sultan\GEMINI.md and e:\intqam-sultan\AGENTS_CONSTITUTION.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Implementation Steps (Strict 6-Stage Pipeline):
1. Stage 1 - Backend Task (`tasks/daily_quest.py` & `tasks/__init__.py`):
   - Implement `DailyQuestTask` inheriting from `BaseTask` in `tasks/daily_quest.py`.
   - Name: `self.name = "daily_quest"`.
   - 0-Network Pre-flight check: Calculate accumulated points from `conn.init_data["everydayTaskCtrl"]["eventInfo"]` using `DAILY_QUEST_POINT_RULES` (matching `calCurPoint()`).
   - Check unclaimed chests against the 8 milestones: 30, 70, 120, 180, 260, 340, 420, 500 points.
   - If no chest is ready or all ready chests are recorded in `everydayTaskCtrl.normalRecord`, exit immediately with ZERO network requests.
   - Safe Fallback Query: If `everydayTaskCtrl` is absent or stale, query CMD "2027", SUBCMD "1" with `{}` and update `conn.init_data["everydayTaskCtrl"]`.
   - Chest Claiming: For each ready unclaimed chest index (1..8), send CMD "2027", SUBCMD "2" with `{"index": index}`.
   - In-memory sync: Upon claiming, immediately update `conn.init_data["everydayTaskCtrl"]["normalRecord"][str(index)] = 1`.
   - Export `DailyQuestTask` in `tasks/__init__.py`.
2. Stage 2 - Bot Manager (`bot_manager.py`):
   - Import `DailyQuestTask` and place it as the ABSOLUTE LAST element in `REGISTERED_TASKS` so it runs after all 18 preceding tasks.
   - Add `"daily_quest": {"enabled": True}` to `DEFAULT_BOT_CONFIG`.
   - Add `"daily_quest"` to `ALWAYS_AUTO_TASKS`.
   - Update `reload_config_from_db()` to support `"daily_quest"`.
3. Stage 3 - API Whitelist (`api_server.py`):
   - Add `"daily_quest"` to `CastleConfigModel` and `clean_config` filter.
4. Stage 4 - Database Migration (`database/castles.db`):
   - Run a direct migration script to update all existing castles in `database/castles.db` to include `"daily_quest": {"enabled": True}` in their `config` JSON column.
   - Perform a direct database read check to verify 100% of castles have the key.
5. Stage 5 - Frontend Defaults (`dashboard/src/types/index.ts` & `dashboard/src/hooks/useCastles.ts`):
   - Update `CastleConfig` type to include `daily_quest?: { enabled: boolean }`.
   - Update default config in `useCastles.ts`.
6. Stage 6 - Frontend UI, Dual-Save & Trilingual Localization:
   - Add a toggle control for the task in `dashboard/src/components/accounts/TaskTabContent.tsx` under daily tasks.
   - Update both `performSave()` (auto-save) and `handleSave()` (manual save).
   - Add translation keys to `dashboard/src/locales/ar.json`, `en.json`, and `tr.json`.

Verification Requirements:
- Run programmatic tests (e.g. using `python -c ...` or a test script in `tools/`) verifying:
  1. `DailyQuestTask` calculates points accurately.
  2. 0-network pre-flight returns early when no chests are claimable.
  3. `REGISTERED_TASKS[-1] == DailyQuestTask`.
  4. Direct DB check confirms all castles in `database/castles.db` have `daily_quest` enabled.
  5. Frontend builds cleanly (`npm run build` in `dashboard/` or equivalent check).
- Document all verification results, commands, and file diffs in:
  `e:\intqam-sultan\.agents\teamwork\worker_daily_quest_m1\handoff.md`.
- Send a completion message via send_message when done.
