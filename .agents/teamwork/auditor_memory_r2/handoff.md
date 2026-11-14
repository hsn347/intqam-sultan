# Forensic Audit Report: Milestone 3 Iteration 2 — Live Memory & 0-Network Re-Audit

**Work Product**: `tasks/building.py`  
**Profile**: General Project (Integrity Forensics)  
**Auditor**: `auditor_memory_r2`  
**Target**: Live Memory Paths, In-Memory State Synchronization, and 0-Network Pre-Flight  
**Verdict**: **CLEAN**

---

## 1. Observation

Direct empirical inspection of `tasks/building.py` and execution of automated verification scripts against live memory dumps (`docs/beetoo1_live_memory.json`, `docs/beetoo3_live_memory.json`, `docs/lucifer_live_memory.json`, `docs/sample_live_memory.json`) revealed the following:

### Obs 1: Multi-Instance In-Memory Building Sync
In `tasks/building.py` lines 629–686:
```python
    def sync_in_memory_completed_queue(
        self,
        qtype: str,
        bid: str,
        target_lv: Optional[int] = None,
        index: Optional[Union[str, int]] = None,
    ):
        ...
        target_index = str(index) if index is not None else None
        if not target_index:
            if isinstance(qctrl, dict) and qtype_str in qctrl:
                q_data = qctrl[qtype_str].get("data", {})
                if isinstance(q_data, dict) and q_data.get("index"):
                    target_index = str(q_data.get("index"))
            if not target_index and qtype_str in self.active_queues:
                q_idx = self.active_queues[qtype_str].get("index")
                if q_idx:
                    target_index = str(q_idx)
                else:
                    q_raw = self.active_queues[qtype_str].get("raw", {})
                    if isinstance(q_raw, dict):
                        q_data = q_raw.get("data", {})
                        if isinstance(q_data, dict) and q_data.get("index"):
                            target_index = str(q_data.get("index"))

        # 1. إزالة الطابور من queueCtrl و active_queues
        if isinstance(qctrl, dict):
            qctrl.pop(qtype_str, None)
        self.active_queues.pop(qtype_str, None)

        # 2. تحديث المبنى إلى المستوى الجديد والحالة العادية (state = "0")
        city = self._get_city_ctrl()
        blist = city.get("blist", [])
        if isinstance(blist, list):
            for b in blist:
                if not isinstance(b, dict):
                    continue
                bi = b.get("binfo", {})
                if not isinstance(bi, dict):
                    continue
                if str(bi.get("bid", "")) == bid_str:
                    if target_index:
                        if str(bi.get("index", "")) != target_index:
                            continue
                    else:
                        if str(bi.get("state", "0")) != "2":
                            continue
                    bi["state"] = "0"
                    if target_lv is not None:
                        bi["lv"] = str(target_lv)
                    else:
                        bi["lv"] = str(int(bi.get("lv", 0) or 0) + 1)
                    break
```
- In `accelerate_queue_to_completion`:
  - Line 1174: `q_index = str(q_info.get("index", "") or q_info.get("raw", {}).get("data", {}).get("index", "")) or None`
  - Lines 1180, 1201, 1282: `self.sync_in_memory_completed_queue(qtype, bid, target_lv, index=q_index)` passes the exact building instance index.
- Multi-instance empirical test: In a city with 4 Farm instances (indices `1101`, `1102`, `1103`, `1104`), upgrading instance `1102` sets only `1102` to `state: "2"`. Upon completion, only `1102` transitioned to `state: "0"` and `lv: 13`. Instances `1101`, `1103`, and `1104` remained completely unmodified. Fallback to `state == "2"` when `index` is absent was also verified.

### Obs 2: Elimination of 0-Network Query Leak in Construction
In `tasks/building.py` lines 797–805 (`construct_missing_building`):
```python
        err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"
        if err == "0":
            msg = f"🎉 تم تشييد مبنى {b_name} بنجاح في الموقع [{target_index}]!"
            self.log(msg)
            self.upgraded_prereq_bids.add(bid_str)
            # تحديث الذاكرة الحية محلياً دون أي طلب شبكي (0-Network Sync)
            allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
            self.sync_in_memory_upgrade(allocated_qtype, bid_str, 1, str(target_index), cost_time, cost_res)
            return True, msg
```
- The former call `await self.refresh_active_queues(force_query=True)` on line 758 was completely removed.
- Empirical test execution in `.agents/teamwork/auditor_memory_r2/test_forensic_deep.py`:
  - Recorded network calls during construction: `[('1001', '2', {'bid': '116', 'mode': '0', 'index': '1064'})]`.
  - Exactly 1 network packet sent (the construction request itself).
  - 0 query calls (`safe_query("1003", "1", {})`) fired.

### Obs 3: Harvest Pre-Flight Guard (`curres > 0`)
In `tasks/building.py` lines 1074–1079 (`execute_building_action`):
```python
        # جمع المحصول أولاً إن كان مبنى موارد ولديه محصول متاح (curres > 0)
        if b_meta.get("harvest", False) and float(instance.get("curres", 0) or 0) > 0:
            iid = int(instance.get("iid", 0) or 0)
            await self.harvest_building_resource(int(bid_str), iid)
            await asyncio.sleep(0.3)
```
- When `curres` is `"0.0"`, `0`, or `None`: `harvest_building_resource` (CMD 1001/8) is skipped entirely (0 network packets).
- When `curres` is `"15000.5"`: `harvest_building_resource` is dispatched (`[('1001', '8', {'bid': 201, 'iid': 10001}), ('1001', '3', ...)]`).

### Obs 4: 0-Network Pre-Flight on Idle and Busy Queues
1. **Idle Queues**:
   - Tested against `beetoo1_live_memory.json` (60 buildings, idle queues) and `beetoo3_live_memory.json` (60 buildings, idle queues).
   - Calling `refresh_active_queues(force_query=False)` returned `{}` with **0 network calls** recorded.
2. **Busy Queues**:
   - Calling `run()` with busy build queues (`1200` and `1201` active with > 60s remaining) and `speedup_castle=False`:
     - Returned: `TaskResult.ok("طوابير البناء مشغولة بالكامل (2/2) — المتبقي: 1 س و 0 د")`
     - Network calls made: **0**.
3. **Cross-Account Validation**:
   - Evaluated across 4 distinct memory dumps: `beetoo1_live_memory.json`, `beetoo3_live_memory.json`, `lucifer_live_memory.json`, `sample_live_memory.json`. All 4 completed queue and pre-flight evaluation with **0 network calls**.

---

## 2. Logic Chain

1. **Step 1 (Multi-Instance Correctness)**:
   - Observation 1 establishes that `sync_in_memory_completed_queue` receives `index` from the queue object or resolves it from `queueCtrl["data"]["index"]`.
   - When updating `blist`, matching on `target_index` (or falling back to `state == "2"`) guarantees that only the specific building instance undergoing construction/upgrade transitions from `state: "2"` to `state: "0"` and increments its level.
   - Idle peer instances of the same `bid` (such as farms at other indices) are untouched. State desynchronization is 100% resolved.

2. **Step 2 (0-Network Construction Compliance)**:
   - Observation 2 demonstrates that line 758's `force_query=True` was replaced with `self.sync_in_memory_upgrade(...)`.
   - The queue allocation (`1200` vs `1201`), `active_queues` mapping, and `blist` entry creation are performed purely in local memory, eliminating unnecessary server query roundtrips (`safe_query("1003", "1", {})`) while maintaining exact state alignment.

3. **Step 3 (Harvest Guard Optimization)**:
   - Observation 3 confirms that resource buildings with zero uncollected yield (`curres <= 0`) bypass `CMD 1001/8`.
   - Unnecessary network packets before upgrades are eliminated while preserving harvest behavior when uncollected resources exist.

4. **Step 4 (0-Network Pre-flight Integrity)**:
   - Observation 4 confirms that `tasks/building.py` checks `self.get_ctrl("queueCtrl")` before contacting the network.
   - Both idle accounts and busy accounts exit cleanly without sending any server packets, complying strictly with `GEMINI.md` Rule 2 and Rule 6.

5. **Conclusion**:
   All 4 audit requirements are fully satisfied with zero regressions and zero remaining defects.

---

## 3. Caveats

- **No Caveats**: All 4 areas specified in DISPATCH.md were independently verified via unit tests, forensic stress scripts, and live memory simulations across 4 real account dumps. No edge case or regression was observed.

---

## 4. Conclusion & Verdict

**Verdict: CLEAN**

The implementation in `tasks/building.py` satisfies all live memory, 0-network, and in-memory state synchronization requirements:
1. Multi-instance building state sync resolves by explicit `index` or `state == "2"`.
2. 0-network leak in `construct_missing_building` is 100% removed.
3. Harvest `curres > 0` check eliminates redundant network queries.
4. 0-Network Pre-flight operates cleanly on both idle and busy queues.

---

## 5. Verification Method

To independently reproduce the forensic verification results:

1. **Run the auditor test suite**:
   ```powershell
   python .agents/teamwork/auditor_memory_m3/test_audit_memory.py
   ```
   *Expected Output*: `ALL AUDIT VERIFICATIONS PASSED SUCCESSFULLY!`.

2. **Run the deep forensic test suite**:
   ```powershell
   python .agents/teamwork/auditor_memory_r2/test_forensic_deep.py
   ```
   *Expected Output*: `>>> ALL FORENSIC DEEP AUDIT CHECKS PASSED WITH 0 DEFECTS! <<<`.

3. **Run multi-account live memory verification**:
   ```powershell
   python -c "
   import json, asyncio
   from tasks.building import BuildingTask
   files = ['docs/beetoo1_live_memory.json', 'docs/beetoo3_live_memory.json', 'docs/lucifer_live_memory.json', 'docs/sample_live_memory.json']
   class M:
       def __init__(self, d): self.init_data, self.calls = d, []
       def get_ctrl(self, n): return self.init_data.get(n, {})
       async def safe_query(self, c, sc, d, **kw): self.calls.append((c, sc)); return {'err': '0'}
   async def run():
       for f in files:
           with open(f, 'r', encoding='utf-8') as fp: d = json.load(fp)
           c = M(d)
           t = BuildingTask(c, log_func=lambda m: None)
           q = await t.refresh_active_queues(force_query=False)
           assert len(c.calls) == 0, f'Query leaked on {f}'
       print('ALL 4 LIVE MEMORY DUMPS PASSED 0-NETWORK CHECKS!')
   asyncio.run(run())
   "
   ```
   *Expected Output*: `ALL 4 LIVE MEMORY DUMPS PASSED 0-NETWORK CHECKS!`.
