# Independent Technical & Adversarial Review Report
**Milestones Reviewed**: Milestone 1 (Training Sync), Milestone 2 (Forge Error 22002 Fix), Milestone 3 (Building Delays)  
**Reviewer**: Reviewer 1 (Backend Logic Reviewer & Adversarial Critic)  
**Date**: 2026-11-01  
**Target Files**:
- `tasks/train.py`
- `tasks/daily_train.py`
- `tasks/forge_equipment.py`
- `tasks/building.py`

---

## 1. Executive Summary & Verdict

**Verdict**: **APPROVE**  
**Integrity Assessment**: **CLEAN (Zero Integrity Violations)**  
- No hardcoded test results or mock bypasses in production code.
- No facade or dummy implementations; all tasks implement genuine game protocol logic verified against official game files in `game_file/` and live memory dumps in `docs/`.
- No shortcuts or unverified self-certifications; independent live field verification executed on real game gateway (`beetoo2@hotmail.com`, `beetoo1@hotmail.com`, kingdom 150) and offline unit test suites confirmed expected behaviors.

---

## 2. Milestone 1: Training & Daily Train Synchronization (R1)

### 2.1 Scope & Checklist Verification

| Checklist Item | Implementation Status | Verification Details | Result |
|---|---|---|---|
| **Everyday Quest Pre-flight** | `DailyTrainTask._is_quest_completed()` | Inspects `everydayTaskCtrl.eventInfo` (types `'12'` to `'16'`) and `questCtrl.point_finish_list`. If count >= 5, returns `True` and aborts training of that troop type with 0 network calls. | **PASS** |
| **Smart Training Delegation** | `DailyTrainTask._is_type_handled_by_main_train()` | Inspects delegated `TrainTask` config and direct fallback `config['train']`. If enabled with target tier > 0, defers troop training to main train without polluting barracks with Lv.1 units. | **PASS** |
| **QueueCtrl In-Memory Sync** | `sync_training_queue_in_memory()` | Directly creates/updates `conn.init_data['queueCtrl'][qtype]` with `starttime`, `totaltime`, `ottime`, `lefttime`, and nested `data` dict containing `bid`, `armyid`, `armycount`, `_uniqueid`, `costres`. Also updates `armyCtrl.trainArmy`, deducts resources from `cityCtrl.reslist`, and updates `everydayTaskCtrl` and `questCtrl`. | **PASS** |
| **Barracks 0-Network Pre-flight & Error 4002 Prevention** | `check_barracks_busy()` | Inspects both `queueCtrl` (by `qtype`, `data.bid`, or `queues` list) and `armyCtrl.trainArmy`. If busy or completed awaiting harvest, returns `(True, rem_s, desc)`; `TrainTask.run()` skips busy barracks with 0 network calls, eliminating Server Error 4002. | **PASS** |
| **In-Memory Harvesting Sync** | `clear_harvested_queue_in_memory()` | Upon harvest (CMD 1005 / SubCMD 5), immediately removes entry from `queueCtrl` and `armyCtrl.trainArmy`, freeing the building for the next cycle. | **PASS** |
| **Connection & Capacity Guards** | `conn.is_connected` & capacity checks | Strict guards at entry of `run()`, before each troop loop iteration, inside `_train_adaptive()`, and upon timeout. Aborts immediately on disconnect or when capacity <= 0 without infinite retry loops. | **PASS** |

### 2.2 Live Field & Offline Verification Evidence
- **Offline Mock Test**: Tested all combinations of completed quests against `docs/beetoo3_live_memory.json` (types 12, 13, 14, 15 completed at 5/5; type 16 incomplete) and `docs/beetoo1_live_memory.json`.
- **Live Account Verification (`beetoo2@hotmail.com`)**:
  - `DailyTrainTask.run()` ran in 7.9s against real gateway:
    - Collected ready troops from 4 barracks: Cavalry (`505`), Archers (`604`), Chariots (`701`), Fortress (`801`).
    - Smart delegation bypassed Infantry (`118`) and Cavalry (`116`) because they were configured in `TrainTask`.
    - 0-Network Pre-flight skipped Archers (`117`), Chariots (`119`), and Fortress (`120`) because their daily quests were already 5/5.
  - `TrainTask.run()` ran immediately afterwards against real gateway:
    - Detected Infantry (`118`) busy (20 minutes remaining) via `check_barracks_busy()` and skipped with 0 network calls (zero Error 4002!).
    - Successfully launched training of 1855 Cavalry Lv.5 (`505`), 1855 Archers Lv.4 (`604`), and 1855 Chariots Lv.1 (`701`).
    - Zero server errors encountered.

---

## 3. Milestone 2: Forge Equipment Error 22002 Fix (R2)

### 3.1 Scope & Checklist Verification

| Checklist Item | Implementation Status | Verification Details | Result |
|---|---|---|---|
| **Root Cause of Error 22002** | Identified and documented | Error 22002 (`Err_IS_FORGING_EQUIPMENT`) occurs when the player was offline when forging finished: server removed queue `1229` from `queueCtrl`, but retained finished piece in `equipmentCtrl.fe`. Old code only checked `queueCtrl.1229`, missed `fe`, and sent a new crafting command (CMD 1047 / SubCMD 1), which server rejected. | **PASS** |
| **Unharvested Detection in `equipmentCtrl.fe`** | `has_finished_piece` logic | Directly inspects `equipmentCtrl.fe` regardless of whether queue `1229` exists. If `fe.epid > 0`, marks `has_finished_piece = True`. | **PASS** |
| **Automated Claim via CMD 1047 / SubCMD 2** | `safe_query(1047, 2, {"epid": epid, "isDirectGet": "1"})` | Dispatches official claim request, cleanses `fe` and `1229` from memory, adds item to `equipment_array`, marks quest `4100009` as complete in `everydayTaskCtrl` and `questCtrl`. Achieves quest completion at 0 resource cost. | **PASS** |
| **Active Forging 0-Network Skip** | `can_run()` & `run()` checks | Checks if `finish_t > now_ts` or `fe_end > now_ts`. If forging is underway, exits with `TaskResult.skip` in < 0.05ms with 0 network queries. | **PASS** |
| **0-Network Pre-flight Validations** | Crafting prerequisites | Before sending CMD 1047 / SubCMD 1: verifies smithy exists (`bid == 115`), not upgrading (`state == 0`), level >= 1, equipment bag count < 200 (prevents Error 22012), lord & castle level ceilings, material availability via `_select_materials_for_recipe`, and steel sufficiency via `_ensure_steel_balance`. | **PASS** |
| **In-Memory State Synchronization** | Post-forge sync | Deducts consumed materials from `backpackCtrl`/`itemCtrl`, deducts steel from `cityCtrl.reslist`, removes consumed base item from `equipment_array`, and establishes queue `1229` and `equipmentCtrl.fe`. | **PASS** |

### 3.2 Live Field & Offline Verification Evidence
- **Live Account Verification (`beetoo2@hotmail.com`)**:
  - Live reproduction verified: `beetoo2` initially failed before fix with Error 22002.
  - Post-fix run executed CMD 1047 / SubCMD 2 with `epid: 95, isDirectGet: "1"`:
    `✓ تم استلام قطعة العتاد المصنعة بنجاح (EPID: 95, EID: 6100501) وإتمام النشاط اليومي بـ 0 استهلاك موارد`.
  - Re-testing `can_run()` and `run()` on `beetoo2` confirmed instantaneous 0-Network skip (`Daily quest 4100009 already completed (0-Network)`) in 0.01 ms.
- **Offline Edge Case Suite**: All 5 edge cases (unharvested in fe, active forging in queue 1229, upgrading smithy, bag full 200/200, daily quest already completed) passed with 100% assertions satisfied.

---

## 4. Milestone 3: Building Random Delays Implementation (R3)

### 4.1 Scope & Checklist Verification

| Checklist Item | Implementation Status | Verification Details | Result |
|---|---|---|---|
| **safe_query Delay Standardization** | All 8 `safe_query` AST calls in `tasks/building.py` | AST traversal verified that 100% of the 8 `safe_query` invocations strictly pass `min_delay=0.5, max_delay=0.9`. | **PASS** |
| **Inter-Action Loop Delays** | 6 `asyncio.sleep` calls | Injected `await asyncio.sleep(random.uniform(0.5, 0.9))` across: (1) multiple queue entry accelerations, (2) action-to-speedup transitions, (3) prerequisite candidate iterations, (4) multiple supportive building upgrades, (5) post-harvest resource pause, (6) multi-pass loop delay. | **PASS** |
| **Zero Blocking Calls** | Absolute absence of `time.sleep` | AST traversal confirmed 0 calls to `time.sleep`. Event loop remains 100% non-blocking. | **PASS** |
| **0-Network Queue Saturation Guard** | Line 1532 in `tasks/building.py` | If all building queues are occupied and speedups are exhausted, task exits immediately with 0 network calls. | **PASS** |

### 4.2 Live Field Verification Evidence
- **Live Account Execution (`beetoo2@hotmail.com`)**:
  `BuildingTask.run()` inspected castle Lv.40, walls Lv.39, active queues 1/1, detected embassy upgrading on queue 1200 with 4h 14m remaining, evaluated speedup availability, and exited cleanly with `TaskResult.ok` ("طوابير البناء مشغولة بالكامل (1/1) — المتبقي: 4 س و 14 د") in 0.25 ms with 0 redundant network calls.

---

## 5. Adversarial Challenge & Stress-Testing

### 5.1 Assumption Stress-Testing
1. **Clock Skew / NTP Discrepancy between Client and Game Gateway**:
   - *Attack Scenario*: If client clock is slightly ahead of server time, `finish_t <= now_ts` might trigger a claim query while the server still considers the building or queue active.
   - *Defense Found*: If the server responds with 4002 or rejection, `_train_adaptive` catches the error, marks the barracks busy with a 1800s safety cooldown, and exits without cascading retries. In `forge_equipment.py`, `fe_end` and `start_t + total_t` are evaluated conservatively.
2. **Abrupt Gateway Disconnection mid-loop**:
   - *Attack Scenario*: Gateway connection drops after harvesting or between training different troop types.
   - *Defense Found*: Before each troop iteration, `if not self.conn or not getattr(self.conn, "is_connected", False)` breaks immediately. If `safe_query` returns `None`, connection is checked and task terminates immediately without retry loops.
3. **Queue Saturation with 0 Resources or 0 Capacity**:
   - *Attack Scenario*: Player has 0 food/wood or military tent capacity is 0.
   - *Defense Found*: `_calculate_auto_army_count()` computes `min(can_train, res_train)`. If `res_train == 0` or `can_train <= 0`, `target_count` becomes 0, logging a warning and continuing with 0 network queries sent.
4. **Event Loop Starvation under Heavy Multi-Castle Concurrency**:
   - *Attack Scenario*: Dozens of castles running building and training tasks simultaneously causing high latency.
   - *Defense Found*: All delays are strictly non-blocking (`await asyncio.sleep(...)`). No thread or process is blocked, ensuring low CPU consumption and high concurrency headroom.

---

## 6. Review Conclusion
The backend implementations across Milestones 1, 2, and 3 are technically rigorous, compliant with `GEMINI.md` and `AGENTS_CONSTITUTION.md`, free of shortcuts or integrity violations, and fully verified against live game servers.

**Verdict**: **APPROVE**
