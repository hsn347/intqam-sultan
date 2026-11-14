# Handoff Report — Challenger 2 (Stress & Concurrency)

**Agent**: Challenger 2 (Stress & Concurrency Challenger)  
**Role**: critic, specialist  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\challenger_stress_concurrency\`  
**Target Modules**: `tasks/daily_train.py`, `tasks/train.py`, `tasks/forge_equipment.py`, `api_server.py`, `dashboard/src/components/accounts/CastleCard.tsx`  
**Verdict**: **REQUEST_CHANGES**

---

## 1. Observation

### Obs 1: Concurrency & QueueCtrl Sync (R1)
- In `tasks/train.py`, `sync_training_queue_in_memory` (lines 254–361) synchronously populates `conn.init_data["queueCtrl"][qtype]` with `starttime`, `totaltime`, and `data` (`bid`, `armyid`, `armycount`).
- Running `DailyTrainTask.run()` on an idle mock connection trained 250 Infantry units (CMD 1005 / SubCMD 2), immediately writing `qtype="1203"` into `conn.init_data["queueCtrl"]["1203"]`, populating `conn.init_data["armyCtrl"]["trainArmy"]["118"]`, setting `everydayTaskCtrl.eventInfo["12"] = 5`, and adding `4100012` to `questCtrl.point_finish_list`.
- Following immediately with `TrainTask.run()` on the exact same memory object, `check_barracks_busy` (lines 399–461) returned:
  ```python
  (True, 1791, "تدريب نشط في الطابور")
  ```
- `TrainTask.run()` logged `⏳ 🛡️ [المشاة] قيد التدريب حالياً (متبقي: 29 دقيقة) — تم التخطي (0-Network)` and sent **0 network queries** for Infantry.

### Obs 2: Disconnection Performance & In-Flight Abort (R1)
- When `conn.is_connected = False`, `DailyTrainTask.run()` and `TrainTask.run()` immediately exited in **0.013 ms** (13.5 µs average across 1,000 iterations; max 0.076 ms) and sent **0 network packets**.
- When the gateway disconnected mid-flight on attempt 1 of `_train_adaptive`:
  - `_train_adaptive` exited on attempt 1 (0 retries).
  - The outer loop over the 5 troop types broke cleanly at line 285 (`if err_reason == "انقطاع الاتصال بالبوابة": break`).
  - However, at line 304 of `tasks/daily_train.py`:
    ```python
    return TaskResult.ok(
        summary_msg,
        data={...}
    )
    ```
    The task returned `TaskResult.ok("لم يتطلب الأمر أي تدريب نشاط يومي.")` with `success=True`, masking the connection drop failure.

### Obs 3: Smart Delegation Configuration Bleed Bug (R1)
- In `tasks/daily_train.py`, line 101:
  ```python
  self._train_engine = TrainTask(conn, log_func, config)
  ```
- In `tasks/train.py`, lines 490–498:
  ```python
  def _extract_train_config(self) -> Dict[str, Any]:
      if not isinstance(self.config, dict):
          return {}
      if "train" in self.config and isinstance(self.config["train"], dict):
          return self.config["train"]
      if "tasks" in self.config and isinstance(self.config["tasks"], dict) and "train" in self.config["tasks"]:
          return self.config["tasks"]["train"]
      return self.config
  ```
- In `bot_manager.py`, line 619:
  ```python
  task_instance = task_cls(self.conn, self.log, t_cfg)
  ```
  `bot_manager` passes `t_cfg` (which is `{"enabled": True}`) to `DailyTrainTask`.
- When `DailyTrainTask` initializes `_train_engine = TrainTask(conn, log_func, config)`, `TrainTask` receives `{"enabled": True}` without a `"train"` subkey. Line 498 returns `self.config` (`{"enabled": True}`).
- `TrainTask._parse_types_and_levels` defaults to `selected_types = ['infantry', 'cavalry', 'archers', 'chariots', 'fortress']` with level 10.
- In `DailyTrainTask._is_type_handled_by_main_train`:
  ```python
  if self._train_engine:
      train_cfg = getattr(self._train_engine, "train_cfg", {})
      if isinstance(train_cfg, dict) and train_cfg.get("enabled", False):
          selected = getattr(self._train_engine, "selected_types", [])
          target_lvls = getattr(self._train_engine, "target_levels", {})
          return (troop_key in selected) and (int(target_lvls.get(troop_key, 0) or 0) > 0)
  ```
  This evaluated to **`True`** for all 5 troop types even when `train` was disabled in the castle config. Consequently, `DailyTrainTask` skipped all 5 troops (`5 أنواع متروكة للتدريب العادي`) and trained 0 units.

### Obs 4: Rapid Stop Action Stress (R4)
- 50 Rapid sequential calls to `POST /api/bots/stop/{castle_id}` via HTTPX:
  - Status codes: **50 / 50 returned 200 OK (0% 500s)**.
  - Average latency: **13.47 ms** (min 9.78 ms, max 29.24 ms).
  - Final SQLite DB state in `castle_states`: `state = "idle"`, `conn_state = "idle"`.
- 50 Concurrent burst calls via `asyncio.gather`:
  - Status codes: **50 / 50 returned 200 OK (0% 500s)**.
  - Exceptions raised (`sqlite3.OperationalError`): **0**.
  - Total burst time: **703.08 ms** (average request latency 389.39 ms).
  - Final SQLite DB state: `state = "idle"`, `conn_state = "idle"`.
- Querying `GET /api/castles` with orphaned `state = "running"` in DB when `bot_manager.get_bot(email)` is `None` reconciled the castle response to `state = "idle"`, `conn_state = "idle"`.

### Obs 5: Forge Boundary Conditions (R2)
- In `tasks/forge_equipment.py`:
  - When `equipmentCtrl.fe` had a completed item (`endTime < now`), `run()` sent CMD 1047 / SubCMD 2 with `{"epid": 7771, "isDirectGet": "1"}`, claimed the item, cleared `fe`, marked daily quest `4100009` completed, and consumed 0 steel and 0 materials.
  - When queue 1229 was active (3,499s remaining), `can_run()` returned `(False, "Blacksmith is busy forging (0-Network) (remaining: 3499s)")` and `run()` skipped with **0 network queries**.
  - When `equipment_array` held 200 items (full bag), `run()` skipped with `"حقيبة العتاد ممتلئة بالكامل (200/200) (0-Network)"` with **0 network queries**.
  - When BID 115 was missing from `cityCtrl.blist`, `run()` skipped with **0 network queries**.

---

## 2. Logic Chain

1. **Step 1 (0-Network & Sync Correctness)**:
   Observations 1, 4, and 5 verify that the primary requirements of R1 (QueueCtrl in-memory sync and 0-network busy checks), R2 (Forge completion claim and busy/full-bag 0-network skips), and R4 (Stop endpoint resilience and idle reconciliation) are architecturally sound and empirically verified.
2. **Step 2 (The Smart Delegation Bleed Defect)**:
   From Observation 3, `bot_manager` instantiates tasks with task-level slice configs `task_cls(self.conn, self.log, t_cfg)`. When `DailyTrainTask` delegates to `TrainTask(conn, log_func, config)`, `TrainTask._extract_train_config` receives `{"enabled": True}`. Since `"train"` is not a dictionary key, it falls back to `self.config` and treats `TrainTask` as enabled for all 5 troop types at level 10.
3. **Step 3 (Impact of Bleed Defect)**:
   In live bot runs, `DailyTrainTask` checks `_is_type_handled_by_main_train()`, which checks `self._train_engine.train_cfg.get("enabled")`. Because this is erroneously `True`, `DailyTrainTask` skips every troop type, leaving daily activity quests permanently incomplete.
4. **Step 4 (In-Flight Disconnection Masking)**:
   From Observation 2, when the network drops mid-flight during training, the troop loop breaks out cleanly. However, instead of returning `TaskResult.fail()`, it reaches the method bottom and returns `TaskResult.ok()`. This masks connection errors from `bot_manager`.

---

## 3. Caveats

- Tests were executed using the deterministic empirical harness `empirical_stress_harness.py` simulating game gate protocol responses and live memory snapshots, as well as the live SQLite database `database/castles.db` and FastAPI application.
- Real socket packet latency on cellular networks may exceed the simulated 50ms flight time, but concurrency safety invariants remain identical.

---

## 4. Conclusion & Actionable Next Steps

**Verdict: REQUEST_CHANGES**

The core mechanisms for R1, R2, and R4 pass empirical stress testing. However, two concrete defects in `tasks/daily_train.py` and `tasks/train.py` must be fixed by Worker 1 before approval:

1. **Fix Delegation Bleed in `tasks/daily_train.py` & `tasks/train.py`**:
   - In `tasks/daily_train.py.__init__`: Initialize `_train_engine` safely:
     ```python
     train_config = self.config.get("train", {}) if isinstance(self.config, dict) else {}
     self._train_engine = TrainTask(conn, log_func, train_config)
     ```
   - In `tasks/train.py._extract_train_config`:
     If `"train"` is not in `self.config` and `self.config` contains keys like `"daily_train"`, do NOT return `self.config`; return `{"enabled": False}`.
2. **Fix In-Flight Disconnection Return in `tasks/daily_train.py`**:
   - In `tasks/daily_train.py.run()`:
     ```python
     if not self.conn or not getattr(self.conn, "is_connected", False):
         return TaskResult.fail("انقطاع الاتصال بالبوابة")
     ```
     Before returning `TaskResult.ok()`, check if the loop aborted due to connection loss.

---

## 5. Verification Method

To independently verify these findings:
```powershell
python .agents\teamwork\challenger_stress_concurrency\empirical_stress_harness.py
```
Expected output:
- Test 1.4 confirms the Smart Delegation Config Bleed bug (`infantry_falsely_delegated: True`).
- Tests 1.1, 1.2, 1.3, 2.1, 2.2, 3.1, 3.2, 3.3, 4.1, 4.2, 4.3, 4.4 pass cleanly with 0 network calls and < 0.1ms abort timings.
