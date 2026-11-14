# Changes Summary — worker_remediation_r2

## Target File Modified
- `e:\intqam-sultan\tasks\daily_train.py`

## Rationale & Modifications

### 1. Bug 1: Smart Delegation False-Positive Bleed (Suite 1 Test 1.4)
- **Root Cause**: When `bot_manager` dispatches `DailyTrainTask`, it passes task slice config: `config = {"enabled": True}`. Previously, `DailyTrainTask.__init__` forwarded `self.config` directly to `TrainTask(conn, log_func, config)`. Because `TrainTask.__init__` found `enabled: True` with no `types` or `levels`, it defaulted to all 5 troop types at level 10. `DailyTrainTask._is_type_handled_by_main_train()` then evaluated to `True` for all 5 types, causing `DailyTrainTask` to skip all daily training quests during live runs.
- **Fix Applied**:
  - Added `_extract_main_train_config(self) -> Dict[str, Any]` in `DailyTrainTask` to specifically and safely extract the user's explicit train configuration from `config["train"]` or `config["tasks"]["train"]`, returning `{}` if absent.
  - In `DailyTrainTask.__init__`, initialized `self._train_engine = TrainTask(conn, log_func, main_train_cfg)` passing only the explicit main train config.
  - In `DailyTrainTask._is_type_handled_by_main_train(self, troop_key: str)`:
    - Added an explicit pre-check: if no explicit `"train"` key exists in `self.config` (or `tasks.train`), return `False` immediately.
    - Verified `train_cfg.get("enabled", False) is True`.
    - If `levels` dict is present, checked whether `troop_key` has `level > 0`.
    - If `types`/`type` is present (list, tuple, or string), normalized via `TYPE_ALIASES` and verified inclusion.
    - Prevented fallback to treating all types as enabled when train config is missing or empty.

### 2. Bug 2: In-Flight Disconnection Return Code (Suite 2 Test 2.3)
- **Root Cause**: During the troop training loop in `DailyTrainTask.run()`, if connection loss was detected mid-operation (e.g. `err_reason == "انقطاع الاتصال بالبوابة"` or `conn.is_connected == False`), the loop broke, but execution fell through to the end of the method and returned `TaskResult.ok(summary_msg, ...)`. This falsely reported success instead of an error state.
- **Fix Applied**:
  - Added `is_disconnected = False` flag in `DailyTrainTask.run()`.
  - Added connection health checks after ready barracks harvesting, during troop iteration, and after adaptive training requests.
  - Set `is_disconnected = True` and broke immediately when disconnection was detected.
  - At the completion of the method: if `is_disconnected or not self.conn or not getattr(self.conn, "is_connected", False)`, returned `TaskResult.fail("انقطاع الاتصال بالبوابة")`.

## Verification Results
1. **Empirical Stress & Concurrency Harness**:
   `python .agents/teamwork/challenger_stress_concurrency/empirical_stress_harness.py`
   - **Result**: 14/14 PASSED (100% compliance).
   - Test 1.4 (Smart Delegation False-Positive Bleed): **PASS**
   - Test 2.3 (In-Flight Disconnection Return Code): **PASS**
2. **Live Castle Regression Check**:
   `python test_task_method.py --email beetoo3@hotmail.com --task daily_train run`
   - **Result**: PASSED (Exit code 0, 0-Network pre-flight checks executed, harvested ready troops, identified busy and completed troops cleanly).

