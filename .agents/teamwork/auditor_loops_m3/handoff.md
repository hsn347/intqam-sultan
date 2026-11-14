# Milestone 3 Audit Report: Loops (for/while) & If-Conditions Safety

**Target Work Product**: `tasks/building.py`  
**Auditor Role**: `teamwork_auditor` / `forensic_auditor`  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\auditor_loops_m3\`  
**Date & UTC Timestamp**: `2026-10-31T22:05:00Z`  
**Verdict**: 🔴 **REQUEST_CHANGES** (Integrity & Logic Defects Identified)

---

## Executive Summary

A comprehensive line-by-line static AST analysis and dynamic simulation audit was conducted on all loops (`while`, `for`), recursions, conditional branches (`if`/`elif`/`else`), and exception handling blocks in `tasks/building.py`.

The analysis discovered **1 Critical Defect**, **1 High Defect**, **2 Medium Deficiencies**, and **1 Low Defect**:
1. **Critical Logic & Conditional Bug (Line 1449)**: Speedup call targets the wrong queue (`1201` instead of `1200`) due to an inverted ternary re-evaluation against `self.active_queues`, causing the newly upgraded building to never receive speedups while falsely reporting successful speedup and incrementing speedup counts.
2. **High Integrity Defect (Line 1102)**: `accelerate_queue_to_completion` returns `True` for empty queues, causing the caller to fabricate speedup completion records and unearned free slots.
3. **Medium 0-Network Violation (Line 758)**: `construct_missing_building` executes a redundant server query (`force_query=True`) rather than in-memory sync.
4. **Medium Null-Safety Risk**: Multiple list iterations over `cityCtrl.blist` assume all items are dictionaries without `isinstance(b, dict)` guards.
5. **Low TypeError Risk (Line 294)**: `format_duration` will raise `TypeError` if passed `None`.

All other loop termination bounds, recursion depth limits (`depth > 8`), visited cycle sets, and collection immutability during iteration were verified as robust.

---

## 1. Observation

### AST Inventory Summary
- **While Loops**: 1 instance (Line 1405).
- **For Loops**: 34 instances across 9 methods.
- **Recursive Functions**: 2 instances (`_traverse` at line 782, `_collect` at line 1308).
- **Try/Except Blocks**: 3 instances (Line 152 in `get_can_build_index`, Line 274 in `load_all_building_configs`, Line 688 in `harvest_building_resource`).

### Detailed Observations

#### Finding 1 (CRITICAL): Queue Mismatch in Speedup Branch (`tasks/building.py:1444-1456`)
```python
1444:     ok_up, up_msg = await self.execute_building_action(cand)
1445:     if ok_up:
1446:         actions_taken.append(up_msg)
1447:         upgraded_in_pass += 1
1448:         free_slots -= 1
1449:         allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
1450: 
1451:         # إذا كان التسريع مفعلاً ولم يستنفد: تسريع الطابور فوراً
1452:         if do_speedup and not speedup_exhausted and self.speedup_count < self.max_speedups_per_run:
1453:             completed, red, r_msg = await self.accelerate_queue_to_completion(allocated_qtype)
```
Inside `execute_building_action` (Lines 991-992 and 1024-1025):
```python
1024:     allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
1025:     self.sync_in_memory_upgrade(allocated_qtype, bid_str, target_lv, idx_to_up, cost_time, cost_res)
```
Inside `sync_in_memory_upgrade` (Line 598):
```python
598:      self.active_queues[qtype_str] = { ... }
```
When `execute_building_action` allocates queue `1200`, `self.active_queues["1200"]` is populated.  
Upon returning to line 1449, the test `"1200" not in self.active_queues` evaluates to `False`.  
Therefore, `allocated_qtype` is assigned `"1201"`.  
At line 1453, `self.accelerate_queue_to_completion("1201")` is called.

#### Finding 2 (HIGH): Ghost Speedup on Empty Queue (`tasks/building.py:1099-1103`)
```python
1099:     queues = await self.refresh_active_queues()
1100:     q_info = queues.get(str(qtype))
1101:     if not q_info:
1102:         return True, 0, "الطابور فارغ بالفعل"
```
Because queue `1201` is empty, `q_info` is `None`. Line 1102 returns `completed = True`.  
At lines 1454-1457:
```python
1454:         if completed:
1455:             self.speedup_count += 1
1456:             free_slots += 1  # تفرغ الطابور مجدداً لمواصلة المتطلب التالي!
1457:             actions_taken.append(f"⚡ تسريع: {cand_name}")
```
The caller registers a false speedup completion (`⚡ تسريع: {cand_name}`) and increments `self.speedup_count`, but **zero** CMD 1003 packets are sent for the actual building on queue `1200`.

#### Finding 3 (MEDIUM): Non-Dict Null-Safety Risk in `cityCtrl.blist`
Lines 418, 427, 564, 636, 706, 789, 842, 895, 1000, 1265, 1348 iterate `blist` using `b.get("binfo", {})` or `item.get("binfo", {}).get("index")`. If an element in `blist` is `None` or a non-dict type, Python raises `AttributeError: 'NoneType' object has no attribute 'get'`.

#### Finding 4 (MEDIUM): Redundant Network Query in `construct_missing_building` (`Line 758`)
```python
758:     await self.refresh_active_queues(force_query=True)
```
Violates GEMINI.md Rules 2 & 6 by executing an unnecessary network round-trip via CMD 1003/1 instead of using `self.sync_in_memory_upgrade()`.

#### Finding 5 (LOW): Format Duration Null-Safety (`Line 294`)
```python
294:     total_sec = int(max(0, seconds))
```
If `seconds` is `None`, raises `TypeError: '>' not supported between instances of 'NoneType' and 'int'`.

---

## 2. Logic Chain

1. **Premise 1**: The building upgrade process starts on queue `1200` when `1200` is unoccupied. `execute_building_action` correctly selects `1200` and adds it to `self.active_queues`.
2. **Premise 2**: Line 1449 executes `allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"`. Because `self.active_queues` already has `"1200"`, `allocated_qtype` becomes `"1201"`.
3. **Premise 3**: `accelerate_queue_to_completion("1201")` checks queue `1201`. Since queue `1201` is idle, line 1102 returns `True, 0, "الطابور فارغ بالفعل"`.
4. **Premise 4**: `run()` checks `if completed:`. Because `completed` is `True`, it logs `⚡ تسريع: {cand_name}`, increments `speedup_count`, and increments `free_slots`.
5. **Deduction 1**: The actual building on queue `1200` is never accelerated.
6. **Deduction 2**: On the subsequent iteration of the while loop, `find_ready_prerequisites` detects that the building on queue `1200` is still in state `"2"` (`is_upgrading = True`). Because it is still upgrading, the leaf node is rejected, no further prerequisite progression occurs, and the loop prematurely halts.
7. **Empirical Proof**: A live test script executing `BuildingTask.run()` with `upgrade_castle: True` and `speedup_castle: True` produced:
   - Upgrade CMD: `('1001', '3', {'bid': '102', 'mode': '0', 'index': '1053'})`
   - Speedup CMD: **NONE** (`query_log` contained 0 calls to CMD 1003).
   - Speedup count: **1** (Falsely recorded).
   - Actions taken: `⚡ تسريع: الأسوار` (Falsely logged).

---

## 3. Caveats

- **No Caveats regarding the critical bug**: The bug is deterministic, 100% reproducible, and affects all execution paths where `speedup_castle` is enabled on an idle queue.
- **While loop bounds**: The while loop itself is safe from infinite loops (`castle_loop_passes < 10` hard cap).
- **Prerequisite recursion**: The recursion in `_traverse` and `_collect` is safe from cycles (`depth > 8` and `visited` sets).
- **Collection mutations**: No in-flight collection mutation bugs were detected in any of the 34 `for` loops.

---

## 4. Conclusion

The work product `tasks/building.py` exhibits high structural quality and robust loop/recursion termination boundaries. However, **Finding 1 and Finding 2 represent critical logic defects** that directly break the core acceleration deliverable (R2) and generate fabricated speedup claims in violation of forensic integrity standards.

Therefore, the verdict is **REQUEST_CHANGES**.

### Required Action Items for Milestone 2 Author:
1. **Fix Line 1449 in `tasks/building.py`**:
   Ensure `allocated_qtype` matches the exact queue used by `execute_building_action`.
   - Option A: Have `execute_building_action` return `(ok, msg, allocated_qtype)`.
   - Option B: Query `self.active_queues` by building ID:
     ```python
     allocated_qtype = next((qt for qt, q in self.active_queues.items() if str(q.get("bid")) == str(cand_bid)), "1200")
     ```
2. **Fix Line 1102 in `tasks/building.py`**:
   Change empty queue return to `False`:
   ```python
   if not q_info:
       return False, 0, "الطابور فارغ بالفعل"
   ```
3. **Fix Line 758 in `tasks/building.py`**:
   Remove `await self.refresh_active_queues(force_query=True)` and replace with in-memory sync `self.sync_in_memory_upgrade(...)`.
4. **Harden Null-Safety**:
   - In `format_duration`: `total_sec = int(max(0, float(seconds or 0)))`.
   - In `blist` iterations: ensure `isinstance(b, dict)` or `isinstance(item, dict)` guards are present.

---

## 5. Verification Method

To independently verify this audit and reproduce the defect:

Run the following reproduction script via terminal:
```powershell
python -c "
import asyncio
from tasks.building import BuildingTask

class MockConn:
    def __init__(self):
        self.is_connected = True
        self.connected = True
        self.init_data = {
            'cityCtrl': {
                'level': 10,
                'blist': [
                    {'binfo': {'bid': '101', 'lv': '10', 'index': '1050', 'state': '0'}},
                    {'binfo': {'bid': '102', 'lv': '9', 'index': '1053', 'state': '0'}}
                ],
                'resList': {'1002': '100000000', '1003': '100000000', '1004': '100000000', '1005': '100000000'},
                'reslist': {'1002': '100000000', '1003': '100000000', '1004': '100000000', '1005': '100000000'}
            },
            'queueCtrl': {},
            'lordInfoCtrl': {'vip': {'level': 0}},
            'backpackCtrl': {'501101': {'count': 50}}
        }
        self.query_log = []

    async def query(self, cmd, sub_cmd, payload, **kwargs):
        self.query_log.append((cmd, sub_cmd, payload))
        return {'err': '0'}

async def test():
    conn = MockConn()
    task = BuildingTask(conn, config={'upgrade_castle': True, 'speedup_castle': True, 'auto_open_chests': False})
    res = await task.run()
    has_speedup_cmd = any(q[0] == '1003' and q[1] == '2' for q in conn.query_log)
    print(f'Speedup count reported: {task.speedup_count}')
    print(f'Was CMD 1003/2 speedup actually sent to server? {has_speedup_cmd}')
    assert has_speedup_cmd, 'CRITICAL BUG: Speedup was claimed but CMD 1003 was NEVER sent!'

asyncio.run(test())
"
```
**Invalidation Condition**: If `has_speedup_cmd` evaluates to `True`, the defect has been resolved. Currently, it evaluates to `False` with `AssertionError`.
