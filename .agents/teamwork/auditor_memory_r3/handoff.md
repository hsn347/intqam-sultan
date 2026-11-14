# Forensic Audit Report — Live Memory & 0-Network Compliance in `tasks/building.py`

**Work Product**: `tasks/building.py`  
**Profile**: General Project (Development Mode per `ORIGINAL_REQUEST.md`)  
**Auditor**: Live Memory & 0-Network Auditor (`auditor_memory_r3`)  
**Verdict**: **CLEAN**

---

## 1. Observation

### 1.1 Memory Retrieval Paths in `tasks/building.py`

1. **`_is_vip_active()` (lines 394–440)**:
   - Direct memory read: `lord_info = self.get_ctrl("lordInfoCtrl") or {}` -> `vip = lord_info.get("vip", {})`.
   - Reads `vip.get("level")` and `vip.get("vipEndTime")` with strict type handling (`int`, `float`, `str`, `None`, empty dict).
   - Normalizes millisecond timestamps (`vip_end > 1e11 -> vip_end /= 1000.0`).
   - Requires `is_active = (vip_end > 0.0) and (vip_end > now_ts)`.
   - **Network calls**: Exactly 0.

2. **`calculate_max_build_slots()` (lines 558–621)**:
   - Evaluates 4 sequential criteria strictly in memory:
     - Criterion 1: `vip_active and vip_lv >= 2` (via `_is_vip_active()`).
     - Criterion 2: Active rental in `cityCtrl.queue["1201"]` (`st > 0 and tt > 0 and (st + tt) > now_ts`).
     - Criterion 3: Active construction in `queueCtrl["1201"]` (`rem > 0 and bid`).
     - Criterion 4: Active construction in `self.active_queues["1201"]` (`rem > 0 and bid`).
     - Fallback: Returns `1`.
   - **Network calls**: Exactly 0.

3. **`calculate_free_speedup_seconds()` (lines 441–456)**:
   - In-memory computation: checks `_is_vip_active()`.
   - If active, maps `vip_lv` to `VIP_FREE_SPEEDUP_SECONDS` (360s for Lv.1 up to 14,400s for Lv.15).
   - If expired or inactive, returns `BASE_FREE_SPEEDUP_SECONDS` (300 seconds).
   - **Network calls**: Exactly 0.

4. **`refresh_active_queues()` (lines 483–556)**:
   - In-memory pre-flight check:
     ```python
     q_ctrl = self.get_ctrl("queueCtrl")
     has_memory = isinstance(q_ctrl, dict)
     if not force_query and has_memory:
         for qtype in ["1200", "1201"]:
             ...
         self.active_queues = active
         return active
     ```
   - When `queueCtrl` exists in memory (even if `{}` empty), it returns `active` immediately at line 523 without sending `safe_query("1003", "1", ...)` at line 526.
   - **Network calls**: Exactly 0 when memory is present.

5. **Resource Deficit Pre-flight via `cityCtrl.reslist` (lines 841–847 and lines 1079–1085)**:
   - Checks `city = self._get_city_ctrl()` -> `reslist = city.get("reslist", {}) or city.get("resList", {})`.
   - Computes `missing_res = {r_id: amt - current for r_id, amt in cost_res.items() if current < amt}`.
   - If `not missing_res`, `ensure_resources` is completely bypassed.
   - If `missing_res` exists and `auto_open_chests` is disabled or chests cannot cover the deficit, halts execution before sending any construction (`1001/2`) or upgrade (`1001/3`) requests.
   - **Network calls**: 0 redundant queries; 0 requests when deficit cannot be satisfied.

6. **Item & Tool Checks via `backpackCtrl`**:
   - War Medals (`301101`) and Upgrade Tools (`costTools`, `costWEs`) (lines 1063–1076):
     Reads `bag = self.get_ctrl("backpackCtrl") or {}`. If `curr_cnt < req_cnt`, immediately returns `False, reason, None`.
   - Speedup Tools (`5011xx` and `5006xx`) (lines 1273–1321):
     Greedily matches required seconds against `SPEEDUP_ITEMS` in `backpackCtrl`. If no speedups are available, logs and exits without sending speedup requests.
   - In-memory consumption: `sync_in_memory_consumed_items` (lines 762–775) locally deducts used items from `backpackCtrl`.

### 1.2 0-Network Compliance on Busy Queue 1200 (lines 1528–1543)

- When queue 1200 is busy and `max_slots == 1`, `free_slots = max(0, 1 - 1) = 0`.
- The 0-Network Exit Guard triggers immediately:
  ```python
  if free_slots <= 0 and (not do_speedup or speedup_exhausted or self.speedup_count >= self.max_speedups_per_run):
      min_rem = min((float(qi.get("remain_time", 0) or 0) for qi in active_queues.values()), default=999999.0)
      summary_msg = f"طوابير البناء مشغولة بالكامل ({active_count}/{max_slots}) — المتبقي: {format_duration(min_rem)}"
      self.log(f"🛑 [Building] {summary_msg} (التوقف بصفر طلبات شبكية)")
      return TaskResult.ok(summary_msg, ...)
  ```
- **Network calls**: Exactly 0.

### 1.3 Empirical Test Executions

1. **Beetoo1 Live Memory Offline Test**:
   ```
   Command: python test_task_method.py -t building -o -m docs/beetoo1_live_memory.json calculate_max_build_slots calculate_free_speedup_seconds
   Result:
     ▶ [1/2] calculate_max_build_slots: 1 (type: int, execution time: 0.01 ms)
     ▶ [2/2] calculate_free_speedup_seconds: 300 (type: int, execution time: 0.00 ms)
   Exit code: 0
   ```

2. **Beetoo3 Live Memory Offline Test**:
   ```
   Command: python test_task_method.py -t building -o -m docs/beetoo3_live_memory.json calculate_max_build_slots calculate_free_speedup_seconds
   Result:
     ▶ [1/2] calculate_max_build_slots: 1 (type: int, execution time: 0.01 ms)
     ▶ [2/2] calculate_free_speedup_seconds: 300 (type: int, execution time: 0.00 ms)
   Exit code: 0
   ```

3. **Unit Test Suite Execution**:
   ```
   Command: python test_vip_slots_speedup.py
   Result: Ran 8 tests in 0.136s ... OK
   Exit code: 0
   ```

4. **Zero-Network Simulation & Assertion**:
   - `refresh_active_queues` with `{}` -> `assert len(conn.network_calls) == 0` -> PASSED.
   - Busy queue 1200 with `free_slots == 0` -> `assert len(conn.network_calls) == 0` -> PASSED.
   - Missing War Medal `301101` -> `assert len(conn.network_calls) == 0` -> PASSED.
   - Resource deficit with `auto_open_chests = False` -> `assert len(conn.network_calls) == 0` -> PASSED.
   - Accelerate queue with empty `backpackCtrl` -> 0 item speedup calls (`mode: "2"`) sent -> PASSED.

---

## 2. Logic Chain

1. **Rule 2 & Rule 6 of `GEMINI.md` Compliance**:
   - Rule 2 dictates 0-Network Checks relying strictly on `conn.init_data` before touching the server.
   - Rule 6 requires in-memory state inspection and fault-isolated pre-flight guards.
   - The audited code paths in `tasks/building.py` adhere 100% to this paradigm by querying `self.get_ctrl(...)` and `self._get_city_ctrl()`.
2. **Elimination of Queue Query Storms**:
   - Previously, if `queueCtrl` was empty, some tasks queried CMD 1003 / 1 repeatedly.
   - In `tasks/building.py` line 496, `has_memory = isinstance(q_ctrl, dict)` ensures that an initialized empty dictionary `{}` is recognized as a valid in-memory state representing no active queues, preventing network queries.
3. **VIP Expiration & Queue 1201 Slot Determination**:
   - In `docs/beetoo1_live_memory.json` (VIP 10, `vipEndTime: 0`) and `docs/beetoo3_live_memory.json` (VIP 9, `vipEndTime: 0`), both castles have expired VIP.
   - `_is_vip_active()` evaluates `(vip_end > 0.0) and (vip_end > now_ts)` which evaluates to `False`.
   - `calculate_max_build_slots()` checks criteria 1 to 4; since VIP is inactive, queue 1201 is not rented, and no construction is ongoing on 1201, it accurately returns `1`.
   - `calculate_free_speedup_seconds()` accurately falls back to `BASE_FREE_SPEEDUP_SECONDS` (`300` seconds).
4. **Zero-Network Exit Guard on Busy Queue 1200**:
   - With `max_slots == 1` and queue 1200 active, `free_slots == 0`.
   - The exit guard at lines 1528–1543 catches this state immediately before evaluating prerequisites, before calling `ensure_resources`, and before sending CMD 1001/3.
   - This eliminates rejected upgrade packets (`Err_QUEUE_BUSY (1001)`).

---

## 3. Caveats

- **No Caveats**: All live memory files (`docs/beetoo1_live_memory.json`, `docs/beetoo3_live_memory.json`), unit tests (`test_vip_slots_speedup.py`), and task method runner tests were executed directly with zero errors and 100% pass rates.

---

## 4. Conclusion

The implementation of Live Memory retrieval and 0-Network compliance in `tasks/building.py` is **authentic, robust, and completely free of integrity violations**:
- No facade or dummy implementations.
- No hardcoded test bypasses or test result spoofing.
- Complete 0-Network compliance across all pre-flight stages.
- Empirical verification on live test account memory dumps confirmed `calculate_max_build_slots == 1` and `calculate_free_speedup_seconds == 300`.

**Final Verdict**: **CLEAN**

---

## 5. Verification Method

To independently verify the empirical results of this forensic audit, execute the following commands in powershell:

```powershell
# 1. Syntax & Compilation
python -m py_compile tasks/building.py

# 2. VIP & Slot Calculation Unit Tests
python test_vip_slots_speedup.py

# 3. Beetoo1 Live Memory Offline Test
python test_task_method.py -t building -o -m docs/beetoo1_live_memory.json calculate_max_build_slots calculate_free_speedup_seconds

# 4. Beetoo3 Live Memory Offline Test
python test_task_method.py -t building -o -m docs/beetoo3_live_memory.json calculate_max_build_slots calculate_free_speedup_seconds
```
