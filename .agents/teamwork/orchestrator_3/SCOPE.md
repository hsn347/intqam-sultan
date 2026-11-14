# Scope: Command Hall Task Implementation & Full Lifecycle

## Architecture
- Module boundaries:
  - Backend Task: `tasks/command_hall.py` inheriting from `BaseTask` in `tasks/base_task.py`.
  - Task export: `tasks/__init__.py`.
  - Bot Manager registration: `bot_manager.py` (REGISTERED_TASKS, DEFAULT_BOT_CONFIG, reload_config_from_db).
  - API Server Whitelist: `api_server.py` (`clean_config`).
  - Database Migration: `database/castles.db` update all existing castle configs.
  - Frontend Types & Hooks: `dashboard/src/types/index.ts` and `dashboard/src/hooks/useCastles.ts`.
  - Frontend UI & Dual-Save: `dashboard/src/components/accounts/TaskTabContent.tsx` (performSave, handleSave, icon, single toggle).
  - Trilingual Localization: `dashboard/src/locales/ar.json`, `en.json`, `tr.json`.
  - Verification & Test Scripts: `tools/`.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Lua Spec & Task Extraction | Extract Command Hall (Daily Activity) tasks, commands, IDs, conditions, network packets from Lua files in `game_file/` and memory dumps | M1 | survey |
| 2 | Live Memory & Icon Identification | Identify data structures in `conn.init_data` and find official Command Hall icon from game assets | M1 | survey |
| 3 | Backend Task Core Logic | Implement `CommandHallTask` with 5-minute continuous execution loop, safe subtask sequence, 0-network checks, human jitter, error isolation | M2 | R1, R2 |
| 4 | Safe March & March Inability Exit | Handle troop march subtasks gracefully: dispatch troop if available, or finish other tasks and cleanly exit when no marches are available | M2 | R1 |
| 5 | Zero Gold & Zero Speedup Safety | Strictly avoid gold and speedup subtasks, verify mode "0" and "2" only | M2 | R2 |
| 6 | Reward Claiming Loop | Claim quest rewards periodically in live memory and server responses | M2 | R1 |
| 7 | 6-Stage Pipeline Backend Integration | Register task in `bot_manager.py`, whitelist in `api_server.py`, DB migration for all castles | M2 | R3 |
| 8 | Frontend UI Toggle & Icon | Add single toggle in Daily Activity section in `TaskTabContent.tsx` with official icon | M3 | R3 |
| 9 | Dual-Save Pipeline | Integrate toggle in `performSave` and `handleSave`, types, and useCastles | M3 | R3 |
| 10 | Trilingual Localization | Add translations in `ar.json`, `en.json`, `tr.json` with zero hardcoded strings | M3 | R3 |
| 11 | Backend & Logic Audit Swarm | Audit logic, memory, DB, network packets, 0-net, delay (0.5-0.9s), loops | M4 | AGENTS_CONSTITUTION |
| 12 | Frontend Audit Swarm | Audit localization, theme, asset quality, frontend net/cache, security, UX | M4 | AGENTS_CONSTITUTION |
| 13 | Live Field Testing | Real castle test execution using `tools/test_task_method.py` on database castles | M5 | Acceptance Criteria |
| 14 | Forensic Victory Audit | Comprehensive AST, anti-cheating, DB integrity, and acceptance criteria verification | M5 | Acceptance Criteria |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Spec Mining & Code Survey | Survey game source, Lua files, memory structures, CMD/SubCMD, task definitions, icons | none | DONE |
| 2 | Backend Implementation & Integration | Implement `tasks/command_hall.py`, bot_manager, api_server, DB migration | M1 | DONE |
| 3 | Frontend Implementation & Localization | Single toggle in TaskTabContent.tsx, icon, dual-save, ar/en/tr localization | M1, M2 | DONE |
| 4 | Specialized Multi-Swarm Audits | Comprehensive auditing across all constitution auditor domains | M2, M3 | DONE |
| 5 | Field Verification & Victory Audit | Real castle testing on live game servers, browser verification, victory confirmation | M4 | DONE |

## Interface Contracts
### `CommandHallTask` (`tasks/command_hall.py`)
- Inherits from `BaseTask` (`tasks/base_task.py`)
- `name = "command_hall"`
- `is_active = self.config.get("enabled", False)`
- Method: `async def execute(self) -> bool`
- Config structure: `{"command_hall": {"enabled": bool}}`
- Commands: `CMD 2274`, SubCMDs: `1` (init), `2` (upgrade lv), `5` (finish zero-army subtask), `8` (commit finished task), `CMD 1007 SubCMD 2` (march)
- Task Types: `1`: Group march, `2`: Pioneer march, `3`: Dialogue, `4`: Rescue, `5`: Battle, `6`: Snipe hunter
- Loop duration: 300 seconds (5 minutes) continuous execution, exiting when march-dependent and no marches available.
