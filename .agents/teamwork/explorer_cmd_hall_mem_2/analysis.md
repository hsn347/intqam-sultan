# Technical Exploration & Architecture Analysis: Command Hall (`tasks/command_hall.py`)

## 1. Executive Summary & Objective

This investigation analyzes the game source code (`game_file/`), live memory dumps (`docs/beetoo1_live_memory.json`, `docs/beetoo3_live_memory.json`), and existing task patterns (`tasks/daily_quest.py`, `tasks/base_task.py`, `tasks/building.py`) to formulate a battle-tested, zero-ban implementation blueprint for the Command Hall task (`tasks/command_hall.py`).

The user's authoritative requirement specifies:
1. Full analysis of Command Hall subtasks, IDs, and conditions from game source code.
2. Continuous execution for 5 minutes (`300` seconds) per castle cycle.
3. Filtering out any subtasks requiring gold or speedups (0-Gold, 0-Speedup).
4. Safe march handling: 0-network march & troop check via `queueCtrl` / `armyCtrl`. If a map march is required but no marches are available, finish all other available subtasks and exit cleanly.
5. Strict adherence to GEMINI.md rules: 0-network pre-flight checks, human jitter (`0.5s - 0.9s`), in-memory state synchronization, and strict prohibition on modifying `core/game_client.py`.
6. Full 6-stage pipeline compliance across backend, database, and trilingual UI.

---

## 2. Live Memory & Controller Examination

### 2.1 Live Memory Dumps Inspection (`beetoo1_live_memory.json` & `beetoo3_live_memory.json`)
Direct programmatic inspection of `beetoo1_live_memory.json` and `beetoo3_live_memory.json` revealed:
- Root keys count: `277` controllers.
- Related controllers present in initial login dump:
  - `everydayTaskCtrl`: Handles daily activity points and chests 1..8. Contains `eventInfo` and `normalRecord`. Subtask `4100033` ("قاعة الأوامر / قاعة القيادة") gives 10 points towards the daily 500 milestone.
  - `queueCtrl`: Contains internal building and production queues (e.g. `1202` hospital, `1203` chariot, `1204` stables, `1205` range, `1206` barracks, `1212` research). Active map march queues are synced into `queueCtrl["queues"]` via `NOTIFY_LOCAL_QUEUE_SYNC` in `core/game_client.py:1438-1440`.
  - `armyCtrl`: Contains castle garrison troops (`totalArmy`, `compileArmy`, `woundedArmy`, `trainArmy`, `fightingArmy`).
  - `lordInfoCtrl`: Prince profile, level, gold, VIP.
  - `bagCtrl` / `backpackCtrl`: Inventory items.
- Root controllers NOT present in initial login dump:
  - `commandHall` / `commandHallCtrl` is **not preloaded in the initial login dump**.
  - In the official client (`game_file/src/app/module/commandHall/commandHallCtrl.lua:25`), `commandHallCtrl:EnterGame()` invokes `self:reqInit()`, which sends CMD `"2274"`, SUBCMD `"1"` to fetch `initData`.
  - Therefore, `CommandHallTask` must implement a 0-Network pre-flight check that inspects `conn.init_data.get("commandHall")`. If missing or expired, it executes an initial safe sync query (`CMD 2274 / SUBCMD 1`) and caches the result into `conn.init_data["commandHall"]`.

---

## 3. Game Source Code Analysis: Command Hall Internals

### 3.1 Network Protocol Defintions
From `game_file/src/app/constdef/cmdDef.lua:3242-3254`:
```lua
CMD_COMMAND_HALL_MODULE             = "2274"
REQ_COMMAND_HALL_INIT               = "1"   -- Sync command hall data
REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"   -- Upgrade command hall level (claims level rewards)
REQ_COMMAND_HALL_UPGRADE_POWER_LV   = "3"   -- Upgrade power level
REQ_COMMAND_HALL_FINISH_GUIDE       = "4"   -- Finish tutorial guide
REQ_COMMAND_HALL_FINISH_TASK        = "5"   -- Instant finish for dialogue/rescue/snipe tasks
REQ_COMMAND_HALL_SET_DEFEND         = "6"   -- Set defense troops
REQ_COMMAND_HALL_ATTACK_ARMY_GROUP  = "7"   -- Attack rebel army group
REQ_COMMAND_HALL_COMMIT_TASK        = "8"   -- Claim rewards for completed tasks (statue == 3)
REQ_COMMAND_HALL_REFRESH_POS        = "9"   -- Refresh map NPC position
REQ_COMMAND_HALL_REFRESH_POS2       = "10"  -- Refresh map NPC position 2
REQ_COMMAND_HALL_GET_BATTLE_INFO    = "11"  -- Battle report info
REQ_COMMAND_HALL_GET_RANK_INFO      = "12"  -- Ranking info
```

### 3.2 Subtask Types (`gCommandHallTaskType`)
From `game_file/src/app/constdef/wholeDefine.lua:1364-1370`:
```lua
gCommandHallTaskType = {
    REBEL_ARMY_GROUP_TASK   = 1,  -- جيش المتمردين الجماعي / الهجوم الجماعي
    REBEL_ARMY_PIONEER_TASK = 2,  -- طليعة جيش المتمردين
    DIALOGUE_TASK           = 3,  -- مهمة الحوار (مهمة فورية آمنة)
    RESCUE_TASK             = 4,  -- مهمة الإنقاذ (مهمة فورية آمنة)
    BATTLE_TASK             = 5,  -- مهمة المعركة / القتال (تتطلب فيلق على الخريطة)
    SNIPE_HUNTER_TASK       = 6,  -- مهمة القنص / الصياد (مهمة لعبة مصغرة فورية)
}
```

### 3.3 Task Status Lifecycle (`gCommandHallTaskStatue`)
From `game_file/src/app/constdef/wholeDefine.lua:1371-1374`:
```lua
gCommandHallTaskStatue = {
    PREPARE = 1,  -- قيد الإعداد / غير جاهزة
    BEGIN   = 2,  -- جاهزة للتنفيذ
    FINISH  = 3,  -- مكتملة وبانتظار استلام المكافآت
}
```

### 3.4 Task Execution & Claiming Mechanics
From `game_file/src/app/module/commandHall/commandHallCtrl.lua` and `CommandHallMainPanel.lua`:
1. **Instant / Zero-March Subtasks (Types 3, 4, 6):**
   - In `CommandHallMainPanel.lua:584-593`:
     - `DIALOGUE_TASK` (3): Completed in `CommandHallTalkPanel.lua:66` by calling `commandHallCtrl:reqFinishTask(task.index)`.
     - `RESCUE_TASK` (4): Completed directly by calling `commandHallCtrl:reqFinishTask(task.index)`.
     - `SNIPE_HUNTER_TASK` (6): Completed upon winning mini-game by calling `commandHallCtrl:reqFinishTask(task.index)`.
   - In all three types, the official client sends:
     `safe_query("2274", "5", {"index": task["index"]})`
     No world map march is dispatched! No troops are consumed!
2. **March-Dependent Subtasks (Types 2, 5):**
   - `REBEL_ARMY_PIONEER_TASK` (2) and `BATTLE_TASK` (5) require deploying troops on the map.
   - In `worldMapCommandHallNpcViewPanel.lua:111`, `commandHallUtil.checkTaskTypeNeedArmy(taskType)` returns `True` for battle tasks.
   - If available marches == 0 or garrison troops == 0, these cannot be launched.
3. **Reward Claiming (All Tasks):**
   - In `CommandHallMainPanel.lua:306-307`:
     ```lua
     if task.statue == gCommandHallTaskStatue.FINISH then
         commandHallCtrl:reqCommitTask(task.type, task.index)
     ```
   - When a task reaches `statue == 3` (`FINISH`), calling:
     `safe_query("2274", "8", {"commitType": task["type"], "index": task["index"]})`
     instantly collects the rewards, adds items/gold, and triggers the next task or refreshes the slot.
4. **Command Hall Level Upgrade:**
   - In `commandHallCtrl.lua:219-230`:
     If `curExp >= needExp`: `getLvReceiveStatus()` returns `True`.
     Calling `safe_query("2274", "2", {})` upgrades the Command Hall level and claims generous level-up chests!

### 3.5 Official UI Icon
From `game_file/src/app/localtb/config_client/daily_reward_data.lua:162-166`:
- `ID = 4100033`
- `name = "commandhall_text_82"` ("قاعة القيادة")
- `image = "img_commandhall_entrance.png"`
- Matching dashboard asset: `dashboard/public/images/daily/` can use `812033.png` or reference the official command hall icon.

---

## 4. 0-Network March & Troop Availability Check

To satisfy the ban prevention protocol (0-Network Pre-flight check before touching the server), the bot must determine if marches and troops are available using purely in-memory data:

### 4.1 March Queue Availability
In `core/game_client.py:1438-1440`:
```python
if notify_id == 'NOTIFY_LOCAL_QUEUE_SYNC' and isinstance(notify_data, list):
    self.local_queues = notify_data
    self.init_data['queueCtrl'] = {"queues": notify_data}
```
In `tasks/base_task.py:394-401`:
```python
@property
def available_marches(self) -> int:
    queue_ctrl = self.get_ctrl("queueCtrl")
    queues = queue_ctrl.get("queues", []) if isinstance(queue_ctrl, dict) else []
    active_marches = sum(1 for q in queues if isinstance(q, dict) and q.get("type") == 1)
    max_marches = max(2, int(self.config.get("max_marches", 2)))
    return max(0, max_marches - active_marches)
```
- Active marches on the world map have `type == 1`.
- If `self.available_marches <= 0`: **ZERO marches available**.

### 4.2 Troop Garrison Availability
In `conn.init_data["armyCtrl"]`:
- `total_army = self.get_ctrl("armyCtrl").get("totalArmy", {})`
- Sum of available soldiers: `sum(int(v) for v in total_army.values() if str(v).isdigit())`.
- If sum is `0`: **ZERO troops available** in the castle.

### 4.3 Safe Exit Condition
When a subtask is of Type 2 (`PIONEER_TASK`) or Type 5 (`BATTLE_TASK`):
If `self.available_marches <= 0` or total garrison troops == 0:
1. Finish all pending zero-march tasks (Types 3, 4, 6).
2. Claim all ready rewards (`statue == 3`).
3. Check and claim Command Hall Level upgrade.
4. Log clean message:
   `⚠️ [قاعة القيادة] تعذر إرسال فيلق على الخريطة لعدم وجود فيالق شاغرة — تم إنجاز كافة المهام الفرعية الأخرى والخروج بأمان.`
5. Exit task cycle gracefully without errors.

---

## 5. Architectural Blueprint for `tasks/command_hall.py`

### 5.1 Class Specification
```python
# -*- coding: utf-8 -*-
"""
tasks/command_hall.py — مهمة قاعة القيادة بالنشاط اليومي (CommandHallTask)
══════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. تعمل ضمن دورة النشاط اليومي وتمنح نقاط المهمة 4100033.
  2. فحص مسبق كامل من الذاكرة الحية (0-Network Pre-flight).
  3. استعلام مزامنة أولي آمن (CMD 2274 / SUBCMD 1) عند غياب البيانات بالذاكرة.
  4. دورة عمل متواصلة لمدة 5 دقائق (300 ثانية) مع فواصل بشرية (0.5s - 0.9s).
  5. استلام الجوائز المكتملة فوراً (CMD 2274 / SUBCMD 8).
  6. ترقية مستوى قاعة القيادة التلقائي واستلام جوائز الترقية (CMD 2274 / SUBCMD 2).
  7. تصفية صارمة لمنع صرف الذهب أو التسريعات (0-Gold, 0-Speedup).
  8. تنفيذ المهام الفورية المجانية (حوار 3، إنقاذ 4، قنص 6) عبر CMD 2274 / SUBCMD 5.
  9. فحص شاغرية الفيالق 0-Network؛ عند عدم وجود فيالق، إكمال باقي المهام والخروج بأمان.
"""

from __future__ import annotations
import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# كود وحدة الأوامر الرسمية لقاعة القيادة
CMD_COMMAND_HALL_MODULE = "2274"
REQ_COMMAND_HALL_INIT = "1"
REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"
REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"
REQ_COMMAND_HALL_FINISH_TASK = "5"
REQ_COMMAND_HALL_COMMIT_TASK = "8"

# أنواع المهام الفرعية
TASK_TYPE_REBEL_GROUP = 1    # جيش المتمردين الجماعي
TASK_TYPE_REBEL_PIONEER = 2  # طليعة جيش المتمردين
TASK_TYPE_DIALOGUE = 3       # مهمة الحوار (فورية)
TASK_TYPE_RESCUE = 4         # مهمة الإنقاذ (فورية)
TASK_TYPE_BATTLE = 5         # مهمة المعركة (تتطلب فيلق)
TASK_TYPE_SNIPE = 6          # مهمة القنص (فورية)

# حالات المهام
TASK_STATUE_PREPARE = 1
TASK_STATUE_BEGIN = 2
TASK_STATUE_FINISH = 3

LOOP_MAX_DURATION_SECONDS = 300  # 5 دقائق متواصلة
```

### 5.2 Method Structure
1. `is_active -> bool`:
   Reads `self.config.get("enabled", True)`.
2. `async def _ensure_synced_data(self) -> Optional[Dict[str, Any]]`:
   Checks `self.get_ctrl("commandHall")`. If missing, queries `CMD 2274 / SUBCMD 1`, caches in `conn.init_data["commandHall"]`.
3. `async def _claim_finished_tasks(self, hall_data: Dict[str, Any]) -> int`:
   Scans `taskList` for `statue == 3`. Sends `CMD 2274 / SUBCMD 8` for each with human jitter. Updates in-memory state.
4. `async def _check_and_upgrade_level(self, hall_data: Dict[str, Any]) -> bool`:
   Checks `commandExp >= needExp`. If eligible, sends `CMD 2274 / SUBCMD 2`.
5. `async def _execute_subtasks(self, hall_data: Dict[str, Any]) -> Tuple[int, bool]`:
   - Returns `(executed_count, blocked_on_march)`.
   - Runs safe zero-march tasks first (Types 3, 4, 6) using `safe_query(CMD 2274, SUBCMD 5, {"index": task["index"]})`.
   - Evaluates march-dependent tasks (Types 2, 5). If `self.available_marches <= 0`: records `blocked_on_march = True`.
6. `async def run(self) -> TaskResult`:
   Manages the 5-minute continuous loop:
   - Loop starts at `t0 = time.time()`.
   - Iterates while `time.time() - t0 < 300`.
   - Executes claim -> upgrade -> subtasks.
   - If blocked on march and no other tasks can run, breaks and logs clean exit.
   - Sleeps `4.0s - 8.0s` between iterations with jitter.
   - Returns comprehensive summary in `TaskResult.ok(...)`.

---

## 6. Review & Confirmation of `core/game_client.py` Constraint

- Inspected `core/game_client.py` (1826 lines).
- Confirmed that `RosClient` handles `query(cmd, subcmd, data)` which safely sends CMD `"2274"` packets without requiring any modification.
- Confirmed that `conn.init_data` already caches dynamic responses and handles `NOTIFY_LOCAL_QUEUE_SYNC`.
- **Conclusion**: `core/game_client.py` strictly complies with the user rule and **MUST NOT BE MODIFIED**.

---

## 7. The 6-Stage Pipeline Mapping

| Stage | Target File | Planned Changes |
| :--- | :--- | :--- |
| **1. Backend Task** | `tasks/command_hall.py` & `tasks/__init__.py` | Implement `CommandHallTask` and export in `tasks/__init__.py`. |
| **2. Bot Manager** | `bot_manager.py` | Add `CommandHallTask` to `REGISTERED_TASKS` (placed before `DailyQuestTask`), `DEFAULT_BOT_CONFIG["tasks"]["command_hall"] = {"enabled": True}`, and update `reload_config_from_db()`. |
| **3. API Whitelist** | `api_server.py` | Add `command_hall: Optional[SimpleToggleConfig] = None` in `CastleConfigModel`. |
| **4. Database Migration** | `database/castles.db` | Execute migration script to populate `"command_hall": {"enabled": True}` in `config` column of all castles. |
| **5. Frontend Defaults** | `dashboard/src/types/index.ts` & `dashboard/src/hooks/useCastles.ts` | Add `command_hall?: BaseTaskConfig` to types and default config. |
| **6. Frontend UI & Dual-Save** | `dashboard/src/components/accounts/TaskTabContent.tsx` & `locales/*.json` | Add toggle in daily tasks section with icon, dual-save support in `performSave()` and `handleSave()`, and trilingual localization (`ar.json`, `en.json`, `tr.json`). |
