# BRIEFING — 2026-11-01T03:49:00Z

## Mission
Investigate Building Task Random Delays (R3) and Dashboard UI Cache, Stop Button & State Management Issues (R4).

## 🔒 My Identity
- Archetype: explorer
- Roles: Building & Dashboard Explorer
- Working directory: e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\
- Original parent: 8028e782-6a16-497b-9534-d0b0c040f855
- Milestone: Investigation Phase (R3 & R4)

## 🔒 Key Constraints
- Read-only investigation — do NOT implement / modify source code
- Strictly preserve current visual structure of Dashboard
- Keep findings well-referenced with exact file paths and line numbers
- Follow 5-component handoff report standard

## Current Parent
- Conversation ID: 8028e782-6a16-497b-9534-d0b0c040f855
- Updated: 2026-11-01T03:49:00Z

## Investigation State
- **Explored paths**:
  - `tasks/building.py` (lines 526, 798, 863, 1114, 1146, 1150, 1260, 1325, 1340, 1506-1634)
  - `tasks/base_task.py` (lines 407-435 `safe_query`, lines 501-680 `ensure_resources`)
  - `api_server.py` (lines 511-570 `list_castles`, lines 800-840 `stop_bot_api`, lines 1148-1245 `ws_single_castle_status` / `ws_status`)
  - `core/database.py` (lines 141-200, 340-366 `upsert_castle_conn_state`)
  - `bot_manager.py` (lines 278-293 `_set_state`, 778-824 `stop()`, 885-905 `stop_bot`)
  - `dashboard/src/components/accounts/CastleCard.tsx` (lines 67-159, 181-183, 265-299, 563-600)
  - `dashboard/src/hooks/useCastles.ts` (lines 110-189 `useCastles`, 397-460 `useBotControl`, 235-296 `useRealBotStatus`)
  - `dashboard/src/pages/Accounts.tsx` (lines 605-643 `CastleCard` prop passing)
  - `dashboard/src/components/accounts/TaskTabContent.tsx` (unmemoized 3164-line tree)
- **Key findings**:
  - R3: In `tasks/building.py`, requests use inconsistent delays (0.8-1.5s or 0.3-0.7s or fixed 0.3s). Multiple sequential loops lack human pauses between upgrade and speedup. Adjusting all `safe_query` calls and loop steps to `random.uniform(0.5, 0.9)` solves R3 safely.
  - R4 Stop Button: Race condition where `handleConfirmStop`'s `onSuccess` sets `isStopping=false`, immediately triggering `useEffect([realStatus, isStopping, isStarting])`. Since backend WS polls every 2s, `realStatus` is still `'running'`, which overwrites the optimistic `'idle'` state back to `'running'` in milliseconds.
  - R4 Ghost Running: Backend `api_server.py` does not reset `state`/`conn_state` when `bot_manager.get_bot()` is `None`; no reboot state reconciliation; `localStorage` cache has 60s staleTime; and `CastleCard`'s `isActuallyRunning` has a hard-coded fallback to `castle.bot_status?.state === 'running'` that ignores WS offline/idle.
  - R4 UI Optimization: `CastleCard` props in `Accounts.tsx` are non-memoized inline functions destroying `React.memo`; unmemoized `TaskTabContent` re-renders thousands of lines; 1 WS connection per card strains server SQLite with 2s polling loops.
- **Unexplored areas**: None. All R3 and R4 requirements are thoroughly investigated.

## Key Decisions Made
- All evidence chains documented with exact file paths and line numbers.
- Proposed concrete code snippets (before/after) for implementers to drop in cleanly.

## Artifact Index
- `e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\DISPATCH.md` — incoming dispatch records
- `e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\BRIEFING.md` — working memory and identity
- `e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\progress.md` — liveness heartbeat
- `e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\report.md` — detailed technical report
- `e:\intqam-sultan\.agents\teamwork\explorer_building_dashboard\handoff.md` — 5-component handoff report
