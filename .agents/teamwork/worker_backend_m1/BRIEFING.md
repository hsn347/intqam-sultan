# BRIEFING — 2026-10-31T12:03:00Z

## Mission
Implement ForgeEquipmentTask in tasks/forge_equipment.py, export in tasks/__init__.py, and register in bot_manager.py according to 0-Network Pre-flight, highest tier forging logic, and in-memory live state sync.

## 🔒 My Identity
- Archetype: implementer
- Roles: implementer, qa
- Working directory: e:\intqam-sultan\.agents\teamwork\worker_backend_m1\
- Original parent: a182cf71-ea9d-47b9-98c7-b64fd24cf886
- Milestone: Milestone 1

## 🔒 Key Constraints
- Strict write boundary: tasks/forge_equipment.py, tasks/__init__.py, bot_manager.py, and own .agents/teamwork/worker_backend_m1/ directory. Do NOT touch any other files in the project.
- No dummy/facade implementations or hardcoded shortcuts. Maintain genuine state and logic.
- 0-Network Pre-flight: Check everydayTaskCtrl.eventInfo for "4100009" / "9" and quest completion. Return skip without network calls.
- In-memory live state sync: Deduct materials from backpackCtrl, deduct steel from cityCtrl.reslist["1006"], add equipment piece to equipment_array with endTime, mark eventInfo["4100009"] = 1.
- All modifications must be transparent direct edits via edit tools.

## Current Parent
- Conversation ID: a182cf71-ea9d-47b9-98c7-b64fd24cf886
- Updated: 2026-10-31T12:03:00Z

## Task Summary
- **What to build**: `ForgeEquipmentTask` in `tasks/forge_equipment.py`, registration in `tasks/__init__.py` and `bot_manager.py`.
- **Success criteria**:
  - Inherit from `BaseTask` with `name = "forge_equipment"`.
  - 0-Network Pre-flight for completed daily quest or busy blacksmith.
  - Collect finished equipment if timer reached (CMD 1047 / SubCMD 2).
  - Highest possible tier forge logic for 6 categories (Lv.110 down to Lv.1) with downgrade support down to guaranteed Lv.1.
  - Accurate CMD 1047 / SubCMD 1 & SubCMD 2 game packets.
  - Live in-memory state sync.
  - Registered in `bot_manager.py` (tasks, DEFAULT_BOT_CONFIG, reload_config_from_db).
  - All tests passing, syntax verified.
- **Interface contracts**: `.agents/teamwork/PROJECT.md`
- **Code layout**: `tasks/`, `bot_manager.py`

## Key Decisions Made
- Embedded official recipe formulas verified against `game_file/src/app/localtb/config_server/forge_equipment_config.lua` (all 138 recipes).
- Implemented `_ensure_steel_balance` to open steel chests (`100405`..`100401`) if current steel balance in `reslist["1006"]` is deficient.
- Implemented lowest-quality-first material selector (`white` -> `green` -> `blue`) to protect rare player materials.
- Synced in-memory live state comprehensively: `backpackCtrl`, `cityCtrl.reslist["1006"]`, `equipmentCtrl.equipment_array`, `everydayTaskCtrl.eventInfo`, and `questCtrl.point_finish_list`.

## Artifact Index
- `tasks/forge_equipment.py` — Task implementation
- `tasks/__init__.py` — Task export
- `bot_manager.py` — Bot registration and config reload
- `.agents/teamwork/worker_backend_m1/test_forge_equipment.py` — Unit test suite
- `.agents/teamwork/worker_backend_m1/DISPATCH.md` — Dispatch instructions
- `.agents/teamwork/worker_backend_m1/BRIEFING.md` — Situational awareness
- `.agents/teamwork/worker_backend_m1/progress.md` — Liveness and progress tracker
- `.agents/teamwork/worker_backend_m1/handoff.md` — Final handoff report

## Change Tracker
- **Files modified**:
  - `tasks/forge_equipment.py`: Created ForgeEquipmentTask class
  - `tasks/__init__.py`: Exported ForgeEquipmentTask
  - `bot_manager.py`: Added to REGISTERED_TASKS, DEFAULT_BOT_CONFIG, reload_config_from_db
- **Build status**: Pass
- **Pending issues**: None

## Quality Status
- **Build/test result**: Pass (12/12 unit tests passed)
- **Lint status**: 0 violations
- **Tests added/modified**: `test_forge_equipment.py` covering all 12 behavior paths

## Loaded Skills
None
