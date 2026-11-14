# Changes Report — Milestone 2: Forge Equipment Error 22002 Fix (R2)

**Worker:** Worker 2 (Forge Fix Worker)  
**Target File:** `e:\intqam-sultan\tasks\forge_equipment.py`  
**Date:** 2026-11-01T07:02:00Z  

---

## 1. Overview of Changes
Resolved the root cause of Server Error 22002 (`Err_IS_FORGING_EQUIPMENT`) in `tasks/forge_equipment.py`. Prior to this fix, when forging completed offline or between bot runs, the game server removed queue `1229` from `queueCtrl` while preserving the completed piece in `conn.init_data['equipmentCtrl']['fe']`. The old code calculated `finish_t = 0` when queue `1229` was absent, mistakenly skipped claiming the completed equipment, and attempted to forge a new piece, triggering server error 22002.

---

## 2. Detailed Code Modifications in `tasks/forge_equipment.py`

### 1) Blacksmith Building & Bag Pre-flight Helpers
- **Added `_get_blacksmith_info(self) -> Tuple[int, bool, bool]`**:
  Directly inspects `cityCtrl.blist` in live memory (0-Network) to detect:
  - Building level (`lv`)
  - Building presence (`exists`)
  - Upgrade in progress state (`is_upgrading = state != "0"`)
- **Updated `_get_blacksmith_level`**:
  Leverages `_get_blacksmith_info` and falls back safely to `castle_level`.
- **Enhanced `_get_item_count_in_bag` and `_ensure_steel_balance`**:
  Added support for both `backpackCtrl` and `itemCtrl` / `bagCtrl`, ensuring compatibility with all memory representations of player inventory.

### 2) Pre-flight Check in `can_run()` (0-Network)
- Added 0-network check for active forging (`queueCtrl.1229` with `start + total > now` or `fe.endTime > now`).
- If forging is in progress, exits immediately with `False, "Blacksmith is busy forging (0-Network) (remaining: ...s)"`.
- If `fe` has a finished piece waiting to be claimed (`endTime == 0` or `endTime <= now`), allows `can_run()` to return `True` so `run()` can claim it.

### 3) Root Cause Fix & Equipment Claiming in `run()`
- **Active Forging Check**:
  Detects if forging is actively in progress; logs remaining seconds and skips with 0-network calls.
- **Finished Piece Detection (`fe` or finished queue `1229`)**:
  Inspects `fe` in `equipmentCtrl` regardless of whether queue `1229` exists.
  When a finished piece is found (`fe_epid > 0`), sends claim command:
  ```python
  CMD_EQUIPMENT_MODULE ("1047"), REQ_GET_EQUIPMENT ("2"), {"epid": fe_epid, "isDirectGet": "1"}
  ```
- **In-Memory State Synchronization on Claim**:
  - Removes `fe` from `equipmentCtrl`: `eq_ctrl.pop("fe", None)`
  - Pops queue `1229` from `queueCtrl`: `queue_ctrl.pop("1229", None)`
  - Appends claimed piece to `equipmentCtrl['equipment_array']` with `wear=0` and `endTime=0`
  - Records daily quest completion:
    - `everydayTaskCtrl.eventInfo['4100009'] = 1`
    - `everydayTaskCtrl.eventInfo['9'] = 1`
    - `questCtrl.point_finish_list.append(4100009)`
  - Returns `TaskResult.ok(...)` with 0 resource cost and terminates without attempting another forge today.

### 4) Crafting 0-Network Pre-flight Validations
When the smithy is empty (no active forge and no unharvested piece):
- **Queue Vacancy**: Verifies neither queue `1229` nor `fe` exists.
- **Building Level & State**: Validates blacksmith building exists, level >= 1, and is not upgrading (`state == "0"`).
- **Lord Level Ceiling**: Computes `max_allowed_lvl = max(1, min(blacksmith_lvl, lord_lvl, castle_lvl))` to eliminate Error 22006 (`Err_EQUIPMENT_LORD_LV_NOT_ENOUGH`).
- **Bag Capacity Guard**: Verifies `len(equipment_array) < 200` to prevent Error 22012 (`Err_EQUIPMENT_NUM_MAX`).
- **Materials & Steel Check**: Verifies inventory materials and steel before submitting crafting requests.

### 5) Crafting In-Memory State Synchronization
Upon crafting success (`err == "0"`):
- Decrements consumed materials from `backpackCtrl` and `itemCtrl`.
- Decrements consumed steel from `cityCtrl.reslist["1006"]`.
- Removes base equipment from `equipment_array` if `base_epid > 0`.
- Injects new queue into `queueCtrl["1229"]` with `qtype="1229"`, `starttime`, `totaltime`, `ottime`, and `data`.
- Injects `fe` into `equipmentCtrl`.
- Updates `everydayTaskCtrl.eventInfo` and `questCtrl.point_finish_list`.

---

## 3. Verification Summary
1. **Live Account Test on `beetoo2@hotmail.com`**:
   - Before fix: Failed with `رفض السيرفر طلب تصنيع العتاد (كود الخطأ: 22002)`.
   - After fix: Successfully claimed unharvested piece (`EPID: 95, EID: 6100501`) via CMD 1047 SubCMD 2 with `isDirectGet="1"`.
   - Subsequent test: Skipped cleanly in 0.03 ms (`Daily quest 4100009 already completed (0-Network)`).
2. **Live Account Test on `beetoo1@hotmail.com` and `beetoo3@hotmail.com`**:
   - Pre-flight in 0.02 ms safely skipped completed daily quests with 0-network queries.
3. **Comprehensive Edge Cases Test Suite**:
   - Case 1 (Claim unharvested `fe` with no queue): PASSED.
   - Case 2 (Active forging queue busy skip): PASSED.
   - Case 3 (Blacksmith upgrading skip): PASSED.
   - Case 4 (Equipment bag full skip): PASSED.
   - Case 5 (Clean forge with in-memory sync): PASSED.
