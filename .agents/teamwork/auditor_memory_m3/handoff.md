# Handoff Report — Milestone 3: Live Memory Paths & 0-Network Pre-Flight

**Target**: `tasks/building.py` live memory paths, 0-network pre-flight, and state synchronization  
**Auditor**: `auditor_memory_m3` (Forensic Auditor)  
**Verdict**: **REQUEST_CHANGES**  

---

## 1. Observation

### Obs 1: 0-Network Pre-flight for Idle and Busy Queues
Direct execution of `refresh_active_queues(force_query=False)` against `docs/beetoo1_live_memory.json` (60 buildings, idle build queues) and `docs/beetoo3_live_memory.json`:
- `refresh_active_queues` returned `{}` with **0 network calls** recorded on `DummyConn.safe_query`.
- Direct execution of `run()` with busy queues (`1200` and `1201` populated in `queueCtrl` with > 60s remaining) and `speedup_castle=False`:
  - Returned: `TaskResult.ok("طوابير البناء مشغولة بالكامل (2/2) — المتبقي: 1 س و 56 د")`
  - Total network calls: **0**.
- Verification command:
  ```powershell
  python -c "import asyncio, json; ...; res = asyncio.run(task.run()); assert len(conn.network_calls) == 0"
  ```
  Result: `CONFIRMED: Exactly 0 network calls!`.

### Obs 2: Live Memory Key Structures in Reference Dumps
Inspection of `docs/beetoo1_live_memory.json` and `docs/beetoo3_live_memory.json`:
1. `cityCtrl.blist`: List of 60 dicts, each with format `{"binfo": {"bid": str, "lv": str, "index": str, "state": str, "curres": ..., "iid": str}}`.
2. `cityCtrl.reslist`: Dict mapping resource IDs (`"1002"`, `"1003"`, `"1004"`, `"1005"`, `"1006"`, `"1027"`) to string floats (e.g. `'1873902.675'`).
3. `queueCtrl`: Dict mapping queue type strings (`"1200"`, `"1201"`, `"1202"`, `"1203"`, `"1204"`, `"1205"`, `"1206"`, `"1212"`) to queue dictionaries containing `starttime`, `totaltime`, `ottime`, and `data` (which includes `bid`, `index`, `lv`).
4. `cityCtrl.queue["1201"]`: Rented builder queue in `cityCtrl.lua:820`: `data.queue["1201"]` with `starttime` and `totaltime`. If `(starttime + totaltime) > now`, the secondary queue is active.
5. `lordInfoCtrl.vip`: `{"level": 10, "vipEndTime": 0, ...}`. Privilege 7201 (`vipbuff.lua`) matches `VIP_FREE_SPEEDUP_SECONDS`.
6. `backpackCtrl`: Dict mapping item ID strings (`"301101"`, `"501101"`, `"500601"`) to `{"id": int, "count": int}`.

### Obs 3: Multi-Instance State Desynchronization in `sync_in_memory_completed_queue` (DEFECT 1)
In `tasks/building.py` lines 633–644:
```python
        # 2. تحديث المبنى إلى المستوى الجديد والحالة العادية (state = "0")
        city = self._get_city_ctrl()
        blist = city.get("blist", [])
        if isinstance(blist, list):
            for b in blist:
                bi = b.get("binfo", {})
                if str(bi.get("bid", "")) == bid_str:
                    bi["state"] = "0"
                    if target_lv is not None:
                        bi["lv"] = str(target_lv)
                    else:
                        bi["lv"] = str(int(bi.get("lv", 0) or 0) + 1)
                    break
```
- When upgrading a multi-instance building (e.g. Farm `bid="201"` at `index="1102"`), `sync_in_memory_upgrade` correctly marked the farm at `index="1102"` as `state: "2"`.
- When `sync_in_memory_completed_queue` ran, it searched `blist` and matched the FIRST entry with `bid == "201"` (which was the idle Farm at `index="1131"`), updated `index="1131"` to `lv=15`, and exited via `break`.
- The actual upgraded building at `index="1102"` was left in `state: "2"` permanently!
- Verbatim execution output from `.agents/teamwork/auditor_memory_m3/test_audit_memory.py`:
  ```
  AssertionError: Building state in blist is 2, expected '0'!
  ```

### Obs 4: Redundant Network Query in `construct_missing_building` (DEFECT 2)
In `tasks/building.py` line 758:
```python
        err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"
        if err == "0":
            msg = f"🎉 تم تشييد مبنى {b_name} بنجاح في الموقع [{target_index}]!"
            self.log(msg)
            self.upgraded_prereq_bids.add(bid_str)
            # تحديث الذاكرة الحية محلياً
            city = self._get_city_ctrl()
            if isinstance(city.get("blist"), list):
                city["blist"].append({
                    "binfo": {
                        "bid": bid_str,
                        "lv": "1",
                        "index": str(target_index),
                        "state": "2",
                        "curres": "0.0",
                    }
                })
            await self.refresh_active_queues(force_query=True)  # <--- LINE 758
            return True, msg
```
- Line 758 calls `await self.refresh_active_queues(force_query=True)`, which triggers `safe_query("1003", "1", {})` across the network.
- By contrast, line 992 in `execute_building_action` correctly uses `self.sync_in_memory_upgrade(allocated_qtype, bid_str, 1, target_index, cost_time, cost_res)` without any network query.

### Obs 5: Unharvested Resource Zero-Network Bypass Opportunity (OPTIMIZATION)
In `tasks/building.py` lines 1010–1013:
```python
        # جمع المحصول أولاً إن كان مبنى موارد
        if b_meta.get("harvest", False):
            iid = int(instance.get("iid", 0) or 0)
            await self.harvest_building_resource(int(bid_str), iid)
            await asyncio.sleep(0.3)
```
- In live memory, `instance` contains `"curres"`, representing current uncollected resource (e.g. `curres: 38550` or `curres: "0.0"`).
- Currently, `harvest_building_resource` (CMD 1001 / 8) is sent even if `curres == 0` or `"0.0"`.

---

## 2. Logic Chain

1. **Step 1 (Path Accuracy)**: The paths `cityCtrl.blist`, `cityCtrl.reslist`, `queueCtrl`, `cityCtrl.queue["1201"]`, `lordInfoCtrl.vip`, and `backpackCtrl` in `tasks/building.py` match the schema and field names of `docs/beetoo1_live_memory.json` and `docs/beetoo3_live_memory.json`.
2. **Step 2 (0-Network Pre-flight)**: `refresh_active_queues(force_query=False)` checks `self.get_ctrl("queueCtrl")` first. If present, it computes remaining time locally without touching the network. Both idle queues and busy queues terminate with 0 network calls.
3. **Step 3 (Sync Desynchronization Bug)**: `cityCtrl.blist` contains up to 8 instances for resource buildings (farms, sawmills, mines, tents, hospitals). `sync_in_memory_completed_queue` currently uses `if str(bi.get("bid", "")) == bid_str: ... break`, matching the first instance regardless of `index` or `state`. This causes state corruption: an un-upgraded building's level is overwritten, while the upgraded building remains trapped in `state: "2"`.
4. **Step 4 (Pre-Flight Violation)**: Line 758 of `construct_missing_building` uses `force_query=True`, causing a redundant server roundtrip (`CMD 1003/1`), violating the 0-network in-memory synchronization protocol.

---

## 3. Caveats

- In `docs/beetoo1_live_memory.json` and `docs/beetoo3_live_memory.json`, `vipEndTime` is `0`, which indicates a permanent VIP status. If an account has temporary VIP that has expired (`0 < vipEndTime < now`), `calculate_max_build_slots` checks `vip_lv >= 2` without checking `vipEndTime`. It is recommended to add `(vip_end == 0 or vip_end > time.time())`.
- No caveats regarding test coverage: both reference accounts were loaded and tested against all methods.

---

## 4. Conclusion & Required Changes

The architectural foundation of 0-network pre-flight in `tasks/building.py` is sound and authentic, but **two specific defects must be fixed before passing Milestone 3**:

### Required Fix 1: Fix `sync_in_memory_completed_queue` Multi-Instance Matching
In `tasks/building.py`, update `sync_in_memory_completed_queue` to:
1. Accept an optional `index: Optional[str] = None`.
2. If `index` is not passed, attempt to extract it from `qctrl.get(qtype_str, {}).get("data", {}).get("index")` or `self.active_queues.get(qtype_str, {}).get("raw", {}).get("data", {}).get("index")` before popping the queue.
3. In the `blist` loop, match `index` if available, or match `bi.get("state") == "2"`:
   ```python
   for b in blist:
       bi = b.get("binfo", {})
       if str(bi.get("bid", "")) == bid_str:
           if index and str(bi.get("index", "")) != str(index):
               continue
           if not index and str(bi.get("state", "0")) != "2":
               continue
           bi["state"] = "0"
           if target_lv is not None:
               bi["lv"] = str(target_lv)
           else:
               bi["lv"] = str(int(bi.get("lv", 0) or 0) + 1)
           break
   ```

### Required Fix 2: Replace Redundant `force_query=True` in `construct_missing_building`
In `tasks/building.py` lines 746–759:
Replace:
```python
            # تحديث الذاكرة الحية محلياً
            city = self._get_city_ctrl()
            if isinstance(city.get("blist"), list):
                city["blist"].append({
                    "binfo": {
                        "bid": bid_str,
                        "lv": "1",
                        "index": str(target_index),
                        "state": "2",
                        "curres": "0.0",
                    }
                })
            await self.refresh_active_queues(force_query=True)
            return True, msg
```
With:
```python
            allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
            self.sync_in_memory_upgrade(allocated_qtype, bid_str, 1, str(target_index), cost_time=cost_res.get("costTime", 3600), cost_res=cost_res)
            return True, msg
```

### Recommended Optimization: 0-Network Resource Harvest Check
In `tasks/building.py` line 1010:
Check `float(instance.get("curres", 0) or 0) > 0` before calling `harvest_building_resource`, eliminating unnecessary `1001/8` packets when uncollected yield is 0.

---

## 5. Verification Method

To independently verify the fixes:
1. Run the audit test script:
   ```powershell
   python .agents/teamwork/auditor_memory_m3/test_audit_memory.py
   ```
2. Verify that:
   - `sync_in_memory_completed_queue` updates only the upgraded instance (e.g. `index: 1102` becomes `state: 0, lv: 15`), while other instances (e.g. `index: 1131`) remain untouched (`state: 0, lv: 9`).
   - The test prints: `ALL AUDIT VERIFICATIONS PASSED SUCCESSFULLY!`.
3. Invalidation condition: If any multi-instance building retains `state: "2"` after completion sync, or if `refresh_active_queues` fires network queries when `queueCtrl` is loaded in memory.
