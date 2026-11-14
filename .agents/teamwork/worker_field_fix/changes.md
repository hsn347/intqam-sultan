# Changes Report: Command Hall Gateway Error 8002 & Response Validation Fix

**Agent**: `teamwork_worker` (`implementer`, `qa`)  
**Target File**: `tasks/command_hall.py`  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\worker_field_fix\`  
**Date**: 2026-11-01  

---

## 1. Summary of Changes

Live field testing on actual game gateways identified two defects in `tasks/command_hall.py`:
1. **Missing Coordinate Translation**: Raw server coordinates `(server_x, server_y)` were sent directly to `CMD 1007 / SUBCMD 2`. In the Revenge of Sultans client engine (`mapSyncUtilClient.lua:serverTOClientPos`), march placement requires client tile coordinates where `tile = server - 1`. The server adds `+1, +1` upon receipt. Sending raw server coordinates caused the server to target `(server + 1)`, finding no NPC and returning gateway error `8002` (`Err_MAP_QUEUE_POS_CHANGE`).
2. **Silent Error Suppression**: The response check `if res is not None:` evaluated to `True` even when the gateway returned error dictionaries like `{"cmd": "1007", "subcmd": "2", "err": "8002", "_ok": true}`. The bot mistakenly assumed march success, incremented `dispatched`, consumed troops in memory, and looped until timeout with 0 rewards.

Both defects have been completely resolved.

---

## 2. File-by-File Detailed Changes

### File 1: `tasks/command_hall.py`

#### A. Coordinate Translation (Lines 979-980)
**Before:**
```python
            coords = self._get_target_coordinates(task)
            if not coords:
                self.log(f"[CommandHall] ⚠️ لم يتم العثور على إحداثيات هدف المهمة {task_index} على الخريطة.")
                continue

            target_x, target_y = coords
```
**After:**
```python
            coords = self._get_target_coordinates(task)
            if not coords:
                self.log(f"[CommandHall] ⚠️ لم يتم العثور على إحداثيات هدف المهمة {task_index} على الخريطة.")
                continue

            server_x, server_y = coords
            target_x, target_y = max(0, server_x - 1), max(0, server_y - 1)
```

#### B. Gateway Response Validation (Lines 1045-1056)
**Before:**
```python
            res = await self.safe_query(
                CMD_KINGDOM_QUEUE_MODULE,
                REQ_ADD_KINGDOM_QUEUE,
                march_payload,
                min_delay=0.6,
                max_delay=1.0,
            )
            if res is not None:
                dispatched += 1
                task["statue"] = TASK_STATUE_PREPARE
                # مزامنة واستهلاك الموارد في الذاكرة الحية لمنع التكرار
                self._deduct_march_resources_in_memory(selected_troops, stamina_cost=5)
                self._update_hall_data_from_response(hall_data, res)
                self.log(f"[CommandHall] ✓ تم إرسال الفيلق بنجاح إلى ({target_x}, {target_y}).")
            else:
                self.log(f"[CommandHall] ⚠️ تعذر إرسال الفيلق للمهمة {task_index}.")
```
**After:**
```python
            res = await self.safe_query(
                CMD_KINGDOM_QUEUE_MODULE,
                REQ_ADD_KINGDOM_QUEUE,
                march_payload,
                min_delay=0.6,
                max_delay=1.0,
            )
            is_success = (
                isinstance(res, dict)
                and str(res.get("err", "0")) in ("0", "", "None")
                and (res.get("queueId") or not res.get("err") or str(res.get("err")) == "0")
            )
            if is_success:
                dispatched += 1
                task["statue"] = TASK_STATUE_PREPARE
                # مزامنة واستهلاك الموارد في الذاكرة الحية لمنع التكرار
                self._deduct_march_resources_in_memory(selected_troops, stamina_cost=5)
                self._update_hall_data_from_response(hall_data, res)
                self.log(f"[CommandHall] ✓ تم إرسال الفيلق بنجاح إلى ({target_x}, {target_y}).")
            else:
                err_code = res.get("err") if isinstance(res, dict) else "لا توجد استجابة"
                self.log(f"[CommandHall] ⚠️ تعذر إرسال الفيلق للمهمة {task_index} (رمز الخطأ: {err_code}).")
```

---

### File 2: `tools/test_command_hall_task.py`
- Updated `test_04_march_dispatch_when_troops_available` to assert tile coordinates `{"x": 599, "y": 699}` for server coordinates `(600, 700)`.
- Updated `test_10_march_nested_packet_structure` to assert `inner_data["to"]` coordinates `(119, 339)` for server coordinates `(120, 340)`.
- Added `test_13_coordinate_translation_and_gateway_error_rejection`:
  - Verifies translation `(397, 423)` -> `(396, 422)`.
  - Injects gateway error `8002` and asserts `dispatched == 0`, zero troop deductions in memory, zero stamina deductions, and status remains `TASK_STATUE_BEGIN`.
  - Injects gateway success with `queueId` and `err=None` and asserts `dispatched == 1`, status transitions to `TASK_STATUE_PREPARE`, and stamina is deducted.

---

### File 3: `tools/test_challenger_command_hall.py`
- Updated `test_02_task_type_mix_comprehensive` to assert tile coordinates:
  - Task 2: `{"x": 99, "y": 199}` for server coords `(100, 200)`.
  - Task 5: `{"x": 299, "y": 399}` for server coords `(300, 400)`.

---

## 3. Verification Commands & Results

1. `python tools/test_empirical_lifecycle.py`
   - Result: **11/11 PASSED** (0.073s)
2. `python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py tools/test_adversarial_lifecycle.py`
   - Result: **50/50 PASSED** (35.899s)
3. `python tools/test_adversarial_retest_r2.py`
   - Result: **5/5 PASSED** (0.035s)
4. `python tools/test_zero_troop_bypass.py`
   - Result: **PASSED in 1.77s** (< 5s requirement) with exit reason `"تعذر إرسال فيلق على الخريطة (تم إتمام باقي المهام والخروج بأمان)"`
5. `python tools/audit_forensic_integrity.py`
   - Result: **🏆 VERDICT: CLEAN** (0 violations across all 6 pipeline stages)
