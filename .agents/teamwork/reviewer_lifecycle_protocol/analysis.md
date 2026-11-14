# Protocol & Safety Review: Command Hall Lifecycle & Adversarial Analysis

**Review Target**: `tasks/command_hall.py` (Command Hall Task Lifecycle Overhaul)  
**Authoritative Specs**: Official Game Client Lua Codebase (`game_file/src/`), `GEMINI.md`, `PROJECT_STRUCTURE.md`  
**Reviewer & Adversarial Critic**: `teamwork_reviewer` (`reviewer_lifecycle_protocol`)  
**Date**: 2026-11-01  
**Verdict**: **APPROVE**  

---

## 1. Executive Summary

This review independently examines the lifecycle overhaul implemented in `tasks/command_hall.py` to address the field freeze bug (300-second stall with 0 rewards claimed). The review evaluated protocol fidelity against official Lua game specs, constitution and safety compliance (`GEMINI.md`), adversarial stress resilience, test coverage, and code integrity.

Key findings:
1. **Root Cause Eradication**: The 300-second freeze was conclusively caused by three logic bugs in `tasks/command_hall.py`: an accumulator `has_active_marches = (total_marches > 0)` that permanently locked the loop, setting local status to `TASK_STATUE_PREPARE` without subsequent network sync, and a rigid 300-second loop timeout. These have been completely eliminated and replaced by dynamic march tracking (6.0–8.5s) and a 60-second safety timeout.
2. **Authoritative Protocol Alignment**: The implementation perfectly mirrors the official Lua client specs:
   - `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`): Correctly unpacks `rspdata.initData` and synchronizes `conn.init_data["commandHall"]` in memory.
   - `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`): Strictly enforces `commitType = task.type` and `index = task.index`, and only permits claiming when `statue == 3` (`TASK_STATUE_FINISH`) or when Type 1 Rebel Army Group satisfies `hurtHp >= rabelHp`.
   - `CMD 1007 / SubCMD 2` (`REQ_ADD_KINGDOM_QUEUE`): Sets `moveLineType = 15` (`moveLineTypeCommandHallNpc`) and `matrixType = 1` (`moveLineMatrixTypeTroop`) with the official nested payload envelope.
3. **Safety & Zero-Risk Compliance**:
   - 0-Network Pre-flight check on cold starts reads purely from live memory; `force_network=True` is restricted to post-march synchronization.
   - Strict Zero-Gold/Speedup invariant filters out all tasks requesting gold, speedups, or items.
   - Wall traps `801..825` are strictly excluded from both troop counting and march formation.
   - Gathering heroes (`1711`, `1717`, `1724`, `1733`) are excluded from combat marches.
4. **Empirical Test Suite**: 36 tests across 3 independent test suites (`test_command_hall_task.py`, `test_challenger_command_hall.py`, `test_cmd_hall_adversarial.py`) ran with 100% pass rate in 35.3s.
5. **Integrity Assessment**: No hardcoded test fixtures, facade mocks, or shortcut bypasses exist in `tasks/command_hall.py`.

---

## 2. Protocol Fidelity Audit

### 2.1 `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`)
- **Official Lua Spec**: `commandHallCtrl.lua:240-254` executes `serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_INIT)` and on `Err_None` invokes `self:setInitData(content.rspdata.initData, true)`.
- **Implementation in `tasks/command_hall.py` (lines 580–638)**:
  - In `_ensure_synced_data(force_network=False)`:
    - When `force_network=False`: Checks if `commandHall` is loaded in `self.conn.init_data` (0-Network pre-flight check). If present, returns immediately without network touch.
    - When `force_network=True`: Queries `CMD 2274 / SUBCMD 1` with human jitter (0.5s–0.9s).
    - Unpacks `rspdata.initData` robustly (supporting `rspdata.initData`, `res.data`, or direct dicts).
    - Updates `self.conn.init_data["commandHall"]` in-place and sets `self._is_synced = True`.
- **Fidelity Score**: **100% (Compliant)**.

### 2.2 `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`)
- **Official Lua Spec**: `commandHallCtrl.lua:370-393` and `Com_MainReward.lua:215` send `{commitType: task.type, index: task.index}` when `statue == gCommandHallTaskStatue.FINISH` (3).
- **Implementation in `tasks/command_hall.py` (lines 640–686 & 740–765)**:
  - `_claim_finished_tasks(hall_data)`:
    - Scans all extracted tasks.
    - Validates `status == TASK_STATUE_FINISH` (3) or (`commit_type == TASK_TYPE_REBEL_GROUP` and `rabel_hp > 0 and hurt_hp >= rabel_hp`).
    - Dispatches `CMD 2274 / SUBCMD 8` with `{"commitType": commit_type, "index": task_index}`.
    - Tracks claimed tasks in `self._claimed_tasks` and sets `task["statue"] = 0` locally to prevent duplicate requests.
  - `_handle_rebel_group_attack(hall_data)`:
    - When Type 1 Rebel Army Group is defeated (`hurt_hp >= rabel_hp` or `statue == 3`), sends `commitType = 1` and `index = task_index`.
    - Triggers `_handle_wave_progression_after_claim(hall_data, res)`, clearing attack/claim locks for the next wave.
- **Fidelity Score**: **100% (Compliant)**.

### 2.3 `CMD 1007 / SubCMD 2` (`REQ_ADD_KINGDOM_QUEUE`)
- **Official Lua Spec**: `queueTimeUtil.lua:327-333`, `mapDef.lua:395`, `mapDef.lua:411`, `worldMapFunction.lua:355, 645`.
  - `moveLineType = 15` (`moveLineTypeCommandHallNpc`).
  - `matrixType = 1` (`moveLineMatrixTypeTroop`).
  - Travel time capped to `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` seconds (`commandHallUtil.lua:310-318`).
- **Implementation in `tasks/command_hall.py` (lines 961–1004)**:
  - Constructs `march_payload` with top-level `moveLineType = 15`, `matrixType = 1`, and nested `data` dictionary mirroring the official client envelope.
  - After dispatch, `run()` executes dynamic tracking wait:
    `wait_sec = random.uniform(MARCH_DYNAMIC_WAIT_MIN, MARCH_DYNAMIC_WAIT_MAX)` (6.0s to 8.5s).
    This exactly matches Lua's 5s travel time + 1–2s server battle resolution.
  - Immediately following this wait, `_ensure_synced_data(force_network=True)` is called to refresh state from server, followed by instant reward claim.
- **Fidelity Score**: **100% (Compliant)**.

### 2.4 Task `statue` Lifecycle Management
- **Official Lua Spec**: `wholeDefine.lua:1371-1374`:
  - `PREPARE = 1`: Task pending or monster spawning.
  - `BEGIN = 2`: Task in progress / attackable.
  - `FINISH = 3`: Task completed, ready for reward claiming.
- **Implementation in `tasks/command_hall.py`**:
  - `statue == 3` is strictly required before issuing reward claim.
  - When march is sent, local memory marks `task["statue"] = 1` (`TASK_STATUE_PREPARE`), preventing immediate re-dispatch.
  - Once the 6.0–8.5s dynamic wait elapses, force sync fetches the authoritative `statue == 3` from the server, and `_claim_finished_tasks` claims the reward.
  - `is_task_actionable(t)` treats `statue == 1` as non-actionable, ensuring that if a march was sent and network drops, the bot cleanly exits rather than hanging.
- **Fidelity Score**: **100% (Compliant)**.

---

## 3. Safety & Constitution Compliance (`GEMINI.md`)

| Constraint | Requirement | Implementation Evidence | Status |
|---|---|---|:---:|
| **0-Network Pre-flight** | No unnecessary queries; check `conn.init_data` first | `tasks/command_hall.py:586-600`: If `commandHall` exists in memory, `_ensure_synced_data()` returns cached dict with 0 network calls. | **PASS** |
| **0-Gold / 0-Speedup Invariant** | Strictly prohibit gold, speedup, or item consumption | `tasks/command_hall.py:154-196`: `_is_costly_task()` scans `consumeGold`, `gold`, `consumeSpeedup`, `speedup`, `consumeItem`, `items` (including string and positive int/list checks). | **PASS** |
| **Hero Exclusion** | Strictly exclude gathering heroes from combat marches | `tasks/command_hall.py:84-86, 274-332`: `GATHERING_HERO_IDS = {1711, 1717, 1724, 1733}` strictly excluded. Only `state in (1, 5)` and unqueued heroes selected. | **PASS** |
| **Wall Trap Exclusion** | Exclude wall traps `801..825` from troop calculations | `tasks/command_hall.py:215-230, 357-369`: Both `available_troops_count` and `_select_march_troops` enforce `uid < 800`, strictly filtering out wall traps. | **PASS** |
| **Logging Prefix** | Consistent `[CommandHall]` logging | Every log statement in `tasks/command_hall.py` is prefixed with `[CommandHall]` or `🏰 [CommandHall]`. | **PASS** |
| **Fault Isolation** | Catch exceptions, prevent loop crash | `tasks/command_hall.py:1030-1170`: Full `try/except Exception` block returns `TaskResult.fail()` cleanly without crashing `bot_manager`. | **PASS** |
| **Tools Directory Policy** | All test tools located inside `tools/` | All test scripts reside strictly in `tools/` (`test_command_hall_task.py`, `test_challenger_command_hall.py`, `test_cmd_hall_adversarial.py`). | **PASS** |

---

## 4. Adversarial Stress-Testing & Edge Cases

### Challenge 1: The Zero-Troop & Zero-Stamina Blocker
- **Scenario**: Castle has 0 combat troops (or only wall traps 801..825) and stamina < 5.
- **Attack Vector**: Previous bot would attempt march or enter infinite wait.
- **Behavior Observed**: `_handle_march_tasks` detects `troops <= 0 or stamina < 5` and sets `blocked_on_march = True`. The bot finishes all instant zero-army tasks (dialogue, rescue, snipe), claims rewards, and exits cleanly with exit reason `"تعذر إرسال فيلق على الخريطة (تم إتمام باقي المهام والخروج بأمان)"` in under 1 second.
- **Assessment**: **Robust**.

### Challenge 2: Multi-Wave Wave Progression Without Stall
- **Scenario**: Defeating Wave 1 Rebel Group instantly advances `armyGroupID` to 2.
- **Attack Vector**: Bot might terminate early or get trapped by stale `_attacked_rebel_groups` or `_claimed_tasks` sets.
- **Behavior Observed**: `_handle_wave_progression_after_claim()` updates `hall_data` and live memory with Wave 2, clears `_attacked_rebel_groups` and `_claimed_tasks`. The `run()` loop continues seamlessly to execute Wave 2 subtasks in the same session without delay.
- **Assessment**: **Robust**.

### Challenge 3: Network Drop During Dynamic March Wait
- **Scenario**: Connection drops or server returns `None` during post-march `_ensure_synced_data(force_network=True)`.
- **Attack Vector**: Could crash on `None` or loop indefinitely waiting for `statue == 3`.
- **Behavior Observed**: `safe_query` returns `None`. `_ensure_synced_data` falls back to existing `hall_data`. `is_task_actionable` returns `False` for `statue == 1` (`PREPARE`), detecting `has_pending_actions == False`, and terminates cleanly with exit reason `"تم إنجاز كافة المهام المتاحة بالكامل"`.
- **Assessment**: **Robust**.

### Challenge 4: Corrupted or Malformed Data in Live Memory
- **Scenario**: Castle data contains string numbers (`"5000"`), float strings (`"10.0"`), `None`, `False`, or empty lists in numeric fields.
- **Attack Vector**: `TypeError` or `ValueError` in arithmetic or comparisons.
- **Behavior Observed**: Handled uniformly across all helper functions by `_safe_int(v, default=0)`, completely neutralizing casting crashes.
- **Assessment**: **Robust**.

---

## 5. Independent Test Suite Execution

Executed in workspace terminal:
```powershell
python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py
```

### Results:
```text
Ran 36 tests in 35.347s

OK
```
- `tools/test_command_hall_task.py`: 12/12 PASSED (including dynamic tracking test 11 and wave progression test 12).
- `tools/test_challenger_command_hall.py`: 11/11 PASSED (including loop max duration test 07, march tracking test 10, multi-wave test 11).
- `tools/test_cmd_hall_adversarial.py`: 13/13 PASSED (including 30 cost traps combinations, resource exhaustion, and memory corruption).

### Database Verification:
Inspected `database/castles.db` (`castle_states` table):
- Total castles: 4
- `command_hall` configured in all 4 castles: **100% migrated (`True`)**.

---

## 6. Review Verdict

**Verdict**: **`APPROVE`**

The implementation is verified to be accurate, fully aligned with official client Lua source code, strictly compliant with `GEMINI.md` safety constraints, resilient against adversarial conditions, and backed by a comprehensive, passing test suite.
