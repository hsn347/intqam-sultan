## 2026-10-31T11:45:45Z
You are Worker 1: Backend Task & Bot Manager Worker.
Your Working Directory: e:\intqam-sultan\.agents\teamwork\worker_backend_m1\
Original Request Reference: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Project Reference: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Survey Findings Reference:
- e:\intqam-sultan\.agents\teamwork\explorer_survey_1\handoff.md
- e:\intqam-sultan\.agents\teamwork\explorer_survey_2\handoff.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Write Ownership (Strict Boundary):
You own EXCLUSIVELY:
- `tasks/forge_equipment.py`
- `tasks/__init__.py`
- `bot_manager.py`
Do NOT touch any other files in the project.

Scope of Work (Milestone 1):
1. Read ORIGINAL_REQUEST.md, PROJECT.md, and the two survey handoff reports carefully.
2. Build `ForgeEquipmentTask` in `tasks/forge_equipment.py` inheriting strictly from `BaseTask`:
   - Task property: `name = "forge_equipment"`.
   - 0-Network Pre-flight:
     * Check `everydayTaskCtrl.eventInfo` for key `"4100009"` or `"9"` and `questCtrl.point_finish_list`. If completed (>=1), return `TaskResult.skip("Daily quest 4100009 already completed (0-Network)")` immediately without any network calls.
     * Check `equipmentCtrl.equipment_array`:
       - If any item has `endTime > 0 and endTime <= int(time.time())`: collect it via official command `CMD 1047 / SubCMD 2` with `{"epid": item["epid"]}`. Mark `item["endTime"] = 0` and `eventInfo["4100009"] = 1` in local live memory, and return `TaskResult.success("Collected finished forged equipment", ...)`!
       - If any item has `endTime > int(time.time())`: blacksmith is busy forging. Return `TaskResult.skip("Blacksmith is busy forging (0-Network)")` immediately without any network calls.
   - Highest Possible Tier Forge Logic:
     * Support all 6 categories: `weapon` (61), `clothes` (62), `helmet` (63), `trousers` (64), `shoes` (65), `ring` (66).
     * Sort recipes descending from Lv.110 down to Lv.1.
     * Check building/castle level, bag base item for tiers >= 5 (`wear == 0 and endTime == 0`), available materials in `backpackCtrl` using lowest quality available first (white -> green -> blue), and steel in `cityCtrl.reslist["1006"]`.
     * Automatically downgrade recipe tier until requirements are met, guaranteed to succeed at Level 1 (requires only 100 steel, 2 basic white materials, and `mainMaterialID = 0`).
     * Send forge request `CMD 1047 / SubCMD 1` with `{"eid": recipe_eid, "materialArray": chosen_materials, "mainMaterialID": base_epid}`.
     * In-memory live state sync: deduct materials from `backpackCtrl`, deduct steel from `cityCtrl.reslist["1006"]`, add new equipment piece to `equipment_array` with `endTime = int(time.time()) + costTime`, and mark `eventInfo["4100009"] = 1`.
3. Export `ForgeEquipmentTask` in `tasks/__init__.py`.
4. Register task in `bot_manager.py`:
   - Import `ForgeEquipmentTask` in `bot_manager.py`.
   - Add to `REGISTERED_TASKS`.
   - Add default configuration to `DEFAULT_BOT_CONFIG["tasks"]`: `"forge_equipment": {"enabled": False, "category": "weapon"}`.
   - Update both hardcoded tuples in `reload_config_from_db()` (around lines 237 and 245) to include `"forge_equipment"`.
5. Run build and test checks:
   - Verify Python syntax, importability, class instantiation with mock/dummy conn, and ensure no regressions.
6. Write a complete handoff report to: `e:\intqam-sultan\.agents\teamwork\worker_backend_m1\handoff.md`.
Follow Handoff Protocol: Observation, Logic Chain, Caveats, Conclusion, Verification Method.
When done, send a message to your orchestrator (parent).
