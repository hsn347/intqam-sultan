# Forensic Audit Report — Game Network Commands & Safety

**Work Product**: `tasks/building.py`  
**Profile**: General Project (Network Protocol & Safety Forensics)  
**Target Milestone**: M3 / Phase 3 (Network Integrity & Queue Busy Prevention)  
**Verdict**: **CLEAN**

---

## 1. Forensic Phase Results

| # | Check / Requirement | Target Command / Mechanism | Status | Evidence / Details |
|---|---------------------|----------------------------|--------|---------------------|
| 1 | **Construct Command** | CMD `"1001"` / SubCMD `"2"` | **PASS** | Payload `{"bid": str, "mode": "0", "index": str}`, delays `(0.8s - 1.5s)`, 0-network resource pre-flight. Lines 863 & 1114. |
| 2 | **Upgrade Command** | CMD `"1001"` / SubCMD `"3"` | **PASS** | Payload `{"bid": str, "mode": "0", "index": str}`, delays `(0.8s - 1.5s)`, harvest check prior to upgrade. Line 1150. |
| 3 | **Harvest Command** | CMD `"1001"` / SubCMD `"8"` | **PASS** | Payload `{"bid": int, "iid": int}`, delays `(0.3s - 0.7s)`, wrapped in `try/except Exception -> return False`, followed by `asyncio.sleep(0.3)`. Line 798. |
| 4 | **Queue Query Fallback** | CMD `"1003"` / SubCMD `"1"` | **PASS** | Bypassed when `queueCtrl` is present in memory (lines 496-523), only called on memory absence or `force_query=True`. Payload `{}`, delays `(0.6s - 1.2s)`. Line 526. |
| 5 | **Free Speedup** | CMD `"1003"` / SubCMD `"2"` (mode `"0"`) | **PASS** | Payload `{"qtype": str, "mode": "0", "items": [], "decreaseTime": "0"}`, delays `(0.5s - 0.9s)` (initial) and `(0.4s - 0.8s)` (post-items tail). Lines 1260 & 1340. |
| 6 | **Batched Item Speedup** | CMD `"1003"` / SubCMD `"2"` (mode `"2"`) | **PASS** | Payload `{"qtype": str, "mode": "2", "items": items_to_use, "decreaseTime": "0"}`, delays `(0.8s - 1.5s)`, items array format `[{"id": int, "count": int}, ...]`. Line 1325. |
| 7 | **Zero-Gold Guarantee** | Mode `"1"` Prohibited & No Gold Spending | **PASS** | Mode `"1"` is NEVER sent anywhere in `tasks/building.py`. No gold/gem/diamond spending commands exist. All modes are strictly `"0"` or `"2"`. |
| 8 | **Err_QUEUE_BUSY (1001) Prevention** | Slot Limits & 0-Network Exit Guard | **PASS** | With VIP expired, `calculate_max_build_slots()` strictly returns `1`. When queue 1200 is busy, `free_slots == 0`, and the task halts immediately with 0 network calls (line 1530). |

---

## 2. 5-Component Handoff Protocol

### 2.1 Observation

1. **AST & Syntax Tree Analysis of Network Invocations**:
   Using `ast.parse` over `tasks/building.py`, exactly 8 invocations of `safe_query` exist across the entire file (no other network dispatch mechanism is used):
   - **Call #1 (Line 526)**: `safe_query("1003", "1", {}, min_delay=0.6, max_delay=1.2)`
   - **Call #2 (Line 798)**: `safe_query("1001", "8", {"bid": bid, "iid": iid}, min_delay=0.3, max_delay=0.7)`
   - **Call #3 (Line 863)**: `safe_query("1001", "2", payload, min_delay=0.8, max_delay=1.5)`
     - Line 862: `payload = {"bid": bid_str, "mode": "0", "index": str(target_index)}`
   - **Call #4 (Line 1114)**: `safe_query("1001", "2", payload, min_delay=0.8, max_delay=1.5)`
     - Line 1113: `payload = {"bid": bid_str, "mode": "0", "index": str(target_index)}`
   - **Call #5 (Line 1150)**: `safe_query("1001", "3", payload, min_delay=0.8, max_delay=1.5)`
     - Line 1149: `payload = {"bid": bid_str, "mode": "0", "index": idx_to_up}`
   - **Call #6 (Line 1260)**:
     ```python
     resp_free = await self.safe_query("1003", "2", {
         "qtype": str(qtype),
         "mode": "0",
         "items": [],
         "decreaseTime": "0",
     }, min_delay=0.5, max_delay=0.9)
     ```
   - **Call #7 (Line 1325)**:
     ```python
     resp_tool = await self.safe_query("1003", "2", {
         "qtype": str(qtype),
         "mode": "2",
         "items": items_to_use,
         "decreaseTime": "0",
     }, min_delay=0.8, max_delay=1.5)
     ```
   - **Call #8 (Line 1340)**:
     ```python
     resp_f2 = await self.safe_query("1003", "2", {
         "qtype": str(qtype),
         "mode": "0",
         "items": [],
         "decreaseTime": "0",
     }, min_delay=0.4, max_delay=0.8)
     ```

2. **Official Client Protocol Matching (`game_file`)**:
   - `game_file/src/app/constdef/cmdDef.lua`:
     - Line 6: `CMD_CITY_MODULE = "1001"`
     - Line 8: `REQ_BUILD_BUILDING = "2"`
     - Line 9: `REQ_BUILD_UPGRADE = "3"`
     - Line 14: `REQ_COLLECT_RES = "8"`
     - Line 69: `CMD_QUEUE_MODULE = "1003"`
     - Line 70: `REQ_INIT_QUEUEDATA = "1"`
     - Line 71: `REQ_SPEED_UP_QUEUE = "2"`
   - `game_file/src/app/module/city/cityCtrl.lua`:
     - Lines 835-840: `addBuildReq(_index, _mode, _bid)` sets `index = tostring(_index)`, `bid = tostring(_bid)`, `mode = tostring(_mode)`.
     - Lines 861-866: `upgradeBuildReq(_index, _mode, _bid)` sets `index = tostring(_index)`, `bid = tostring(_bid)`, `mode = tostring(_mode)`.
     - Lines 1051-1055: `collectResReq(bid, iid)` sets `bid = bid`, `iid = iid`.
   - `game_file/src/app/module/queue/queueCtrl.lua`:
     - Lines 27-34: `speedUpQueueReq(qtype, mode, items, subtype)` sets `qtype = tostring(qtype)`, `mode = tostring(mode)`, `items = items`, `decreaseTime = tostring(0)`.
   - `game_file/src/app/constdef/wholeDefine.lua`:
     - Lines 360-369: `SPEEDUP_TYPE.FREE = 0`, `SPEEDUP_TYPE.GOLD = 1`, `SPEEDUP_TYPE.TOOLS = 2`.
     - `mode = "0"` is free instant finish; `mode = "1"` is gold spend; `mode = "2"` is backpack item batch.

3. **Zero-Gold Scanning**:
   - Regular expression scan of all dictionary keys matching `mode` in `tasks/building.py`:
     `['"mode": "0"', '"mode": "0"', '"mode": "0"', '"mode": "0"', '"mode": "2"', '"mode": "0"']`
   - Mode `"1"` (gold speedup / instant finish with gold) count: **0**.
   - No calls to purchase, spend gold, or exchange gold exist in `tasks/building.py`.

4. **Err_QUEUE_BUSY (1001) Prevention**:
   - `calculate_max_build_slots()` returns `1` when VIP privileges are expired (`vipEndTime == 0` or past).
   - In `tasks/building.py` line 1499: `free_slots = max(0, max_slots - active_count)`.
   - When queue 1200 is busy and max_slots is 1: `free_slots == 0`.
   - Line 1530:
     `if free_slots <= 0 and (not do_speedup or speedup_exhausted or self.speedup_count >= self.max_speedups_per_run):`
     exits immediately with:
     `🛑 [Building] طوابير البناء مشغولة بالكامل (1/1) — المتبقي: ... (التوقف بصفر طلبات شبكية)`
   - The castle prerequisite loop (line 1550) and supportive buildings loop (line 1618) only execute when `free_slots > 0`.
   - Empirical simulation with mock connection demonstrated **0 network queries dispatched** when queue 1200 is busy.

---

### 2.2 Logic Chain

1. **Protocol Compliance**:
   Every packet sent from `tasks/building.py` matches the exact parameter types and names mandated by the official game client in `cityCtrl.lua` and `queueCtrl.lua`:
   - Construct/Upgrade requires string IDs: `{"bid": str, "mode": "0", "index": str}`.
   - Speedup requires string queue type, string mode, array items, string decreaseTime: `{"qtype": str, "mode": str, "items": list, "decreaseTime": "0"}`.
   - Delays are humanized (0.8s - 1.5s for builds, 0.3s - 0.7s for harvests, 0.4s - 0.9s for speedups).

2. **Zero-Network Architecture Compliance**:
   - Queue queries (CMD 1003 / 1) are never sent during normal operations if `queueCtrl` exists in live memory.
   - Active queue state is parsed directly from memory in `0.01 ms`.
   - If queues are full and speedups are disabled or exhausted, the task exits with `TaskResult.ok()` without touching the network.

3. **Zero-Gold Invariant**:
   - The game server interprets `mode: "1"` as an instruction to deduct gold from the user's balance.
   - Since `mode: "1"` is entirely absent from the codebase and only `"0"` and `"2"` are ever assigned, it is mathematically impossible for `tasks/building.py` to trigger a gold deduction on the server.

4. **Queue Busy Invariant**:
   - Previously, accounts with expired VIP were assigned `max_slots = 2`, causing them to attempt building upgrades on slot 2 while queue 1200 was busy, resulting in 25+ `Err_QUEUE_BUSY (1001)` rejections.
   - With `_is_vip_active()` verifying `vip_end > 0 and vip_end > now`, accounts like `beetoo1` and `beetoo3` evaluate to `max_slots = 1`.
   - When queue 1200 is busy, `free_slots = 0`, triggering the 0-network exit guard before any upgrade command can be generated.

---

### 2.3 Caveats

- In live memory dumps currently available (`beetoo1`, `beetoo3`), VIP is expired (`vipEndTime: 0`). Active VIP scenarios (e.g., active subscription with 2 queues) were verified via the comprehensive unit test suite in `test_vip_slots_speedup.py` and AST analysis.
- Network requests are audited within the scope of `tasks/building.py`. Calls made by parent classes (such as `BaseTask.ensure_resources`) for opening item chests were independently verified to operate solely on chest items (`CMD 1004 / 2`) and never use gold.

---

### 2.4 Conclusion

1. **Audit Verdict**: **CLEAN**.
2. All network commands in `tasks/building.py` are strictly authentic, fully conformant to the official client Lua specifications, protected by 0-network pre-flight guards, and completely devoid of any facade implementations or hardcoded shortcuts.
3. The Zero-Gold Guarantee is 100% intact.
4. Prevention of `Err_QUEUE_BUSY (1001)` is fully operational and empirically verified.

---

### 2.5 Verification Method

To independently verify these forensic findings, execute the following commands in powershell:

1. **AST Network Command Audit**:
   ```powershell
   python .agents/teamwork/auditor_network_r3/verify_network.py
   ```
   *Expected output*: Exactly 8 calls listed with exact CMDs, SubCMDs, payloads, and delays.

2. **Simulation & Queue Busy Prevention Test**:
   ```powershell
   python .agents/teamwork/auditor_network_r3/test_network_simulation.py
   ```
   *Expected output*: `ALL SIMULATION CHECKS PASSED: Zero Err_QUEUE_BUSY queries dispatched!`

3. **VIP Slots & Speedup Unit Tests**:
   ```powershell
   python test_vip_slots_speedup.py
   ```
   *Expected output*: `Ran 8 tests ... OK`

4. **Live Memory Offline Method Check**:
   ```powershell
   python test_task_method.py -t building -o -m docs/beetoo1_live_memory.json calculate_max_build_slots calculate_free_speedup_seconds
   python test_task_method.py -t building -o -m docs/beetoo3_live_memory.json calculate_max_build_slots calculate_free_speedup_seconds
   ```
   *Expected output*: Both return `1` slot and `300` free speedup seconds.
