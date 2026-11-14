# Empirical Challenge Report: Command Hall Backend Task Verification

**Agent**: Empirical Challenger (`teamwork_challenger`)  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\challenger_empirical_1\`  
**Timestamp**: 2026-11-01T09:36:00Z  
**Verdict**: **`REQUEST_CHANGES`**  
**Risk Level**: **HIGH**

---

## 1. Observation

1. **Baseline Test Execution**:
   - Executed `python tools/test_command_hall_task.py`.
   - Tool result: `Ran 6 tests in 6.169s ... OK`.
   - Baseline checks passed for toggle, initial pre-flight memory caching, registration, and SQLite migration.

2. **Adversarial Test Suite Execution**:
   - Created and executed `python tools/test_challenger_command_hall.py` (9 empirical stress test cases).
   - Tool result:
     ```
     Ran 9 tests in 12.444s
     FAILED (failures=2)
     ```
   - Passed Tests:
     * `test_01_live_memory_missing_caching`: Asserted exactly 1 network query to CMD 2274 SubCMD 1 when missing; subsequent calls resulted in 0 queries (100% in-memory cache hit).
     * `test_02_task_type_mix_comprehensive`: Confirmed Types 3, 4, 6 executed via SubCMD 5; Types 2, 5 dispatched via Kingdom Queue; Type 1 skipped from instant finish/march; finished tasks claimed via SubCMD 8.
     * `test_03_march_blocked_when_zero_queues`: Confirmed when `available_marches == 0`, zero-army instant tasks completed, finished tasks claimed, and loop exited gracefully without hang.
     * `test_04_march_blocked_when_zero_troops`: Confirmed when `totalArmy == 0`, zero-army instant tasks completed, finished tasks claimed, and loop exited gracefully without hang.
     * `test_06_stamina_exhaustion_boundaries`: Confirmed at stamina = 0 and stamina = 4, tasks requiring 5 stamina were skipped, free tasks executed, march blocked safely, and 0 gold spent.
     * `test_07_loop_max_duration_bound`: Confirmed loop breaks cleanly at 300s when continuous tasks are pending (`LOOP_MAX_DURATION_SECONDS = 300`).

3. **Empirical Failure 1 — Gold / Speedup Trap Loophole (`test_05` & `test_09`)**:
   - In `tasks/command_hall.py:285-288` (`_execute_instant_tasks`):
     ```python
     consume_gold = int(task.get("consumeGold", 0) or task.get("gold", 0) or 0)
     if consume_gold > 0 or task.get("consumeSpeedup") or task.get("speedup"):
         self.log(f"[CommandHall] ⏭️ تخطي المهمة {task_index} لأنها تتطلب ذهباً أو تسريعات (سياسة 0-Gold/Speedup).")
         continue
     ```
   - In `tasks/command_hall.py:339-342` (`_handle_march_tasks`):
     ```python
     consume_gold = int(task.get("consumeGold", 0) or task.get("gold", 0) or 0)
     if consume_gold > 0 or task.get("consumeSpeedup") or task.get("speedup"):
         self.log(f"[CommandHall] ⏭️ تخطي مهمة الفيلق {task_index} لأنها تتطلب ذهباً أو تسريعات.")
         continue
     ```
   - In `test_05_gold_and_speedup_traps`, injected task:
     `{"index": 6, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0, "consumeItem": "speedup"}`
     * Verbatim test log:
       ```
       [DEBUG test_05] executed count=2, executed_indices=[6, 7]
       [DEBUG test_05] consumeItem: speedup rejected? False
       AssertionError: False is not true : Adversarial trap `consumeItem: speedup` must be rejected!
       ```
   - In `test_09_march_consume_item_trap`, injected march task:
     `{"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 100, "y": 200, "consumeItem": "speedup"}`
     * Verbatim test log:
       ```
       [command_hall] [CommandHall] ⚔️ جاري إرسال فيلق إلى (100, 200) للمهمة: طليعة جيش المتمردين...
       [command_hall] [CommandHall] ✓ تم إرسال الفيلق بنجاح إلى (100, 200).
       [DEBUG test_09] dispatched=1, blocked=False
       AssertionError: 1 != 0 : March task with consumeItem: 'speedup' must NOT be dispatched!
       ```
   - Finding: The code only checks `task.get("consumeSpeedup")` and `task.get("speedup")`. It completely ignores `consumeItem`, `item`, `consumeItems`, and does not check if `consumeItem` references speedup or gold items.

4. **Empirical Failure 2 — Unsafe `int()` Cast Causing Uncaught `ValueError` (`test_08`)**:
   - In `tasks/command_hall.py:285, 291, 339`:
     ```python
     consume_gold = int(task.get("consumeGold", 0) or task.get("gold", 0) or 0)
     stamina_cost = int(task.get("consume", 0) or 0)
     ```
   - In `test_08_corrupted_numeric_values`, when injected with `{"consumeGold": "invalid_gold"}`:
     * Verbatim log:
       ```
       [DEBUG test_08] Caught ValueError as expected from unhandled int() conversion: invalid literal for int() with base 10: 'invalid_gold'
       ```
   - Finding: Non-numeric strings in payload fields raise `ValueError`. Because this is not caught inside the loop, it causes the entire task to abort via the outer `except Exception`.

5. **Empirical Behavioral Finding 3 — 30-Second Early Loop Exit vs 5-Minute Continuous Loop**:
   - In `tasks/command_hall.py:456-461`:
     ```python
     elapsed = int(time.time() - start_time)
     if not pending_tasks and elapsed >= 30:
         # تم إنجاز كافة المهام المتاحة ولم يتبق أي مهام معلقة
         self.log("[CommandHall] ✓ تم إنجاز كافة مهام قاعة القيادة المتاحة واستلام جوائزها بنجاح.")
         exit_reason = "تم إنجاز كافة المهام المتاحة بالكامل"
         break
     ```
   - Finding: If march tasks were dispatched to the world map (which take 30-60+ seconds to reach NPC and complete), or if tasks are in prepare state, `pending_tasks` is `False`. The task terminates after 30 seconds rather than continuing for up to 5 minutes as required by `ORIGINAL_REQUEST.md` R1: *"تواصل المهمة العمل لمدة 5 دقائق متواصلة في كل دورة، وتتوقف وتخرج بعد إتمام باقي المهام الفرعية إذا اصطدمت بمتطلب إرسال فيلق على الخريطة ولم تكن هناك فيالق متاحة."*

---

## 2. Logic Chain

1. **From Observation 3**:
   The authoritative user specification (`ORIGINAL_REQUEST.md` R2) and dispatch instructions mandate:
   *"تخطي أي مهمة فرعية تتطلب صرف الذهب أو التسريعات، وتنفيذ المهام المجانية والآمنة فقط"* and *"Gold / speedup trap: inject fake tasks with consumeGold: 100 or consumeItem: speedup — verify the task rejects them 100%."*
   Lines 286 and 340 only test `task.get("consumeSpeedup") or task.get("speedup")`. When a subtask specifies `{"consumeItem": "speedup"}` (or any item payload containing speedups), the condition evaluates to `False`, allowing the task to execute and spend items/speedups. This directly violates the 0-gold / 0-speedup constraint.

2. **From Observation 4**:
   Payloads received from socket/HTTP game streams can occasionally contain malformed strings, nulls, or unexpected data types. Direct unconditional `int()` conversion on untrusted dictionary values without sanitization (`str(val).isdigit()` or `try...except ValueError`) produces an unhandled exception that crashes the task.

3. **From Observation 5**:
   World map march missions (Types 2 & 5) take significant transit time (typically 30-90 seconds). If `CommandHallTask` exits at `elapsed >= 30` whenever `pending_tasks` is temporarily false, it prematurely exits before the troops finish their battle, preventing the task from claiming the reward during the same 5-minute cycle.

---

## 3. Caveats

- Live game WebSocket session connection with real server packets was not connected during this offline unit stress test; tests were executed using `ChallengerMockConnection` and direct SQLite inspections.
- No other caveats.

---

## 4. Conclusion & Required Actions

**Verdict**: **`REQUEST_CHANGES`**

The implementation is well-structured and passed 7 out of 9 stress tests, but contains two confirmed vulnerabilities and one timing defect that must be resolved:

### Required Changes for Backend Worker:
1. **Fix Gold / Speedup Filtering (Lines 285-288 and Lines 339-342 in `tasks/command_hall.py`)**:
   Add comprehensive check for `consumeItem`, `consumeItems`, `item`, `items`, and check whether the item value or string contains `"speedup"` or `"gold"`, or if any non-zero item/gold is consumed. For example:
   ```python
   def _is_costly_task(task: Dict[str, Any]) -> bool:
       # Safe integer parsing
       def safe_int(v: Any) -> int:
           try:
               return int(v) if v is not None else 0
           except (ValueError, TypeError):
               return 0

       if safe_int(task.get("consumeGold")) > 0 or safe_int(task.get("gold")) > 0:
           return True
       if task.get("consumeSpeedup") or task.get("speedup"):
           return True
       # Check consumeItem / item traps
       item_val = task.get("consumeItem") or task.get("consumeItems") or task.get("item") or task.get("items")
       if item_val:
           if isinstance(item_val, str) and ("speedup" in item_val.lower() or "gold" in item_val.lower()):
               return True
           if isinstance(item_val, (int, float)) and item_val > 0:
               return True
           if isinstance(item_val, (list, dict)) and len(item_val) > 0:
               return True
       return False
   ```
   Apply this helper in both `_execute_instant_tasks()` and `_handle_march_tasks()`.

2. **Safe Integer Parsing (Lines 291 & throughout numeric extractions)**:
   Ensure all `int()` conversions on task fields use safe conversion or default to 0 on `ValueError`.

3. **5-Minute Loop Persistence with Active Marches**:
   Adjust the early exit condition in line 457 so that it does NOT exit at 30 seconds if any marches have been dispatched (`total_marches > 0`) or if the 5-minute window has not elapsed, unless blocked on march queues.

---

## 5. Verification Method

To verify the fixes independently:

1. **Run the Empirical Challenger Stress Suite**:
   ```bash
   python tools/test_challenger_command_hall.py
   ```
   *Pass Condition*: `Ran 9 tests ... OK` (All 9 tests pass, 0 failures, 0 errors).

2. **Run the Baseline Suite**:
   ```bash
   python tools/test_command_hall_task.py
   ```
   *Pass Condition*: `Ran 6 tests ... OK`.
