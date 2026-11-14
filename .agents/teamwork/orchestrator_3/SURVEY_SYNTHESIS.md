# Survey Synthesis: Command Hall (مهام القيادة في النشاط اليومي)

## Executive Summary
Milestone 1 Survey is successfully complete. Findings from `explorer_cmd_hall_mem_2`, `explorer_cmd_hall_ui_3`, and `spec_miner_cmd_hall_1` have been synthesized. The specifications, network protocols, subtask types, memory structures, 6-stage pipeline, and asset icon are fully decoded and verified.

---

## 1. Consensus Findings

### A. Game Protocol & Network Commands
- **Module ID**: `CMD_COMMAND_HALL_MODULE = "2274"` (`cmdDef.lua:3242`)
- **Sub-Commands**:
  - `REQ_COMMAND_HALL_INIT = "1"`: Synchronize data and populate command hall state (`conn.init_data['commandHall']`).
  - `REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"`: Upgrade command hall level and collect level-up rewards when `curExp >= needExp`.
  - `REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"`: Power level progression.
  - `REQ_COMMAND_HALL_FINISH_TASK = "5"`: Finish subtask payload: `{"index": index}` (executes instant zero-army tasks).
  - `REQ_COMMAND_HALL_COMMIT_TASK = "8"`: Claim completed task rewards payload: `{"commitType": commitType, "index": index}` (claims tasks with `statue == 3`).

### B. Subtask Types & Execution Logic
Defined in `wholeDefine.lua:1364-1374` and decoded in `commandhall_strings_decoded.txt`:
1. `REBEL_ARMY_GROUP_TASK` (فيلق الغزاة): Scheduled group event march.
2. `REBEL_ARMY_PIONEER_TASK` (طليعة الغزاة): Requires army/march.
3. `DIALOGUE_TASK` (المعلومات العسكرية / حوار): Instant / zero-army. Triggered via REQ 5.
4. `RESCUE_TASK` (انقاذ القرويين): Instant / zero-army. Triggered via REQ 5.
5. `BATTLE_TASK` (فريق الغزاة / معركة): Requires army/march.
6. `SNIPE_HUNTER_TASK` (القناص الصامت): Mini-game / zero-army. Triggered via REQ 5.

### C. Subtask Statuses
1. `PREPARE (1)`: Preparing.
2. `BEGIN (2)`: Ready for execution. (Types 3, 4, 6 executed via REQ 5).
3. `FINISH (3)`: Completed, ready to claim rewards via REQ 8.

### D. 0-Network Troop & March Pre-flight Check
- Check available marches in `queueCtrl` (or `conn.init_data['queueCtrl']`).
- Check garrison soldiers in `armyCtrl.totalArmy`.
- If marches == 0 or soldiers == 0: Execute all instant zero-army tasks (3, 4, 6), claim all finished rewards (status 3), and cleanly exit:
  `"تتوقف وتخرج بعد إتمام باقي المهام الفرعية إذا اصطدمت بمتطلب إرسال فيلق على الخريطة ولم تكن هناك فيالق متاحة."`

### E. Zero-Gold & Resource Audit
- All tasks consume ONLY 0 or 5 Lord Stamina (SP). NO gold or speedups are required.
- Stamina check: inspect live memory `lordInfoCtrl.power` / stamina. If stamina < 5, skip task immediately without buying stamina (Zero-Gold).
- Marching troops must never use speedups (`REQ_SPEED_QUEUE`).
- Enforce human delay jitter `random.uniform(0.5, 0.9)` between queries.

### E2. March Details
- For marching to Command Hall NPC (Types 2 & 5), uses `CMD 1007 SubCMD 2` with `moveLineType = 15` (`moveLineTypeCommandHallNpc`), `matrixType = 1` (`moveLineMatrixTypeTroop`), target `(obj.x, obj.y)`.
- If no march queues available (`remain_queues == 0`) or stamina < 5, complete all available non-army instant subtasks (Types 3, 4, 6), claim all completed rewards, then exit cleanly.

### F. 5-Minute Continuous Loop
- `start_time = time.time()`
- `while (time.time() - start_time) < 300:`
- Poll tasks, claim finished rewards, execute available instant tasks, dispatch march if available, sleep `random.uniform(4.0, 7.0)` seconds per cycle. Clean exit on march block when no other tasks remain.

### G. Official Daily Quest Icon & Asset
- Quest ID in Daily Activity: `4100033` (`daily_reward_data.lua:162-166`) named `"commandhall_text_82"` ("مهام القيادة").
- Sprite extracted from `tools/mainuiused_0_atlas.png` at `(x=1357, y=1212, w=71, h=71)`. Verified in `tools/test_crop1.png` (transparent RGBA).
- Destination: `dashboard/public/images/daily/command_hall.png` (and `dashboard/dist/images/daily/command_hall.png`) with emoji fallback `📜`.

### H. 6-Stage Pipeline Integration Plan
1. **Backend Task**: `tasks/command_hall.py` (`CommandHallTask` inheriting from `BaseTask`), exported in `tasks/__init__.py`.
2. **Bot Manager**: `bot_manager.py` registers `CommandHallTask` in `REGISTERED_TASKS` before `DailyQuestTask`, adds `DEFAULT_BOT_CONFIG["tasks"]["command_hall"] = {"enabled": False}`, and adds to `reload_config_from_db()`.
3. **API Whitelist**: `api_server.py` whitelists `command_hall: Optional[SimpleToggleConfig] = None` in `CastleConfigModel`.
4. **Database Migration**: `tools/migrate_command_hall_config.py` updates all castles in `database/castles.db` with `{"enabled": False}` and asserts 100% presence.
5. **Frontend Defaults**: `dashboard/src/types/index.ts` and `dashboard/src/hooks/useCastles.ts` add `command_hall` to `CastleConfig` / `TaskConfig`.
6. **Frontend UI Dual-Save & Locales**: `dashboard/src/components/accounts/TaskTabContent.tsx` renders toggle in `tab === 'daily'` with icon and connects both `performSave()` and `handleSave()`. Trilingual keys in `ar.json`, `en.json`, `tr.json`.
