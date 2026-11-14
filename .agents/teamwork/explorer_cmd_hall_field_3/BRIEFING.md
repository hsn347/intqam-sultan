# BRIEFING — 2026-11-01T15:41:00Z

## Mission
Investigate live memory dumps (`beetoo1_live_memory.json`, `beetoo3_live_memory.json`), existing test scripts in `tools/`, and account states in `database/castles.db` to determine exact live data structures for command hall, heroes, troops, march queues, lord info, and define safe field execution protocols.

## 🔒 My Identity
- Archetype: explorer
- Roles: Live Account & Field Explorer
- Working directory: e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_field_3
- Original parent: 72f48ea7-a871-461a-a5ec-e0f8180614e5
- Milestone: Command Hall & Field Testing Exploration

## 🔒 Key Constraints
- Read-only investigation — do NOT implement production changes
- Adhere strictly to GEMINI.md (Zero-Network Pre-flight, Ban Prevention, Safe Testing, Zero gold/resource unintended spend)
- Working directory metadata only in `.agents/teamwork/`

## Current Parent
- Conversation ID: 72f48ea7-a871-461a-a5ec-e0f8180614e5
- Updated: 2026-11-01T15:41:00Z

## Investigation State
- **Explored paths**:
  * `docs/beetoo1_live_memory.json`, `docs/beetoo3_live_memory.json`, `docs/lucifer_live_memory.json`
  * `game_file/src/app/constdef/cmdDef.lua`, `heroDef.lua`, `armyDef.lua`, `queueTypeDef.lua`
  * `game_file/src/app/localtb/config_client/hero_view_info.lua`, `hero_type_info.lua`
  * `game_file/src/app/localtb/config_server/armyinfo.lua`
  * `game_file/src/app/module/commandHall/commandHallCtrl.lua`, `commandHallUtil.lua`
  * `tools/test_task_method.py`, `tools/test_command_hall_task.py`, `tools/test_challenger_command_hall.py`, `tools/test_field_and_pipeline_challenger.py`, `tools/field_test_command_hall.py`
  * `database/castles.db` (`castle_states` table)
- **Key findings**:
  1. `commandHall` is absent from login packet (`init_data`). Official client sends `CMD 2274 / SubCMD 1` (`REQ_COMMAND_HALL_INIT`). Result must be cached in `conn.init_data["commandHall"]` for 0-network pre-flight checks.
  2. Hero controller in server packet is `heroSysCtrl` (mapped to `heroCtrl` in Lua). Hero `heroType` is not in dynamic server packet but in static config `hero_view_info.lua`.
  3. Ancillary/gathering heroes (`heroType == 1`) are exactly: `[1711, 1717, 1724, 1733]`. These MUST be excluded from combat marches.
  4. Combat heroes (`heroType in (2, 3, 4, 5)`) must be selected if `state == 1` and `not hero.get("queue")`.
  5. Troops in `armyCtrl.totalArmy` are categorized: 4xx Infantry, 5xx Archer, 6xx Cavalry, 7xx Chariot/Siege. Traps are 8xx and cannot march.
  6. `queueCtrl` stores queues directly by ID (`1202`..`1212`, map move line `1221`).
  7. Lord stamina is at `lordInfoCtrl.base.health` (100). If `< 5`, skip tasks with zero gold spend.
  8. Snipe hunter task (6) and Dialogue (3) and Rescue (4) all execute via direct packet `CMD 2274 SubCMD 5` without graphical mini-game.
  9. Rebel army group (1) executes via `CMD 2274 SubCMD 7` directly from castle to refresh task list.
  10. Testing accounts: `beetoo1` (0 troops, safe for instant tasks), `beetoo3` (14,380 troops, safe for march tasks).
- **Unexplored areas**: None. All mission questions answered comprehensively.

## Key Decisions Made
- Fully documented all 6 subtasks, memory structures, hero & troop filtering rules, and safe field execution instructions.
- Delivered detailed findings in `analysis.md` and `handoff.md`.

## Artifact Index
- DISPATCH.md — Initial dispatch message
- BRIEFING.md — Situational awareness
- progress.md — Heartbeat & execution log
- analysis.md — Full technical analysis and evidence chains
- handoff.md — 5-component handoff report
