# Technical Handoff Report: Building Task Refactoring Architecture & Survey

**Agent Folder**: `e:\intqam-sultan\.agents\teamwork\explorer_building_survey_3\`  
**Date**: 2026-11-01T00:18:00Z  
**Target File**: `tasks/building.py`  
**Parent Conversation ID**: `c697e95d-0dca-48cb-983e-c46b3a40cfde`

---

## 1. Observation

### 1.1 Live Memory VIP Path Defect
- **File**: `tasks/building.py`, lines 442–448:
  ```python
  # 1. فحص الـ VIP
  vip_ctrl = self.get_ctrl("vipCtrl")
  vip_lv = int(vip_ctrl.get("vipLv", 0) or 0) if isinstance(vip_ctrl, dict) else 0
  if vip_lv >= 2:
      self.max_build_slots = 2
      return 2
  ```
- **Direct Live Memory Verification**:
  Inspecting `docs/beetoo1_live_memory.json`, `docs/beetoo3_live_memory.json`, and `docs/lucifer_live_memory.json`:
  Command: `python -c "import json; d = json.load(open('docs/beetoo1_live_memory.json', encoding='utf-8')); print([(k, v) for k, v in d.get('lordInfoCtrl', {}).items() if 'vip' in k.lower()])"`
  Output:
  `[('vip', {'vipPoint': 514255, 'loginDay': 4, 'vipEndTime': 0, 'level': 10, 'getVipDailyGiftTime': 1710328710}), ('vipDailyGift', {'vipDailyGiftBeGot': False})]`
  `vipCtrl` does NOT exist in live memory (`self.get_ctrl("vipCtrl")` returns `{}`).
  Consequently, `vip_lv` always evaluates to `0`. All accounts (including `beetoo1` at VIP 10, `beetoo3` at VIP 9, and `LUCIFER` at VIP 11) were falsely capped at 1 build slot instead of 2 build slots!

### 1.2 Zero-Network Violation on Idle Queues
- **File**: `tasks/building.py`, lines 393–405:
  ```python
  if rem > 0 and bid:
      active[qtype] = { ... }
  if active:
      self.active_queues = active
      return active

  # استعلام رسمي من السيرفر عند اللزوم (CMD 1003 / SubCMD 1)
  resp = await self.safe_query("1003", "1", {}, min_delay=0.6, max_delay=1.2)
  ```
- **Observation**:
  When all building queues are idle (free), `active` is empty `{}`. The check `if active:` evaluates to `False`, causing execution to fall through to `self.safe_query("1003", "1", {})`! This causes redundant network calls every single time queues are free, violating GEMINI.md Rule 2 and Rule 4 (0-Network Pre-flight).
  In live test output:
  `python test_task_method.py --offline -m docs/beetoo1_live_memory.json --task building run`
  Emits:
  `[building] ⚠️ محاولة إرسال استعلام والاتصال مقطوع!`
  `[building] 🏰 [Building] القلعة: Lv.40 | 🧱 الأسوار: Lv.34 | 📊 طوابير البناء: 0/1 (متاح: 1)`

### 1.3 Prerequisite Cascade Flaw & 2nd Queue Abandonment
- **File**: `tasks/building.py`, lines 619–628 and 1087–1164:
  `resolve_and_upgrade_chain()` evaluates prerequisites recursively. Once it launches ONE prerequisite (e.g. Wall Lv 14 -> Iron Mine Lv 14), Iron Mine starts upgrading (`state="2"`).
  On the second iteration of `run()`, when evaluating Castle Lv 16:
  `resolve_and_upgrade_chain()` visits Wall 15 -> Iron Mine 14.
  Iron Mine is now upgrading, returning `{"ready": False, "reason": "المبنى قيد الترقية بالفعل"}`.
  Wall receives `ready: False` and immediately stops: `all_pre_satisfied = False`, returning `ready: False`.
  Castle receives `ready: False`, `made_progress` evaluates to `False`, and the loop `break`s!
  The 2nd free building queue is completely abandoned, and execution immediately falls through to supportive buildings or exits, even though Castle has other unsatisfied prerequisites (e.g., Embassy 15) that could occupy Queue 2.

### 1.4 Speedup Logic Deficiencies & Network Chatting
- **File**: `tasks/building.py`, lines 848–981:
  - Loop counts individual speedup item reductions instead of completed buildings:
    `if red > 0: self.speedup_count += 1`
    Line 857: `self.max_speedups_per_run = 5`
    If a building takes 3 speedup packets, `speedup_count` hits 3 on a single building. Requirement R2 explicitly states:
    "الحد الأقصى للتسريع في الدورة الواحدة هو إنهاء ترقية حتى 5 مبانٍ بالتسريع في الدورة الواحدة." (Up to 5 buildings completed via speedup).
  - Iterates over `SPEEDUP_ITEMS` sending separate CMD 1003/2 requests per item type:
    Lines 916–921:
    `resp_tool = await self.safe_query("1003", "2", {"qtype": str(qtype), "mode": "2", "items": [{"id": int(s_id), "count": int(use_cnt)}], "decreaseTime": "0"})`
  - In official client code (`game_file/src/app/module/queue/queueCtrl.lua`, lines 27–33 and `commonSpeedUpBestViewPanel.lua`, line 193):
    `queueCtrl:speedUpQueueReq(qtype, mode, items, ...)` accepts a list of items `[{"id": id1, "count": c1}, {"id": id2, "count": c2}]` all in a SINGLE request.
  - In `tasks/building.py`, if speedup items in the backpack are insufficient to finish 100%, it partially reduces time, leaves the building, and in subsequent checks treats the building as still active with no structured fallback, causing extra queries or repeated speedup attempts.

### 1.5 Missing Prerequisites in `core/buildings_prereqs.json`
- **Inspection**:
  Command: `python -c "import json; data = json.load(open('core/buildings_prereqs.json', encoding='utf-8')); print({k: max(int(lv) for lv in v.keys()) for k, v in data.items()})"`
  Output:
  `'101': 47, '102': 34, '103': 28, '104': 30, '105': 31, '111': 450000, '201': 32, ...`
  `102` (Walls) stops at 34 in `buildings_prereqs.json`.
  `111` (Embassy) normal levels stop at 28.
  Game files in `game_file/src/app/localtb/config_server/` (`build101.lua`, `build102.lua`, `build111.lua`, `buildstar101.lua`, `buildstar102.lua`) contain levels up to 130 and star levels.

---

## 2. Logic Chain

```
[Observation 1.1: lordInfoCtrl.vip.level >= 2]
    │
    ▼
[Deduction 1: VIP 2+ grants permanent 2nd queue (1201)]
    │
    ├─► Fix get_max_build_slots() to read lordInfoCtrl.vip.level.
    │
[Observation 1.2: queueCtrl present in init_data]
    │
    ▼
[Deduction 2: Absence of 1200/1201 in queueCtrl means queues are IDLE]
    │
    ├─► Return {} immediately without sending CMD 1003/1 (0-Network Pre-flight).
    │
[Observation 1.3: Recursive tree traversal stops on first upgrading child]
    │
    ▼
[Deduction 3: Tree traversal must collect ALL independent unsatisfied branches bottom-up]
    │
    ├─► Post-order dependency analysis: identify ready leaf nodes.
    ├─► Support 1 or 2 available queues: assign ready leaves across queues simultaneously.
    │
[Observation 1.4: Speedup limit is 5 buildings, official client batches items]
    │
    ▼
[Deduction 4: Complete speedup solver & building completion tracker]
    │
    ├─► Entry acceleration: accelerate active queues up to 5 completed buildings.
    ├─► Greedy solver: Building speedups (5011xx) -> General speedups (5006xx).
    ├─► Batch items in single CMD 1003/2 request + Free speedup (mode 0).
    ├─► If backpack insufficient for 100%: use available items, apply free speedup,
    │   leave building running naturally, set speedup_exhausted = True, exit acceleration loop.
    │
[Requirement R3: Supportive buildings fallback]
    │
    ▼
[Deduction 5: If Castle loop ends and free_slots > 0 and supportive enabled]
    ├─► Pick lowest-level eligible supportive building.
    └─► STRICT BAN: NO speedup for supportive buildings in the same cycle!
```

---

## 3. Caveats

1. **Building Star Levels (Lv 31+ / Star 1–5)**:
   In Clash of Sultans, levels beyond 30 introduce Star Levels (`starLv` / `buildstar*.lua`) requiring Glory / Crystal or specific badges. The prerequisite parser and upgrade handler must cleanly distinguish normal levels (`lv`) from star levels (`starLv`), and respect `costTools`/`costWEs` in `buildings_prereqs.json`.
2. **War Medals (301101)**:
   When Castle requires War Medals and the bag does not have enough, Castle is blocked (`BLOCKED_BY_ITEMS`). The algorithm must treat this as a signal to fall back to supportive buildings to prevent queue starvation.
3. **Internal Activity Locks**:
   Buildings hosting active queues (e.g., Academy `1212` research, Barracks `1203`-`1206` training, Hospital `1202` healing) return error 1005 (`Err_BUILDSTATE_NOT_NORMAL`) if an upgrade command is sent. Pre-flight must verify internal queue freedom from `queueCtrl` before issuing upgrade commands.

---

## 4. Conclusion & Proposed Architecture

### 4.1 Architecture Overview

The refactored `BuildingTask` in `tasks/building.py` should be structured into four distinct modules:

```
BuildingTask
 ├── 1. Memory & State Manager (0-Network)
 │    ├── get_active_building_queues()  [reads queueCtrl & cityCtrl.queue, 0 network if present]
 │    ├── calculate_max_build_slots()   [reads lordInfoCtrl.vip.level >= 2]
 │    └── sync_in_memory_upgrade()     [immediately updates cityCtrl.blist & queueCtrl on success]
 │
 ├── 2. Recursive Prerequisite Tree Engine (R1)
 │    ├── get_building_node(bid)        [current lv, state, busy status]
 │    ├── collect_unsatisfied_prereqs() [post-order traversal, finds deepest ready leaves]
 │    └── allocate_queues()             [allocates 1 or 2 queues to independent ready leaves]
 │
 ├── 3. Acceleration & Speedup Engine (R2)
 │    ├── accelerate_queue_to_completion() [free speedup -> greedy backpack solver -> free speedup]
 │    ├── accelerate_active_queues_on_entry() [accelerates existing queues upon task entry]
 │    └── speedup_counter               [tracks completed buildings, hard limit = 5]
 │
 └── 4. Main Control Cycle & Supportive Fallback (R3 & R4)
      ├── Castle Loop                   [while accelerated < 5 and free_slots > 0]
      ├── Supportive Buildings Loop     [fallback if free_slots > 0; STRICT NO-SPEEDUP]
      └── Loop Termination Guards       [max iterations, timeout guards, zero-network exit]
```

---

### 4.2 Detailed Algorithmic Specifications

#### A. 0-Network Pre-Flight & VIP 2-Queue Detection
```python
def calculate_max_build_slots(self) -> int:
    # 1. Inspect lordInfoCtrl.vip.level (Official Game Client live memory structure)
    lord_info = self.get_ctrl("lordInfoCtrl") or {}
    vip_dict = lord_info.get("vip", {}) if isinstance(lord_info, dict) else {}
    vip_lv = int(vip_dict.get("level", 0) or 0)
    if vip_lv >= 2:
        self.max_build_slots = 2
        return 2

    # 2. Check rented queue 1201 in cityCtrl.queue
    city = self._get_city_ctrl()
    q_dict = city.get("queue", {}) if isinstance(city, dict) else {}
    if isinstance(q_dict, dict) and "1201" in q_dict:
        q1201 = q_dict["1201"]
        if isinstance(q1201, dict):
            st = float(q1201.get("starttime", 0) or 0)
            tt = float(q1201.get("totaltime", 0) or 0)
            if (st + tt) > time.time():
                self.max_build_slots = 2
                return 2

    # 3. Check if queue 1201 is currently active in queueCtrl
    qctrl = self.get_ctrl("queueCtrl")
    if isinstance(qctrl, dict) and "1201" in qctrl:
        self.max_build_slots = 2
        return 2

    self.max_build_slots = 1
    return 1
```

```python
async def refresh_active_queues(self, force_query: bool = False) -> Dict[str, Dict[str, Any]]:
    active: Dict[str, Dict[str, Any]] = {}
    q_source = self.get_ctrl("queueCtrl")
    if not isinstance(q_source, dict) or not q_source:
        city = self._get_city_ctrl()
        q_source = city.get("queue", {})

    now_ts = time.time()
    if not force_query and isinstance(q_source, dict):
        for qtype in ["1200", "1201"]:
            q_info = q_source.get(qtype)
            if isinstance(q_info, dict):
                st = float(q_info.get("starttime", 0) or 0)
                tt = float(q_info.get("totaltime", 0) or 0)
                rem = max(0.0, (st + tt) - now_ts) if st > 0 else float(q_info.get("ottime", 0) or tt)
                inner = q_info.get("data", {}) if isinstance(q_info.get("data"), dict) else q_info
                bid = str(inner.get("bid", "") or q_info.get("bid", ""))
                lv = int(inner.get("lv", 0) or q_info.get("lv", 0) or 0)
                if rem > 0 and bid:
                    active[qtype] = {
                        "qtype": qtype,
                        "bid": bid,
                        "lv": lv,
                        "remain_time": rem,
                        "raw": q_info,
                    }
                else:
                    # Clean up expired queue from live memory
                    q_source.pop(str(qtype), None)

        # ZERO-NETWORK RETURN: When queueCtrl is present, return active immediately even if empty!
        self.active_queues = active
        return active

    # Only query server if force_query=True or memory completely missing
    resp = await self.safe_query("1003", "1", {}, min_delay=0.6, max_delay=1.2)
    # Parse server response and return
    ...
```

---

#### B. Recursive Prerequisite Tree Traversal (Handling 1 or 2 Queues)

```python
def find_ready_prerequisites(self, target_bid: str, target_blv: int) -> List[Dict[str, Any]]:
    """
    Bottom-up post-order traversal of the prerequisite tree.
    Returns candidate buildings that are ready to be upgraded to their next level
    (all their own prerequisites are satisfied, and they are not currently upgrading).
    """
    ready_candidates: List[Dict[str, Any]] = []
    visited: Set[Tuple[str, int]] = set()

    def _traverse(bid: str, req_lv: int, depth: int):
        if depth > 8 or (bid, req_lv) in visited:
            return
        visited.add((bid, req_lv))

        bid_str = str(bid)
        blist = self._get_city_buildings()
        instances = [b.get("binfo", {}) for b in blist if str(b.get("binfo", {}).get("bid", "")) == bid_str]
        
        # 1. Missing building (Lv 0) -> highest priority leaf
        if not instances:
            ready_candidates.append({
                "bid": bid_str,
                "target_lv": req_lv,
                "current_lv": 0,
                "action": "construct",
                "depth": depth,
            })
            return

        curr_max_lv = max(int(b.get("lv", 0) or 0) for b in instances)
        if curr_max_lv >= req_lv:
            return  # Already satisfied

        # Check if already upgrading
        is_upgrading = any(str(b.get("state", "0")) == "2" for b in instances) or any(
            str(q.get("bid")) == bid_str for q in self.active_queues.values()
        )
        if is_upgrading:
            # Branch is actively advancing; cannot upgrade further right now
            return

        # Check internal activity lock (training, research, healing)
        is_busy, busy_desc = self.is_building_busy_with_activity(bid_str)
        if is_busy:
            return

        # Check prerequisites for next level (curr_max_lv + 1)
        next_lv = curr_max_lv + 1
        cfg = get_building_level_config(bid_str, next_lv)
        pre_cond = cfg.get("preCond", {})
        if bid_str == "101" and not pre_cond:
            pre_cond = {"102": curr_max_lv}
            if next_lv >= 41:
                pre_cond["301"] = curr_max_lv

        all_children_satisfied = True
        for p_bid, p_lv in pre_cond.items():
            p_bid_str = str(p_bid)
            if p_bid_str == "101":
                # For castle as a requirement of a sub-building: compare directly
                c_lv = int(self._get_castle_level())
                if c_lv < int(p_lv):
                    all_children_satisfied = False
                continue

            p_instances = [b.get("binfo", {}) for b in blist if str(b.get("binfo", {}).get("bid", "")) == p_bid_str]
            p_curr = max((int(b.get("lv", 0) or 0) for b in p_instances), default=0)
            if p_curr < int(p_lv):
                all_children_satisfied = False
                _traverse(p_bid_str, int(p_lv), depth + 1)

        # If all children are satisfied, this building is a leaf ready for upgrade!
        if all_children_satisfied:
            best_instance = max(instances, key=lambda x: int(x.get("lv", 0) or 0))
            ready_candidates.append({
                "bid": bid_str,
                "target_lv": next_lv,
                "current_lv": curr_max_lv,
                "action": "upgrade",
                "instance": best_instance,
                "depth": depth,
            })

    _traverse(target_bid, target_blv, 0)
    # Sort candidates: deepest first (highest depth), distinct bids
    unique_candidates = []
    seen_bids = set()
    for cand in sorted(ready_candidates, key=lambda x: x["depth"], reverse=True):
        if cand["bid"] not in seen_bids:
            seen_bids.add(cand["bid"])
            unique_candidates.append(cand)

    return unique_candidates
```

---

#### C. Acceleration Solver & 5-Building Cycle Limit

```python
async def accelerate_queue_to_completion(self, qtype: str) -> Tuple[bool, int, str]:
    """
    Accelerates a building queue until 100% completion or exhausts available speedups.
    Returns: (completed: bool, seconds_reduced: int, reason: str)
    """
    queues = await self.refresh_active_queues()
    q_info = queues.get(str(qtype))
    if not q_info:
        return True, 0, "الطابور فارغ بالفعل"

    bid = str(q_info.get("bid", ""))
    remain_sec = float(q_info.get("remain_time", 0) or 0)
    if remain_sec <= 0:
        return True, 0, "مكتمل بالفعل"

    # Step 1: Free Speedup attempt (mode: "0")
    resp_free = await self.safe_query("1003", "2", {
        "qtype": str(qtype),
        "mode": "0",
        "items": [],
        "decreaseTime": "0",
    }, min_delay=0.5, max_delay=0.9)

    if resp_free and str(resp_free.get("err")) in ("0", "1010"):
        self.sync_in_memory_completed_queue(qtype, bid)
        return True, int(remain_sec), "تم الإنهاء بالتسريع المجاني"

    # Step 2: Greedy Backpack Items Solver
    bag = self.get_ctrl("backpackCtrl") or {}
    rem = remain_sec
    items_to_use = []
    total_reduction = 0

    # Building speedups first (5011xx), then General speedups (5006xx)
    for item_id, item_sec, item_name in SPEEDUP_ITEMS:
        s_id = str(item_id)
        item_val = bag.get(s_id, 0)
        avail_cnt = int(item_val.get("count", 0)) if isinstance(item_val, dict) else int(item_val or 0)
        if avail_cnt <= 0:
            continue
        needed_cnt = int(rem // item_sec)
        if needed_cnt <= 0:
            continue
        use_cnt = min(avail_cnt, needed_cnt)
        items_to_use.append({"id": int(s_id), "count": int(use_cnt)})
        rem -= (use_cnt * item_sec)
        total_reduction += (use_cnt * item_sec)

    # Tail closing (60s <= rem <= 300s) with 1x 5min item if available
    if 60 <= rem <= 300:
        for it_id in [501101, 500601]:
            s_id = str(it_id)
            item_val = bag.get(s_id, 0)
            avail = int(item_val.get("count", 0)) if isinstance(item_val, dict) else int(item_val or 0)
            if avail > 0:
                items_to_use.append({"id": it_id, "count": 1})
                rem = 0.0
                total_reduction += 300
                break

    if not items_to_use:
        return False, 0, "لا تتوفر أدوات تسريع كافية"

    # Send batched speedup request (mode: "2")
    resp_tool = await self.safe_query("1003", "2", {
        "qtype": str(qtype),
        "mode": "2",
        "items": items_to_use,
        "decreaseTime": "0",
    }, min_delay=0.8, max_delay=1.5)

    err_code = str(resp_tool.get("err", "-1")) if isinstance(resp_tool, dict) else "-1"
    if err_code in ("0", "1010"):
        # Deduct items from in-memory backpack
        for it in items_to_use:
            s_id = str(it["id"])
            c = it["count"]
            if s_id in bag:
                if isinstance(bag[s_id], dict):
                    bag[s_id]["count"] = max(0, int(bag[s_id].get("count", 0)) - c)
                else:
                    bag[s_id] = max(0, int(bag[s_id] or 0) - c)

        # Final free speedup attempt to catch tail
        resp_f2 = await self.safe_query("1003", "2", {
            "qtype": str(qtype), "mode": "0", "items": [], "decreaseTime": "0",
        }, min_delay=0.4, max_delay=0.8)

        if err_code == "1010" or rem <= 60 or (resp_f2 and str(resp_f2.get("err")) in ("0", "1010")):
            self.sync_in_memory_completed_queue(qtype, bid)
            return True, total_reduction, "تم إنهاء الترقية بالتسريع بنجاح"
        else:
            # Partial reduction: speedups ran out, leave queue running naturally
            return False, total_reduction, "استهلاك المتاح من أدوات التسريع والتوقف لعدم كفاية الرصيد"

    return False, 0, f"فشل أمر التسريع (كود: {err_code})"
```

---

#### D. Complete Control Flow & Supportive Buildings Fallback

```python
async def run(self) -> TaskResult:
    cfg = self.config
    do_castle = bool(cfg.get("upgrade_castle", True))
    do_support = bool(cfg.get("upgrade_support_buildings", True))
    do_speedup = bool(cfg.get("speedup_castle", False))
    check_only = bool(cfg.get("check_only", False))
    max_target_castle_lv = int(cfg.get("max_castle_level", 130) or 130)

    accelerated_completed_count = 0
    MAX_ACCELERATED_LIMIT = 5
    speedup_exhausted = False
    actions_taken: List[str] = []

    # 1. Pre-flight
    blist = self._get_city_buildings()
    if not blist:
        return TaskResult.fail("تعذر العثور على بيانات مباني المدينة في الذاكرة الحية")

    max_slots = self.calculate_max_build_slots()
    active_queues = await self.refresh_active_queues()
    free_slots = max(0, max_slots - len(active_queues))

    # 2. Cycle Entry Acceleration (R2: Accelerate in-progress queues on entry)
    if do_speedup and not check_only and active_queues:
        for qt in list(active_queues.keys()):
            if accelerated_completed_count >= MAX_ACCELERATED_LIMIT or speedup_exhausted:
                break
            q_info = active_queues.get(qt, {})
            if float(q_info.get("remain_time", 0)) > 60:
                completed, red, reason = await self.accelerate_queue_to_completion(qt)
                if completed:
                    accelerated_completed_count += 1
                    actions_taken.append(f"⚡ تسريع استباقي لطابور {qt}")
                else:
                    speedup_exhausted = True
                    break

        active_queues = await self.refresh_active_queues()
        free_slots = max(0, max_slots - len(active_queues))

    # 3. 0-Network Exit Guard: If no free slots and cannot accelerate, exit immediately
    if free_slots <= 0 and (not do_speedup or speedup_exhausted or accelerated_completed_count >= MAX_ACCELERATED_LIMIT):
        min_rem = min((float(q.get("remain_time", 0)) for q in active_queues.values()), default=0)
        return TaskResult.ok(f"طوابير البناء مشغولة بالكامل ({format_duration(min_rem)}) — التوقف بصفر طلبات شبكية")

    # 4. Castle & Recursive Prerequisite Loop (R1 & R2)
    if do_castle and self._get_castle_level() < max_target_castle_lv:
        castle_loop_passes = 0
        while castle_loop_passes < 10 and free_slots > 0:
            castle_loop_passes += 1
            target_clv = min(self._get_castle_level() + 1, max_target_castle_lv)
            candidates = self.find_ready_prerequisites("101", target_clv)

            if not candidates:
                # Castle itself might be ready if all prerequisites are fulfilled
                if self.is_castle_ready(target_clv):
                    candidates = [{
                        "bid": "101",
                        "target_lv": target_clv,
                        "current_lv": self._get_castle_level(),
                        "action": "upgrade",
                        "instance": self.get_castle_instance(),
                        "depth": 0,
                    }]
                else:
                    break  # Prerequisite tree is blocked or satisfied

            upgraded_in_pass = 0
            for cand in candidates:
                if free_slots <= 0:
                    break

                # Execute upgrade or construction
                ok_up, msg = await self.execute_building_action(cand)
                if ok_up:
                    actions_taken.append(msg)
                    free_slots -= 1
                    upgraded_in_pass += 1
                    target_qtype = "1200" if "1200" not in self.active_queues else "1201"

                    # Accelerate if enabled
                    if do_speedup and not speedup_exhausted and accelerated_completed_count < MAX_ACCELERATED_LIMIT:
                        completed, red, r_msg = await self.accelerate_queue_to_completion(target_qtype)
                        if completed:
                            accelerated_completed_count += 1
                            free_slots += 1  # Queue is free again for next prerequisite!
                        else:
                            speedup_exhausted = True
                else:
                    # Upgrade blocked (resources / tools / activity)
                    pass

            if upgraded_in_pass == 0 or free_slots <= 0:
                break

    # 5. Supportive Buildings Fallback Loop (R3)
    active_queues = await self.refresh_active_queues()
    free_slots = max(0, max_slots - len(active_queues))

    if do_support and free_slots > 0:
        support_cands = self.get_eligible_supportive_candidates()
        for s_cand in support_cands:
            if free_slots <= 0:
                break
            ok_s, s_msg = await self.execute_support_upgrade(s_cand)
            if ok_s:
                actions_taken.append(s_msg)
                free_slots -= 1
                # STRICT RULE: NO SPEEDUP FOR SUPPORTIVE BUILDINGS IN THIS CYCLE!
                # Left to build naturally in real time.

    # 6. Final TaskResult
    ...
```

---

## 5. Verification Method

### 5.1 Offline Verification Commands
Run offline method test runner on local live memory snapshots to verify:
1. **VIP 2-Queue Detection**:
   ```powershell
   python test_task_method.py --offline -m docs/beetoo1_live_memory.json --task building calculate_max_build_slots
   ```
   *Expected Result*: Returns `2` (since beetoo1 has VIP 10 in `lordInfoCtrl.vip.level`).
2. **0-Network Pre-Flight on Idle Queues**:
   ```powershell
   python test_task_method.py --offline -m docs/beetoo1_live_memory.json --task building refresh_active_queues
   ```
   *Expected Result*: Returns `{}` with ZERO mock network queries.
3. **Dry-Run Full Cycle**:
   ```powershell
   python test_task_method.py --offline -m docs/beetoo1_live_memory.json --task building run
   ```

### 5.2 Live Field Verification Commands
On genuine live test accounts per GEMINI.md Rule 5 & Rule 8:
```powershell
python test_task_method.py --email beetoo1@hotmail.com --task building run
```
Verify logs:
- `📊 طوابير البناء: 0/2 (متاح: 2)`
- Correct bottom-up leaf prerequisite selection.
- Greedily batched speedup items without gold usage (`mode: "0"` or `"2"`).
- Exact speedup count bounded by `<= 5`.
- No speedup applied to supportive buildings.

### 5.3 Invalidation Conditions
- Any code change using `mode: 1` or spending gold.
- Any network request fired when live memory already confirms queues are full or condition is unsatisfied.
- Any regression that defaults VIP >= 2 accounts to 1 building queue.
