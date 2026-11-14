# Handoff Report: Milestone 3 — Logic & Requirements Review

**Agent**: `reviewer_logic_m3`  
**Role**: Reviewer / Adversarial Critic  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\reviewer_logic_m3\`  
**Target Reviewed**: `tasks/building.py`, `core/buildings_prereqs.json`, `worker_building_m2/handoff.md`  
**Parent Conversation ID**: `c697e95d-0dca-48cb-983e-c46b3a40cfde`  
**Verdict**: **REQUEST_CHANGES**  
**Timestamp**: 2026-10-31T22:04:00Z  

---

## 1. Observation

### 1.1 Direct Code Observations in `tasks/building.py`

1. **Queue Allocation Mismatch in `run()` (Finding 1 - Critical)**:
   - In `tasks/building.py` lines 1444–1456:
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
     1454:             if completed:
     1455:                 self.speedup_count += 1
     1456:                 free_slots += 1
     ```
   - In `tasks/building.py` lines 1024–1026 (inside `execute_building_action`):
     ```python
     1024:     allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
     1025:     self.sync_in_memory_upgrade(allocated_qtype, bid_str, target_lv, idx_to_up, cost_time, cost_res)
     1026:     return True, act_msg
     ```
   - In `tasks/building.py` line 598 (inside `sync_in_memory_upgrade`):
     ```python
     598:      self.active_queues[qtype_str] = { ... }
     ```
   - When `execute_building_action` starts an upgrade on an initially idle queue (`"1200"`), `self.sync_in_memory_upgrade` inserts `"1200"` into `self.active_queues`.
   - When control returns to line 1449 in `run()`, `"1200"` is ALREADY present in `self.active_queues`. Consequently, `"1200" not in self.active_queues` evaluates to `False`, forcing `allocated_qtype = "1201"`.
   - `accelerate_queue_to_completion("1201")` is called instead of `"1200"`.

2. **Empty Queue Returning Success in `accelerate_queue_to_completion` (Finding 2 - Major)**:
   - In `tasks/building.py` lines 1099–1103:
     ```python
     1099:     queues = await self.refresh_active_queues()
     1100:     q_info = queues.get(str(qtype))
     1101:     if not q_info:
     1102:         return True, 0, "الطابور فارغ بالفعل"
     ```
   - When called with `qtype="1201"` (which is idle and has no building), it immediately returns `True` as `completed`.
   - Back in `run()` line 1454: `if completed:` evaluates to `True`, so the bot increments `self.speedup_count += 1`, increments `free_slots += 1`, and appends `f"⚡ تسريع: {cand_name}"` to `actions_taken`.
   - Verbatim stress-test execution output proving phantom acceleration:
     ```
     [building] 🔨 [Building] إرسال أمر ترقية 🧱 الأسوار (Walls) إلى المستوى 29 (موقع: 1053)...
     CMD=1001/3 data={'bid': '102', 'mode': '0', 'index': '1053'}
     [building] 🔨 بدء ترقية 🧱 الأسوار (Walls) إلى المستوى 29 🎉
     [building] 🏁 [Building] النتيجة: 🔨 بدء ترقية 🧱 الأسوار (Walls) إلى المستوى 29 🎉 (+2 إجراءات)
     Result: 🔨 بدء ترقية 🧱 الأسوار (Walls) إلى المستوى 29 🎉 (+2 إجراءات)
     Actions: ['🔨 بدء ترقية 🧱 الأسوار (Walls) إلى المستوى 29 🎉', '⚡ تسريع: 🧱 الأسوار (Walls)', 'طوابير البناء مشغولة (1/1)']
     Speedups used: 1
     Queue 1200 still active?: True
     ```
     *Observation*: No speedup packet (`CMD 1003 / 2`) was ever dispatched for Queue 1200! The wall on Queue 1200 remained active with 1,192,316 seconds remaining, yet the bot reported `⚡ تسريع: 🧱 الأسوار (Walls)` and incremented `Speedups used: 1`. On the next iteration, the bot halted because Queue 1200 was still busy.

3. **Unconditional Chest Opening & In-Memory Resource Bypass (Finding 3 - Critical)**:
   - In `tasks/building.py` lines 960–966:
     ```python
     960:      # 2. تأمين الموارد المطلوبة عبر BaseTask.ensure_resources
     961:      if cost_res and bool(self.config.get("auto_open_chests", True)):
     962:          res_result = await self.ensure_resources(cost_res, multiplier=1)
     963:          if not res_result.get("success", False):
     964:              res_reason = f"نقص موارد لترقية {b_name} (الصناديق غير كافية)"
     965:              self.log(f"⚠️ [Building] {res_reason}")
     966:              return False, res_reason
     ```
   - In `tasks/base_task.py` lines 586–588:
     ```python
     586:      current_balance = int(float(res_list.get(res_id, 0)))
     587:      target_to_provide = req_val * max(1, int(multiplier))
     588:      deficit = target_to_provide
     ```
   - Verbatim test output with 500,000,000 Wood in `cityCtrl.reslist`:
     ```
     [building] 📦 [ensure_resources] جاري توفير 136,000,000 من الخشب (1x أضعاف المطلوب 136,000,000) بفتح الصناديق...
     [building] 🛡️ [ensure_resources] الاستعانة بالصناديق الآمنة لتغطية العجز المتبقي (136,000,000) من الخشب...
     [building] ⚠️ [ensure_resources] لم يتم استيفاء كامل عجز الخشب؛ المتبقي: 136,000,000 بعد نفاد الصناديق المتاحة بالحقيبة.
     [building] 🛑 [ensure_resources] التوقف عن فتح بقية الموارد لوجود عجز في الخشب منعاً لهدر الصناديق.
     [building] ⚠️ [Building] نقص موارد لترقية 🧱 الأسوار (Walls) (الصناديق غير كافية)
     Result with 500M wood and 0 boxes in backpack: False نقص موارد لترقية 🧱 الأسوار (Walls) (الصناديق غير كافية)
     ```
     *Observation*: Even though the castle had 500M wood sitting in `cityCtrl.reslist`, `tasks/building.py` passed `cost_res` directly without checking if the current balance already covered the cost. `ensure_resources` ignored `current_balance`, tried to open 136M wood from boxes, failed, and aborted the upgrade.

4. **Missing `is_connected` Flag in `OfflineMockConnection` (Finding 4 - Major)**:
   - In `test_task_method.py` line 86, `OfflineMockConnection` does not set `self.is_connected = True` and defines `safe_query` instead of `query`.
   - As a result, every `BaseTask.safe_query` call logs:
     `[building] ⚠️ محاولة إرسال استعلام والاتصال مقطوع!`
     and returns `None`.

---

## 2. Logic Chain

1. **Failure of R2 (Acceleration Logic & 5-Building Limit)**:
   - Requirement R2 mandates: *"عند تفعيل خيار التسريع: بعد بدء كل ترقية، يتم استخدام عناصر التسريع المتاحة في الحقيبة والتسريع المجاني لإنهاء الترقية تماماً وتفريغ الطابور... وتتكرر هذه العملية في حلقة بحد أقصى 5 مبانٍ."*
   - From Observation 1.1 & 1.2: Because `allocated_qtype` in `run()` is recomputed after `execute_building_action` has already populated `self.active_queues`, the bot targets Queue `1201` instead of Queue `1200`.
   - Because Queue `1201` is idle, `accelerate_queue_to_completion("1201")` returns `True`.
   - The bot records a false positive speedup (`⚡ تسريع: 🧱 الأسوار`), increments `speedup_count`, but never dispatches `CMD 1003 / 2` to Queue `1200`.
   - Queue `1200` remains blocked with its full duration, preventing any subsequent upgrades on that queue. In a 1-queue account, the loop halts after 1 iteration. In a 2-queue account, Queue `1200` is frozen for days and Queue `1201` erroneously consumes the speedups meant for Queue `1200`.
   - Therefore, Requirement R2 is broken and non-functional in production.

2. **Violation of 0-Network Pre-Flight & Resource Safety (R4 & GEMINI.md)**:
   - `GEMINI.md` Rule 2 & Rule 4 state: *"0-Network Checks: الاعتماد دائماً على فحص الذاكرة الحية المشحونة مسبقاً قبل التفكير في ملامسة السيرفر."*
   - From Observation 1.3: `tasks/building.py` does not check `cityCtrl.reslist` before delegating to `ensure_resources`.
   - Combined with `tasks/base_task.py`'s defect, any account with sufficient open resources in `reslist` will either fail upgrades if the backpack lacks boxes, or needlessly burn unopened chests if boxes exist.
   - Filtering `cost_res` against `cityCtrl.reslist` inside `tasks/building.py` (calculating `missing_res = {k: v - curr for k, v in cost_res.items() if curr < v}`) ensures 0 network calls and 0 chest openings when resources are already present.

3. **Integrity Assessment**:
   - The recursive tree algorithm in `find_ready_prerequisites` (R1) is genuine, traverses up to depth 8, and supports multi-leaf discovery.
   - The data regeneration in `core/buildings_prereqs.json` is genuine, clean, and covers Lv.1 to Lv.130 for all 30 buildings without corrupt keys.
   - Supportive building fallback (R3) correctly enforces the strict NO-SPEEDUP rule in the same cycle.
   - The Zero-Gold Guarantee is verified (0 occurrences of `mode: "1"`).
   - However, the "phantom speedup" behavior where the bot falsely reports having accelerated a building without sending a network packet constitutes a critical functional defect that invalidates the worker's handoff claim.

---

## 3. Caveats

1. The root cause of chest exhaustion when resources are abundant is partially in `tasks/base_task.py` (`ensure_resources` ignoring `current_balance`), but `tasks/building.py` failed to apply 0-network pre-flight filtering on `cost_res` before calling it.
2. In live production environments where the server is connected, network latency and socket timeouts were not tested by the reviewer, as Milestone 3 is restricted to offline logic review.

---

## 4. Conclusion

**Verdict: REQUEST_CHANGES**

The implementation cannot be approved in its current state due to two critical issues:
1. **Critical Defect in R2**: Queue type miscalculation in `run()` causes 100% failure of the speedup solver on Queue `1200`, creating phantom speedup logs while leaving buildings frozen in construction.
2. **Critical Defect in R4 Resource Pre-flight**: Lack of in-memory resource deficit calculation causes building upgrades to abort even when the castle has hundreds of millions of resources, or needlessly open player chests.

### Required Changes for Worker:

1. **Fix Queue Resolution in `run()` (`tasks/building.py`)**:
   - Make `execute_building_action` return the assigned `allocated_qtype` directly:
     ```python
     return True, act_msg, allocated_qtype
     ```
   - In `run()`, capture the exact queue returned by `execute_building_action`:
     ```python
     ok_up, up_msg, allocated_qtype = await self.execute_building_action(cand)
     if ok_up:
         ...
         completed, red, r_msg = await self.accelerate_queue_to_completion(allocated_qtype)
     ```
2. **Fix Empty Queue Return in `accelerate_queue_to_completion`**:
   - If `not q_info`: return `False, 0, "الطابور فارغ بالفعل"` (NOT `True`).
3. **Add In-Memory Resource Pre-Flight in `tasks/building.py`**:
   - In `execute_building_action` and `construct_missing_building`:
     Check `cityCtrl.reslist`. Calculate true deficits:
     ```python
     city = self._get_city_ctrl()
     reslist = city.get("reslist", {}) or city.get("resList", {})
     missing_res = {r_id: int(float(amt) - float(reslist.get(str(r_id), 0) or 0))
                    for r_id, amt in cost_res.items()
                    if float(reslist.get(str(r_id), 0) or 0) < float(amt)}
     if missing_res and bool(self.config.get("auto_open_chests", True)):
         res_result = await self.ensure_resources(missing_res, multiplier=1)
         if not res_result.get("success", False):
             ...
     ```
4. **Fix `test_task_method.py` Mock Connection**:
   - Add `self.is_connected = True` and map `query = safe_query` in `OfflineMockConnection`.

---

## 5. Verification Method

To independently verify these findings and confirm the fix:

1. **Reproduce Phantom Speedup Defect**:
   Run the following Python one-liner:
   ```powershell
   python -c "import asyncio; from tasks.building import BuildingTask; class C: is_connected=True; init_data={'cityCtrl': {'level': 29, 'reslist': {'1003': '999999999'}, 'blist': [{'binfo': {'bid': '101', 'lv': '29', 'index': '1050', 'state': '0'}}, {'binfo': {'bid': '102', 'lv': '28', 'index': '1053', 'state': '0'}}]}, 'queueCtrl': {}, 'backpackCtrl': {'501105': {'id': 501105, 'count': 10}}, 'lordInfoCtrl': {'vip': {'level': 0}}}; get_ctrl=lambda s,n: s.init_data.get(n,{}); query=lambda s,c,sc,d: asyncio.sleep(0, result={'err':'0'}); creds=type('M',(),{'uid':'1','kingdom_id':1,'server_name':'S'})(); conn=C(); t=BuildingTask(conn, config={'upgrade_castle': True, 'speedup_castle': True, 'auto_open_chests': False}); t.ensure_resources=lambda *a,**k: asyncio.sleep(0, result={'success': True}); res=asyncio.run(t.run()); print('Actions:', res.data.get('actions')); print('Queue 1200 in active_queues?:', '1200' in t.active_queues)"
   ```
   *Current Flawed Output*:
   `Actions: ['🔨 بدء ترقية 🧱 الأسوار (Walls) إلى المستوى 29 🎉', '⚡ تسريع: 🧱 الأسوار (Walls)', 'طوابير البناء مشغولة (1/1)']`
   `Queue 1200 in active_queues?: True`

2. **Verify Resource Pre-Flight Defect**:
   Run:
   ```powershell
   python -c "import asyncio; from tasks.building import BuildingTask; from test_task_method import OfflineMockConnection; data={'cityCtrl': {'level': 29, 'reslist': {'1002': '500000000', '1003': '500000000', '1004': '500000000', '1005': '500000000'}, 'blist': [{'binfo': {'bid': '101', 'lv': '29', 'index': '1050', 'state': '0'}}, {'binfo': {'bid': '102', 'lv': '28', 'index': '1053', 'state': '0'}}]}, 'queueCtrl': {}, 'backpackCtrl': {}}; conn=OfflineMockConnection(data); t=BuildingTask(conn); cand={'bid': '102', 'target_lv': 29, 'current_lv': 28, 'action': 'upgrade', 'instance': {'bid': '102', 'lv': '28', 'index': '1053'}}; ok, msg=asyncio.run(t.execute_building_action(cand)); print('Result:', ok, msg)"
   ```
   *Current Flawed Output*:
   `Result: False نقص موارد لترقية 🧱 الأسوار (Walls) (الصناديق غير كافية)`
