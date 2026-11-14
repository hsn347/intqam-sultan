## 2026-11-01T05:59:53Z
You are a Dashboard Optimization, State Caching, and High-Concurrency Backend Implementation Worker.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_dashboard_m3\
Your task assignment is Milestone 3: Dashboard State Caching, Responsive UI & High-Concurrency Scaling (Requirement R3).

MANDATORY FIRST STEP:
Read the Original Request at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Read the Project Architecture at: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Read the Dashboard Explorer Handoff at: e:\intqam-sultan\.agents\teamwork\explorer_r2_dashboard\handoff.md
Read the Full Blueprint at: e:\intqam-sultan\.agents\teamwork\explorer_r2_dashboard\analysis.md
Read the Workspace Rules at: e:\intqam-sultan\GEMINI.md and e:\intqam-sultan\AGENTS_CONSTITUTION.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Implementation Steps:

1. Backend Database & API Concurrency Scaling (1000 Castles, 150 Users):
   - `core/database.py`:
     * Move `PRAGMA journal_mode = WAL;` to execute once at database schema initialization (`init_db()`), NOT inside `get_connection()` on every query (which caused exclusive write lock contention on the database header).
     * Set `PRAGMA busy_timeout = 30000;` (30 seconds) in `get_connection()` to prevent lock timeouts under high concurrency.
     * Optimize `get_all_users_with_castles()`: Replace the N+1 connection/query loop (which ran 151 separate connections/queries) with a 2-query batch fetch that queries all users and all user castles, mapping them in memory.
   - `api_server.py`:
     * Add FastAPI `lifespan` handler to gracefully execute `await bot_manager.stop_all()` when the server shuts down or reloads.
     * Add `summary: bool = False` query parameter to `list_castles` (`/api/castles`) so that list views can request lightweight projections without fetching the multi-kilobyte `config` column for 1,000 castles unless needed.
     * In `ws_single_castle_status` (lines 1210-1230), avoid querying SQLite on every 2-second tick for idle castles; read from in-memory cache or `bot_manager.get_bot(email)`.

2. Frontend State Caching & Redundant Fetch Elimination:
   - `dashboard/src/hooks/useCastles.ts`:
     * Eliminate Cache Invalidation Storm: In `useUpdateCastleConfig`, replace `qc.invalidateQueries({ queryKey: ['castles', userId] })` on auto-save with direct in-memory cache update (`qc.setQueryData`), eliminating heavy refetches of all castles on every toggle.
     * Align `useCastle(userId, castleId)` query key with `useUpdateCastleConfig` cache invalidator so single-castle detail views stay synchronized.
   - `dashboard/src/pages/AdminLiveProcesses.tsx`:
     * Migrate to TanStack Query (`useQuery`) with `staleTime: 5000` (or 8000ms), eliminating raw fetch, unmount data loss, and UI flashing.
   - `dashboard/src/pages/AdminProxies.tsx`:
     * Migrate to TanStack Query (`useQuery`) with `staleTime: 60000`, preserving proxy test results and expanded card states across page navigation.

3. UI Responsiveness & Button Lag Elimination:
   - `dashboard/src/pages/Accounts.tsx`:
     * Implement `useDeferredValue` for castle search input to eliminate typing lag and prevent 50+ card re-render freezes on every keystroke.
   - `dashboard/src/components/accounts/TaskTabContent.tsx`:
     * Eliminate recursive `JSON.stringify` comparisons in `countConfigChanges` to restore <16ms button reaction times.

4. Automated Verification Script (`tools/benchmark_concurrency_caching.py`):
   - Implement the automated benchmark script designed in `explorer_r2_dashboard/analysis.md` (zero pip dependencies).
   - Test:
     a) SQLite concurrency under simulated 150 concurrent workers reading/writing: 0 database locks.
     b) Batch `get_all_users_with_castles()` performance: executes in <50ms.
     c) API caching / lightweight projection verification.
     d) Frontend build (`npm run build` in `dashboard/`) succeeds cleanly without errors.
   - Run the script and document the output.

Output Requirements:
- Write full details, benchmarks, and file diffs to: `e:\intqam-sultan\.agents\teamwork\worker_dashboard_m3\handoff.md`.
- Send a completion message via send_message when done.
