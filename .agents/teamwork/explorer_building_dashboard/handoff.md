# Handoff Report — Building Delays & Dashboard UI Investigation (R3 & R4)

**Agent**: explorer_building_dashboard  
**Milestone**: Investigation Phase (R3 & R4)  
**Type**: Hard Handoff (Investigation Complete)  
**Recipient**: Orchestrator / Implementers  

---

## 1. Observation

1. **`tasks/building.py` Network Calls & Delays**:
   - `tasks/building.py:526`: `resp = await self.safe_query("1003", "1", {}, min_delay=0.6, max_delay=1.2)` (Queue refresh).
   - `tasks/building.py:798`: `resp = await self.safe_query("1001", "8", {"bid": bid, "iid": iid}, min_delay=0.3, max_delay=0.7)` (Harvest).
   - `tasks/building.py:863`: `resp = await self.safe_query("1001", "2", payload, min_delay=0.8, max_delay=1.5)` (Construct).
   - `tasks/building.py:1114`: `resp = await self.safe_query("1001", "2", payload, min_delay=0.8, max_delay=1.5)` (Execute Construct).
   - `tasks/building.py:1146`: `await self.harvest_building_resource(int(bid_str), iid)` followed by `await asyncio.sleep(0.3)`.
   - `tasks/building.py:1150`: `resp = await self.safe_query("1001", "3", payload, min_delay=0.8, max_delay=1.5)` (Upgrade).
   - `tasks/building.py:1260`: `resp_free = await self.safe_query("1003", "2", ..., min_delay=0.5, max_delay=0.9)` (Free speedup).
   - `tasks/building.py:1330`: `resp_tool = await self.safe_query("1003", "2", ..., min_delay=0.8, max_delay=1.5)` (Bag speedup batch).
   - `tasks/building.py:1345`: `resp_f2 = await self.safe_query("1003", "2", ..., min_delay=0.4, max_delay=0.8)` (Tail free speedup).
   - `tasks/building.py:1516`: In `for qt in list(active_queues.keys()):` accelerating multiple queues without sleep between iterations.
   - `tasks/building.py:1590-1597`: `execute_building_action` followed immediately (`0ms`) by `accelerate_queue_to_completion`.
   - `tasks/building.py:1610`: `await asyncio.sleep(random.uniform(0.5, 1.2))` between cascade passes.
   - `tasks/building.py:1621-1626`: `execute_support_upgrade` in loop without sleep between consecutive supportive building upgrades.

2. **Dashboard Stop Button Double-Click Trace**:
   - `CastleCard.tsx:283-299`:
     ```typescript
     const handleConfirmStop = () => {
       setIsStopping(true)
       botControl.mutate({ castle, state: 'idle' }, {
         onSuccess: () => {
           toast.success(t('accounts.botStoppedSuccess'))
           setShowStopModal(false)
           setLiveState('idle')
           setConnState('idle')
           setIsStopping(false)
         }, ...
     ```
   - `CastleCard.tsx:151-159`:
     ```typescript
     useEffect(() => {
       if (isStopping || isStarting) return

       if (realStatus && realStatus !== 'offline') {
         const bs = realStatus === 'starting' ? 'starting' : (realStatus === 'idle' ? 'idle' : (realStatus === 'error' ? 'error' : 'running'))
         setLiveState(bs)
         setConnState(realStatus)
       }
     }, [realStatus, isStopping, isStarting])
     ```
   - `api_server.py:1214`: In `ws_single_castle_status`, the update loop polls SQLite on a 2-second sleep: `await asyncio.sleep(2.0)`.
   - `useCastles.ts:451`: In `useBotControl`, `onSettled` waits `setTimeout(..., 1500)` before invalidating queries when `state === 'idle'`.

3. **Ghost "Running" Castle Cards**:
   - `api_server.py:511-536` (`list_castles`) & `548-571` (`get_castle_detail`):
     ```python
     bot = bot_manager.get_bot(em)
     if bot:
         ...
     else:
         if c.get("conn_state") == "error" or c.get("state") == "error":
             ...
         elif c.get("conn_state") == "sealed" or c.get("state") == "sealed":
             ...
     ```
     When `bot` is None, `c["state"]` and `c["conn_state"]` are NEVER reset to `"idle"`. If SQLite had `state = 'running'` (e.g., from before an ungraceful shutdown or reboot), it returns `"state": "running"`.
   - `useCastles.ts:182-187`: `useCastles` uses `initialData: () => getCachedCastles(userId)` with `staleTime: 60_000`. Stale localStorage data is served as fresh for up to 60 seconds.
   - `CastleCard.tsx:110 & 182`:
     ```typescript
     const isActuallyRunning = Boolean(
       ... || (castle.bot_status?.state === 'running' && castle.bot_status?.conn_state !== 'starting')
     )
     const isBotActive = ... || Boolean(castle.bot_status?.state === 'running')
     ```
     Unconditionally checks `castle.bot_status?.state === 'running'`, locking the UI into "running" despite WebSocket or network idle states.

4. **UI Re-renders & Resource Overhead**:
   - `Accounts.tsx:611-614 & 637-640`: Passes inline functions `onToggleExpand={() => ...}` to `CastleCard`, completely defeating `React.memo(CastleCardInner)`.
   - `TaskTabContent.tsx:1-3164`: 3,164 lines of complex form and accordion logic. Not wrapped with `React.memo`. Once expanded (`hasBeenExpanded = true`), it re-renders entirely on every parent card tick.
   - `CastleCard.tsx:100`: Opens one WebSocket connection per card (`/ws/status/{castle.id}`), causing N concurrent 2-second polling loops on backend SQLite.

---

## 2. Logic Chain

1. **Building Delays (R3)**:
   - *From Observation 1*: Multiple calls to `safe_query` in `tasks/building.py` have ranges up to `1.5s` (too slow) or down to `0.3s` (too fast, risking anti-bot triggers).
   - Furthermore, sequential operations (initiating upgrade -> instant speedup, and consecutive supportive upgrades) occur with `0ms` delay between them.
   - *Logical Inference*: Standardizing all building `safe_query` calls and inter-action loop steps to `random.uniform(0.5, 0.9)` provides consistent human-like timing without exceeding event loop budgets or triggering timeouts.

2. **Stop Button Double-Click (R4)**:
   - *From Observation 2*: When the user stops a bot, `handleConfirmStop` receives the HTTP response and runs `onSuccess`, setting `setIsStopping(false)` and `setLiveState('idle')`.
   - Transitioning `isStopping` to `false` triggers `useEffect([realStatus, isStopping, isStarting])`.
   - Because the backend WebSocket loop polls on `await asyncio.sleep(2.0)`, `realStatus` is still `'running'` during the first 0-2000ms.
   - The effect executes `setLiveState('running')` and `setConnState('running')`, instantly reverting the optimistic `'idle'` state.
   - The user sees the button remain on "Stop", clicks it again 2 seconds later (after the WebSocket has finally delivered `'idle'`), and only then does the stop action visually stick.
   - *Logical Inference*: Protecting the optimistic `'idle'` state with a short grace guard (`isJustStoppedRef` for 2.5s) and immediately invalidating React Query cache prevents the stale WebSocket tick from overwriting the stopped state.

3. **Ghost "Running" Status (R4)**:
   - *From Observation 3*: If `api_server.py` restarts or a bot process stops without a clean DB update, `bot_manager.get_bot(email)` returns `None`.
   - In `list_castles`, the `else:` branch fails to set `c["state"] = "idle"`.
   - `GET /api/castles` returns `state = 'running'`.
   - The frontend stores this in `localStorage` via `saveCachedCastles`.
   - `CastleCard`'s fallback condition `Boolean(castle.bot_status?.state === 'running')` keeps the card in the running state forever until cache is cleared or refreshed.
   - *Logical Inference*: Explicitly resetting `c["state"] = "idle"` and `c["conn_state"] = "idle"` when `bot` is `None` in `api_server.py`, clearing legacy running states in SQLite on server startup, and tightening the card's `isActuallyRunning` predicate eliminates ghost cards completely.

4. **UI Performance Optimization (R4)**:
   - *From Observation 4*: `React.memo(CastleCardInner)` is rendered useless by inline arrow props (`onToggleExpand`).
   - Every search input or card expansion triggers a full render pass on all cards, re-evaluating the 3,164-line `TaskTabContent` component for every previously opened card.
   - *Logical Inference*: Using `useCallback` for `handleToggleExpand` in `Accounts.tsx` and wrapping `TaskTabContent` with `React.memo` stops the re-render cascades while preserving 100% of the UI design and layout.

---

## 3. Caveats

1. **WebSocket Consolidation**:
   While `useUserBotStatuses` exists for a unified WebSocket endpoint (`/ws/user-status/{user_id}`), transitioning from per-card WebSockets to a single multiplexed connection requires syncing status message payloads. For immediate stability, fixing the 2.5s grace guard on `CastleCard` resolves the user-facing double-click issue with zero architectural risk.
2. **Third-Party Game Server Response Time**:
   The proposed `0.5s - 0.9s` random delays assume healthy network connectivity to the official game servers. If packet latency spikes above 5 seconds, the delay does not compound because `safe_query` applies jitter *before* the request is sent, not during socket wait.
3. **Multi-Tab Synchronization**:
   If a user has multiple browser tabs open simultaneously, `localStorage` cache invalidation relies on the React Query refetch cycle or BroadcastChannel. Immediate cache update in `onMutate` ensures the current tab reflects state instantly.

---

## 4. Conclusion

The investigation has established complete evidence chains for both R3 and R4:
- **R3**: Solved by replacing `safe_query` jitter ranges and loop pauses with `random.uniform(0.5, 0.9)` in `tasks/building.py` (lines 526, 798, 863, 1114, 1146, 1150, 1330, 1345, 1519, 1596, 1610, 1625).
- **R4 Stop Button**: Solved by eliminating the race condition in `CastleCard.tsx` using an `isJustStoppedRef` guard, removing the 1,500ms delay in `useBotControl`, and updating `localStorage` optimistically.
- **R4 Ghost Running**: Solved by setting `state = 'idle'` in `api_server.py` (`list_castles` & `get_castle_detail`) when `bot_manager.get_bot(em)` is `None`, adding a startup SQLite state cleanup, and fixing the fallback clause in `CastleCard.tsx`.
- **R4 Performance**: Solved by stabilizing props with `useCallback` in `Accounts.tsx` and wrapping `TaskTabContent` in `React.memo`.

All findings, before/after code snippets, and structural rationale are fully documented in `report.md`.

---

## 5. Verification Method

To independently verify these conclusions:

1. **Verify Building Delays (R3)**:
   - Inspect `tasks/building.py` line numbers referenced above.
   - Execute building task offline or test runner:
     ```powershell
     python test_task_method.py --email LUCIFER@g4.com --task building run
     ```
   - Check execution log for human jitter between building commands.

2. **Verify Stop Button Race Condition (R4)**:
   - Inspect `dashboard/src/components/accounts/CastleCard.tsx` lines 151-159 and lines 283-299.
   - Trace `realStatus` vs `liveState` upon `setIsStopping(false)`: notice how `realStatus` is still `'running'` from WebSocket, immediately overriding `'idle'`.

3. **Verify Ghost Running in API Server (R4)**:
   - Inspect `api_server.py` line 527 (`else:` branch under `bot = bot_manager.get_bot(em)`): confirm lack of `c["state"] = "idle"`.
   - Update a test row in SQLite `castle_states` to `state = 'running'`, ensure no bot is active in `bot_manager`, and query `GET /api/castles`: notice the API returns `state: 'running'` for a nonexistent bot process.

4. **Invalidation Conditions**:
   - If `api_server.py`'s `bot_manager` retains bot instances across server restarts without memory loss, the DB startup reconciliation would be redundant (it does not; memory is cleared on process exit).
   - If `CastleCard`'s `useRealBotStatus` hook were updated synchronously on the HTTP response before rendering, the double-click bug would not occur (it is not; it updates via WebSocket on a 2.0s polling cycle).
