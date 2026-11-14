# Project: Command Hall Lifecycle & Dynamic March Overhaul

## Architecture

This project resolves the 300-second freeze, eliminates stagnant idle loops, and implements dynamic real-time march tracking, immediate reward claiming, live memory synchronization, and wave progression for the Command Hall task (`tasks/command_hall.py`).

### Key Architectural Elements

1. **Elimination of the 300-Second Freeze & Stagnant Loop**:
   - Replaced `LOOP_MAX_DURATION_SECONDS = 300` with `SAFETY_TIMEOUT_SECONDS = 60`.
   - Removed broken accumulator checks `total_marches > 0` and `has_preparing_tasks`.
   - Added `is_task_actionable(t)` and early termination (`not progress_in_iteration or not has_pending_actions`). Loop terminates promptly in seconds when no actionable tasks remain.

2. **Official Lua Dynamic March Tracking**:
   - Integrated official Lua march constants (`COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`s, `COMMANDHALL_COMMON_TASK_MARCH_TIME = 2`s per `queueTimeUtil.lua:327-333` and `commandHallUtil.lua:310-318`).
   - Dynamic non-blocking wait of 6.0 to 8.5 seconds post-march (covering 5s travel + 1-2s battle resolution).
   - Applied client tile coordinate translation (`tile_x = server_x - 1, tile_y = server_y - 1`) matching `mapSyncUtilClient.lua:serverTOClientPos`, eliminating gateway error 8002.

3. **Authoritative Network Sync (`CMD 2274 / SUBCMD 1`) After March**:
   - In `_ensure_synced_data()`, added `force_network=True` to query `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`).
   - Dispatched immediately after march arrival to refresh `conn.init_data["commandHall"]` and `hall_data` with authoritative `statue == 3` (`TASK_STATUE_FINISH`).

4. **Immediate Reward Claiming (`CMD 2274 / SUBCMD 8`)**:
   - Tasks with `statue == 3` (`FINISH`) are immediately claimed via `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) with `{"commitType": task.type, "index": task.index}`.
   - Rewards (`rspdata.reward`) are recorded into `claimed_rewards` (`rewardsReceived > 0`).

5. **Rebel Army Group (Type 1) Defeat & Instant Wave Renewal**:
   - Claiming Type 1 when `hurtHp >= rabelHp` or `statue == 3` is centralized in `_claim_finished_tasks`.
   - Purges defeated boss from live memory (`_purge_defeated_group_from_memory`) and keys claims by `(wave_id, commit_type, task_index)`, eliminating duplicate claims and infinite loop risks.
   - Advances `armyGroupID = armyGroupID + 1` and continues seamless multi-wave progression in the same session.

6. **Clean & Safe Termination**:
   - Pre-flight checks detect zero available troops, available march queues, or stamina < 5 without network spam.
   - Zero-troop bypass executes in 1.42s (< 5.0s SLA) with `Delta Gold == 0` and clean socket closure.

---

## Feature Inventory

| # | Feature | Description | Milestone | Status | Source |
|---|---------|-------------|-----------|--------|--------|
| 1 | 5s March Duration Cap & Dynamic Wait | Track 5s `COMMANDHALL_REBEL_ARMY_MARCH_TIME`; wait 6-8.5s max per march | M1 | DONE | Survey (Lua) |
| 2 | Force Network Sync Post-March | Query `CMD 2274 / SUBCMD 1` with `force_network=True` to refresh task `statue` | M1 | DONE | Survey (Lua/Backend) |
| 3 | Elimination of 300s Freeze | Remove 300s timeout & broken accumulator exit check `has_active_marches` | M1 | DONE | Survey (Backend) |
| 4 | Immediate Reward Claiming (`2274/8`) | Claim tasks with `statue == 3` via `commitType` and `index`; assert >0 rewards | M1 | DONE | Survey (Lua/Field) |
| 5 | Instant Wave Renewal & Progression | Claim Type 1 when `hurtHp >= rabelHp` to advance `armyGroupID` and run next wave | M1 | DONE | Survey (Lua) |
| 6 | Unit Test Suite & Regression Hardening | Verify all 6 subtask flows, dynamic wait, force sync, and claim logic in tests | M1 | DONE | GEMINI.md |
| 7 | Multi-Perspective Review Swarm | Independent review by 2 Reviewers (Logic, Protocol) and 2 Challengers (Empirical, Adversarial) | M2 | DONE | Constitution |
| 8 | Forensic Integrity Audit | Static analysis and runtime integrity validation by Forensic Auditor | M3 | DONE | Constitution |
| 9 | Live Multi-Account Field Verification | Test on `beetoo3` (14k troops, combat wave 12) & `beetoo1` (0-troop bypass) via `tools/` | M3 | DONE | Acceptance Criteria |

---

## Milestones

| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Lifecycle & Dynamic March Implementation | `tasks/command_hall.py`, dynamic wait, force sync, reward claim, unit tests | Survey | DONE |
| 2 | Multi-Perspective Review & Challenge Swarm | 2 Reviewers, 2 Challengers (Remediation & Retest) | M1 | DONE |
| 3 | Forensic Integrity Audit & Live Field Verification | Forensic Auditor (`CLEAN`) + Multi-Account Gateway Field Verification (`APPROVE`) | M2 | DONE |

---

## Code Layout

- Backend Task: `tasks/command_hall.py`
- Verification & Test Tools: `tools/`
- Metadata & State: `.agents/teamwork/`
