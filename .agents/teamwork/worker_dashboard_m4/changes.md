# Changes Log — Milestone 4 (R4): Dashboard State, Instant Stop & Cache Optimization

**Worker**: Worker 4 (worker_dashboard_m4)  
**Date**: 2026-11-01  
**Scope**: `api_server.py`, `CastleCard.tsx`, `useCastles.ts`, `Accounts.tsx`, `TaskTabContent.tsx`

---

## 1. `api_server.py`

### 1.1. Startup SQLite Reconciliation (Orphaned State Scrubbing)
- **Location**: Right after `db.init_db()` (lines 87-98).
- **Changes**: Added an automatic startup reconciliation block that resets any stale records in `castle_states` where `state = 'running'` or `conn_state` is in `('connected', 'starting', 'waiting', 'deploying', 'reconnecting')` to `'idle'` and status message to `'جاهز للتشغيل'`.
- **Rationale**: If the server reboots or crashes ungracefully, previously running bots no longer exist in memory (`bot_manager.bots` is empty). This query cleans orphaned running entries in the SQLite database so cards never show up as ghost running bots on server start.

### 1.2. In-Memory Inactivity Handling in `list_castles` & `get_castle_detail`
- **Location**: In `list_castles` (around line 548) and `get_castle_detail` (around line 583).
- **Changes**: In the `else:` branch when `bot_manager.get_bot(email)` is `None`, added explicit fallback assignments:
  ```python
  c["state"] = "idle"
  c["conn_state"] = "idle"
  if c.get("status_message") in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة..."):
      c["status_message"] = "متوقف"
  ```
- **Rationale**: Prevents API endpoints from serving stale `"running"` or `"connected"` strings when no bot process exists in memory.

### 1.3. Single Castle WebSocket Status Fallback
- **Location**: In `ws_single_castle_status` (around line 1217).
- **Changes**: Explicitly set `"conn_state": c_st if c_st in ("error", "sealed") else "idle"` and cleaned up `"status_message"`.
- **Rationale**: Prevents per-castle WebSocket polling loop from broadcasting stale connection state when bot is inactive.

---

## 2. `dashboard/src/components/accounts/CastleCard.tsx`

### 2.1. Stop Button Instant Update & 2.5s Grace Guard (`isJustStoppedRef`)
- **Location**: Lines 1, 71-79, 153-170, 294-315.
- **Changes**:
  - Imported `useRef` from React.
  - Added `isJustStoppedRef = useRef(false)` and `stopGraceTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)`.
  - Added unmount timer cleanup effect.
  - In `handleConfirmStop`: immediately set `liveState = 'idle'`, `connState = 'idle'`, `isJustStoppedRef.current = true`, and initiated a 2.5s guard window.
  - In `onSuccess`: reinforced `liveState = 'idle'`, `connState = 'idle'`, `setIsStopping(false)`, and renewed the 2.5s grace window.
  - In `useEffect([realStatus, isStopping, isStarting])`: added `if (isStopping || isStarting || isJustStoppedRef.current) return;`.
  - In `useEffect([castle, isStopping, isStarting])`: guarded prop synchronization with `!isJustStoppedRef.current`.
- **Rationale**: Eliminates the double-click race condition where the 2-second polling WebSocket tick broadcasts stale `'running'` state right as `isStopping` transitions back to `false`, overwriting the optimistic `'idle'` state.

### 2.2. State Machine Decoupling (`isActuallyRunning`, `isBotActive`, `isRunningNow`)
- **Location**: Lines 111-131, 184-194.
- **Changes**:
  - Declared `isStoppingActive` prior to `isActuallyRunning`.
  - Enforced `!isStoppingActive && !isJustStoppedRef.current` inside `isActuallyRunning`, `isWaitingCycle`, `isRunningNow`, and `isBotActive`.
  - Removed unconditional fallback `Boolean(castle.bot_status?.state === 'running')` that locked cards into running mode even when offline or stopped.
  - Added `connState !== 'idle'` guard in `isRunningNow` and `isBotActive`.
- **Rationale**: Eliminates ghost "running" state in frontend cards caused by stale cache in React Query / `localStorage`.

### 2.3. Stable Expansion Callback Support
- **Location**: Line 28, 55-66.
- **Changes**: Updated `CastleCardProps.onToggleExpand` signature to `(id?: string) => void`, and inside `handleToggleExpand`, called `onToggleExpand?.(castle.id)`.
- **Rationale**: Allows parent component (`AccountsPage`) to pass a single memoized callback without inline closures.

---

## 3. `dashboard/src/hooks/useCastles.ts`

### 3.1. Instant Cache Invalidation on Stop
- **Location**: In `useBotControl` (`onSettled`, lines 448-454).
- **Changes**: Removed the artificial `setTimeout(..., 1500)`. Query keys `['castles', userId]` and `['castle', userId, vars.castle.id]` are invalidated and refetched immediately.
- **Rationale**: Eliminates unnecessary 1.5-second UI delay when stopping a bot.

### 3.2. Optimistic `localStorage` Cache Sync in `onMutate`
- **Location**: In `useBotControl` (`onMutate`, lines 422-444).
- **Changes**: Added `saveCachedCastles(userId, nextData.pages[0].items)` alongside `qc.setQueryData`.
- **Rationale**: Prevents stale `localStorage` cache from restoring ghost "running" cards upon page reload.

---

## 4. `dashboard/src/components/accounts/TaskTabContent.tsx`

### 4.1. React.memo Optimization
- **Location**: Lines 618 and 3165.
- **Changes**: Renamed component implementation to `TaskTabContentInner` and exported `export const TaskTabContent = React.memo(TaskTabContentInner)`.
- **Rationale**: Prevents the 3,164-line complex accordion form from re-rendering every time the parent `CastleCard` updates its tick or timer.

---

## 5. `dashboard/src/pages/Accounts.tsx`

### 5.1. Memoized Callbacks via `useCallback`
- **Location**: Lines 1, 117-184, 610-650.
- **Changes**:
  - Imported `useCallback` from React.
  - Wrapped `handleToggleExpand`, `handleDelete`, and `handleSetAsBatchTemplate` in `useCallback`.
  - Replaced inline closures (`onToggleExpand={() => ...}`, `onDelete={() => ...}`, `onEdit={() => ...}`) in both `pendingCastles` and `activeCastles` mappings with stable references:
    - `onToggleExpand={handleToggleExpand}`
    - `onDelete={handleDelete}`
    - `onEdit={setEditingCastle}`
    - `onSetBatchTemplate={handleSetAsBatchTemplate}`
- **Rationale**: Restores effectiveness of `React.memo(CastleCardInner)` across all castle cards, preventing massive 50-card re-renders upon user search input or single card expansion.
