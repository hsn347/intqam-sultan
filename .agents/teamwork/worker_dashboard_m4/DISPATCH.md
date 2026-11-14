## 2026-11-01T03:52:36Z
You are Worker 4 (Dashboard & State Optimization Worker) in the Teamwork swarm.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_dashboard_m4\
Your mission is to implement Milestone 4: Dashboard State, Instant Stop & Cache Optimization (R4).

Strict Write Ownership: You have exclusive write access to:
- e:\intqam-sultan\api_server.py
- e:\intqam-sultan\dashboard\src\components\accounts\CastleCard.tsx
- e:\intqam-sultan\dashboard\src\hooks\useCastles.ts
- e:\intqam-sultan\dashboard\src\pages\Accounts.tsx
- e:\intqam-sultan\dashboard\src\components\accounts\TaskTabContent.tsx
DO NOT touch any other files unless strictly necessary for UI localization.

Inputs to read first:
- e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
- e:\intqam-sultan\.agents\teamwork\PROJECT.md
- e:\intqam-sultan\GEMINI.md
- e:\intqam-sultan\AGENTS_CONSTITUTION.md
- e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\report.md
- e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\handoff.md

Requirements:
1. Fix Stop Button Double-Click Bug in CastleCard.tsx:
   - Add isJustStoppedRef grace period guard (2.5s) in useEffect([realStatus, isStopping, isStarting]) so stale WebSocket ticks during the stop transition do NOT overwrite the optimistic 'idle' state.
   - When handleConfirmStop runs, immediately set liveState and connState to 'idle' and set the grace guard.
2. Fix Ghost "Running" Status in api_server.py & useCastles.ts:
   - In api_server.py: in list_castles and get_castle_detail, when bot_manager.get_bot(em) is None, explicitly set c["state"] = "idle" and c["conn_state"] = "idle".
   - In api_server.py: add startup SQLite reconciliation to reset any orphaned "running" states in the castles database table to "idle".
   - In CastleCard.tsx: fix isActuallyRunning / isBotActive logic so it respects live WebSocket and API state without sticking to stale local cache.
   - In useCastles.ts: in useBotControl, remove the artificial 1500ms delay on stop, immediately invalidate and refetch queries.
3. Optimize Re-renders & Resource Usage:
   - In TaskTabContent.tsx: wrap the component export in React.memo to prevent expensive re-renders when parent card state changes.
   - In Accounts.tsx: wrap callback props passed to CastleCard (onToggleExpand, onDelete, etc.) with useCallback.
4. Verify your implementation by running typescript / build verification (e.g. npm run build in dashboard/) and python syntax checks on api_server.py.
