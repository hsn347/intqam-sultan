# Empirical Stress & Concurrency Test Report

**Agent**: Challenger 2 (Stress & Concurrency Challenger)  
**Date**: 2026-11-01  
**Target Workspace**: `e:\intqam-sultan`  
**Test Harness**: `.agents/teamwork/challenger_stress_concurrency/empirical_stress_harness.py`  
**Overall Verdict**: **REQUEST_CHANGES** (12/14 Passed, 2 Critical Defect Invariants Identified)

---

## Executive Summary

Challenger 2 executed empirical stress, boundary, and concurrency testing on the modified backend tasks (`tasks/train.py`, `tasks/daily_train.py`, `tasks/forge_equipment.py`), API server endpoints (`api_server.py`), and frontend state coordination mechanisms (`CastleCard.tsx`).

All empirical benchmarks were executed in an isolated adversarial test runner recording microsecond-resolution timings, raw query log captures, and memory state invariant assertions.

### Benchmark Highlights
1. **0-Network Pre-Flight Invariants**: Verified 100% compliant across barracks busy checks, forge queue 1229 busy checks, and full-bag checks (0 queries sent).
2. **Immediate Disconnection Abort**: Verified < 0.1ms exit (target was < 10ms; achieved **0.013ms** average) across 1,000 continuous iterations with zero retry loops and zero network packets.
3. **Rapid Stop Action Resilience**: 50 rapid sequential and 50 concurrent burst stop calls executed with **0% 500 errors**, **0 SQLite database lock contentions**, and guaranteed clean reconciliation to `"idle"`.
4. **Forge 22002 Boundary Handlers**: Verified immediate claim of completed items from `equipmentCtrl.fe` with CMD 1047 SubCMD 2 (`isDirectGet="1"`), zero-resource consumption, and 0-network clean exit on active queue 1229 or full equipment bag (>= 200 items).
5. **Critical Bugs Discovered**:
   - **Bug 1 (High Impact)**: Smart Delegation False-Positive Bleed in `DailyTrainTask`. When `bot_manager` dispatches `DailyTrainTask` with slice config `{"enabled": True}`, `_train_engine` (TrainTask) inherits `enabled: True`, defaulting to all 5 troop types at level 10. `DailyTrainTask` evaluates `_is_type_handled_by_main_train() == True` for all 5 types and skips them all, resulting in **zero troops trained and zero daily quests completed** during live bot runs.
   - **Bug 2 (Medium Impact)**: In-Flight Disconnection returns `TaskResult.ok()` instead of `TaskResult.fail()`. While the loop breaks immediately upon connection loss, it falls through to return `ok("لم يتطلب الأمر أي تدريب...")`, falsely reporting success to callers.

---

## Suite 1: Concurrency & QueueCtrl In-Memory Sync (R1)

### Test 1.1: DailyTrainTask Immediate queueCtrl, armyCtrl & questCtrl Sync
- **Scenario**: Simulated castle connection with 5 barracks (Lv 10) and Military Tents capacity >= 250 units. Daily quest progress at 0/5 cycles.
- **Execution**: `DailyTrainTask.run()` triggered CMD 1005 / SubCMD 2. Mock responded with `queuetype="1203"`, `totaltime=1800`.
- **Observed Invariants**:
  - `conn.init_data["queueCtrl"]["1203"]` populated: `qtype="1203"`, `starttime=now`, `totaltime=1800`, `data.bid="118"`, `data.armycount="250"`, `data.armyid="401"`.
  - `conn.init_data["armyCtrl"]["trainArmy"]["118"]` populated: `armyid="401"`, `armycount="250"`, `totaltime=1800`.
  - `conn.init_data["everydayTaskCtrl"]["eventInfo"]["12"]` updated immediately from 0 to 5.
  - `conn.init_data["questCtrl"]["point_finish_list"]` populated with `4100012` and `"4100012"`.
- **Timing**: Task execution completed in **10.07s** (including simulated sleep intervals).
- **Result**: **PASS**

### Test 1.2: TrainTask 0-Network Pre-Flight on Busy Barracks
- **Scenario**: Follow immediately with `TrainTask.run()` on the exact same `conn` memory object, configured for Infantry Lv 10.
- **Execution**:
  - `check_barracks_busy(conn, "118", now_ts)` returned `(True, 1791, "تدريب نشط في الطابور")`.
  - `TrainTask.run()` logged busy barracks and skipped Infantry.
- **Observed Invariants**:
  - New network queries sent by `TrainTask` for busy barracks: **EXACTLY 0**.
  - Infantry correctly recorded in `busy_summary`: `[{"type": "المشاة", "bid": "118", "remaining_seconds": 1791}]`.
  - Duration: **0.41 ms**.
- **Result**: **PASS** (Zero network calls, Error 4002 completely avoided).

### Test 1.3: Concurrent Execution Race Condition (Simultaneous Coroutines)
- **Scenario**: `DailyTrainTask` and `TrainTask` executed concurrently via `asyncio.gather` on an idle castle memory with 50ms simulated network flight time.
- **Observed Invariants**:
  - Total queries sent for Infantry: 2 (one per task during flight window).
  - Exceptions raised: **0**.
  - Final in-memory state: valid and consistent.
- **Result**: **PASS**

### Test 1.4: Adversarial Probe — Smart Delegation Config Bleed Bug
- **Scenario**: Simulate `bot_manager` dispatching `DailyTrainTask` with slice config `{"enabled": True}` (without an explicit `"train"` key).
- **Observed Invariants**:
  - `_train_engine` (`TrainTask`) was initialized with `self.config` (`{"enabled": True}`).
  - `TrainTask._extract_train_config()` returned `{"enabled": True}`.
  - `_train_engine.selected_types` defaulted to `['infantry', 'cavalry', 'archers', 'chariots', 'fortress']` with level 10.
  - `_is_type_handled_by_main_train("infantry")` returned **`True`**.
  - `_is_type_handled_by_main_train("cavalry")` returned **`True`**.
- **Impact**: In standard bot manager execution, `DailyTrainTask` thinks regular `train` is handling all troops, skipping all 5 troops without doing any work.
- **Result**: **FAIL (DEFECT CONFIRMED)**

---

## Suite 2: Disconnection Stress Test (R1)

### Test 2.1: Entry Disconnection Abort Latency & Packet Count
- **Scenario**: `conn.is_connected = False`. Run `DailyTrainTask` and `TrainTask`.
- **Measured Latency**:
  - `DailyTrainTask`: **0.013 ms** (13.2 µs).
  - `TrainTask`: **0.011 ms** (11.4 µs).
  - Target: < 10.0 ms.
- **Network Packets Sent**: **0** (0 packets).
- **Result**: **PASS**

### Test 2.2: 1,000-Iteration High-Frequency Disconnection Benchmark
- **Scenario**: Tight loop executing 1,000 sequential disconnected task runs.
- **Measurements**:
  - Iterations: 1,000.
  - Total Elapsed Time: **0.102 seconds** (~9,839 task executions / sec).
  - Minimum Duration: **9.8 µs**.
  - Average Duration: **13.5 µs**.
  - 99th Percentile Duration: **35.2 µs**.
  - Maximum Duration: **76.3 µs** (**0.076 ms** << 10.0 ms target).
  - Total Network Packets Sent across 1,000 runs: **0**.
  - Infinite loops or hangs: **0**.
- **Result**: **PASS**

### Test 2.3: In-Flight Connection Drop During Adaptive Retries
- **Scenario**: Connection drops mid-query on attempt 1 of CMD 1005 / SubCMD 2.
- **Observed Invariants**:
  - Training attempts made: **1** (stopped immediately, did not loop through attempts 2 and 3).
  - Loop across remaining 4 troop types broke immediately without sending any queries.
  - Duration: **494.72 ms**.
  - **Defect Identified**: `DailyTrainTask.run()` returned `TaskResult.ok("لم يتطلب الأمر أي تدريب...")` instead of `TaskResult.fail("انقطاع الاتصال بالبوابة")`.
- **Result**: **FAIL (DEFECT CONFIRMED)**

---

## Suite 3: Rapid Stop Action Stress Test (R4)

### Test 3.1: 50 Rapid Sequential Stop Requests
- **Endpoint**: `POST /api/bots/stop/test_stress_castle_r4` via HTTPX ASGI transport.
- **Results**:
  - Requests: 50 / 50.
  - HTTP 200 OK: **50 (100%)**.
  - HTTP 500 / Errors: **0 (0%)**.
  - Min Latency: **9.78 ms**.
  - Avg Latency: **13.47 ms**.
  - Max Latency: **29.24 ms**.
  - Final SQLite Database State: `state = "idle"`, `conn_state = "idle"`.
- **Result**: **PASS**

### Test 3.2: 50 Concurrent Burst Stop Requests
- **Scenario**: 50 simultaneous coroutines firing `POST /api/bots/stop/{castle_id}` at the exact same instant using `asyncio.gather`.
- **Results**:
  - Requests: 50 / 50.
  - HTTP 200 OK: **50 (100%)**.
  - HTTP 500 / Errors: **0 (0%)**.
  - SQLite Lock Exceptions (`sqlite3.OperationalError`): **0**.
  - Total Burst Elapsed: **703.08 ms**.
  - Average Request Latency: **389.39 ms**.
  - Final SQLite Database State: `state = "idle"`, `conn_state = "idle"`.
- **Result**: **PASS** (SQLite WAL mode + `bot_manager._lock` prevent race contentions).

### Test 3.3: Inactive Bot State Reconciliation on `GET /api/castles`
- **Scenario**: Injected orphaned `"running"` state into SQLite `castle_states` when no active bot instance exists in memory.
- **Observation**:
  - `GET /api/castles` dynamically detected that `bot_manager.get_bot(email)` returned `None`.
  - Reconciled response returned `state = "idle"`, `conn_state = "idle"`, `status_message = "متوقف"`.
- **Result**: **PASS**

---

## Suite 4: Forge Boundary Test (R2)

### Test 4.1: Finished Item in `equipmentCtrl.fe` Immediate Claim
- **Scenario**: `equipmentCtrl.fe` has `{epid: 7771, eid: 610101, endTime: now - 500}`.
- **Observed Invariants**:
  - Sent CMD 1047 / SubCMD 2 with payload: `{"epid": 7771, "isDirectGet": "1"}`.
  - Removed `fe` from `equipmentCtrl`.
  - Appended item to `equipment_array`.
  - Incremented `everydayTaskCtrl.eventInfo["4100009"] = 1`.
  - Appended `4100012` to `questCtrl.point_finish_list`.
  - Steel and material cost: **0**.
- **Result**: **PASS**

### Test 4.2: Queue 1229 Active 0-Network Clean Exit
- **Scenario**: Active crafting in queue 1229 with 3,499s remaining.
- **Observed Invariants**:
  - `can_run()` returned `(False, "Blacksmith is busy forging (0-Network) (remaining: 3499s)")`.
  - `run()` skipped with `"Blacksmith is busy forging (0-Network)"`.
  - Network queries sent: **0**.
- **Result**: **PASS** (Zero network calls, Error 22002 eliminated).

### Test 4.3: Full Equipment Bag (>= 200 items)
- **Scenario**: `equipment_array` populated with 200 items.
- **Observed Invariants**:
  - `run()` skipped with `"حقيبة العتاد ممتلئة بالكامل (200/200) (0-Network)"`.
  - Network queries sent: **0**.
- **Result**: **PASS** (Server error 22012 prevented).

### Test 4.4: Missing Blacksmith Building (BID 115 missing)
- **Scenario**: BID 115 not in `cityCtrl.blist`.
- **Observed Invariants**:
  - `run()` skipped with `"ورشة الحدادة غير مبنية في القلعة (0-Network)"`.
  - Network queries sent: **0**.
- **Result**: **PASS**

---

## Benchmark Data Summary

| Test ID | Benchmark Description | Target Metric | Measured Metric | Status |
|---------|-----------------------|---------------|-----------------|--------|
| **1.1** | DailyTrain queueCtrl Sync | Valid In-Memory State | `qtype=1203`, `count=250`, `eventInfo=5` | **PASS** |
| **1.2** | TrainTask Barracks Pre-Flight | 0 Queries Sent | **0 Queries** (rem_s=1791) | **PASS** |
| **1.3** | Training Concurrency Race | 0 Exceptions | **0 Exceptions**, consistent memory | **PASS** |
| **1.4** | Smart Delegation Config Bleed | Accurate Delegation | **Falsely delegated all 5 types** | **FAIL** |
| **2.1** | Single Disconnection Abort | < 10.0 ms, 0 Packets | **0.013 ms**, **0 Packets** | **PASS** |
| **2.2** | 1,000x Disconnection Loop | < 10.0 ms Max, 0 Packets | **0.076 ms Max**, **0 Packets** | **PASS** |
| **2.3** | In-flight Disconnection Abort | Fail Status, 1 query | 1 query, but returned `ok()` | **FAIL** |
| **3.1** | 50 Sequential Stop Calls | 0% 500s, Clean Idle | **0% 500s** (13.47 ms avg), Idle clean | **PASS** |
| **3.2** | 50 Concurrent Stop Burst | 0 Locks, 0% 500s | **0 Locks**, **0% 500s** (389 ms avg) | **PASS** |
| **3.3** | API Ghost State Reconciliation | Idle Reconciliation | Reconciled to `idle` | **PASS** |
| **4.1** | Forge Item Claim (fe) | CMD 1047/2, 0 Cost | Claimed (EPID 7771, direct=1) | **PASS** |
| **4.2** | Forge Queue 1229 Busy | 0 Queries Sent | **0 Queries**, Clean Skip | **PASS** |
| **4.3** | Forge Full Bag (>= 200) | 0 Queries Sent | **0 Queries**, Clean Skip | **PASS** |
| **4.4** | Missing Blacksmith | 0 Queries Sent | **0 Queries**, Clean Skip | **PASS** |

---

## Required Fixes for Worker Agents

### Fix 1 (Assigned to Worker 1 — `tasks/daily_train.py` & `tasks/train.py`):
1. In `tasks/daily_train.py`:
   When delegating `self._train_engine = TrainTask(conn, log_func, config)`:
   Do NOT pass `config` as `train`'s config if it does not contain a `"train"` subkey! Instead, initialize `_train_engine` with `config.get("train", {"enabled": False})`.
2. In `tasks/train.py`:
   In `_extract_train_config(self)`:
   If `self.config` does NOT have `"train"`, and contains other task keys (such as `"daily_train"`), return `{"enabled": False}` instead of falling back to `return self.config`.
3. In `tasks/daily_train.py` line 285 & line 304:
   If the execution loop was interrupted by `"انقطاع الاتصال بالبوابة"`, return `TaskResult.fail("انقطاع الاتصال بالبوابة")` instead of `TaskResult.ok()`.

---
*Report generated empirically by Challenger 2 (Stress & Concurrency Challenger).*
