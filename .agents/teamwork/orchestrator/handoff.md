# Orchestrator Final Handoff: Command Hall Lifecycle Overhaul & Freeze Elimination

**Orchestrator**: `teamwork_orchestrator`  
**Mission**: Investigate game client source, eliminate 300-second freeze, implement dynamic march tracking, force network sync, immediate reward claiming, and multi-wave progression in `tasks/command_hall.py`.  
**Date**: 2026-11-01  
**Project Root**: `e:\intqam-sultan`  

---

## 1. Observation

1. **Root Cause Analysis (Survey & Explorers)**:
   - Official Lua source (`game_file/src/app/module/world/queueTimeUtil.lua:327-333` and `commandHallUtil.lua:310-318`) proves that march travel time for Command Hall NPCs is hard-capped to `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` seconds (and common tasks to 2 seconds).
   - In `tasks/command_hall.py`, the legacy implementation set `task["statue"] = TASK_STATUE_PREPARE` upon dispatch and evaluated `has_active_marches = (total_marches > 0)`. Because `total_marches` was an accumulator, this remained `True` permanently. Furthermore, `_ensure_synced_data()` cached data locally and refused to sync (`self._is_synced == True`), forcing the bot to sleep in 4-7s increments until the outer 300s limit expired, exiting with 0 rewards.

2. **Backend Lifecycle & Dynamic March Implementation (Worker & Remediation)**:
   - Eliminated `LOOP_MAX_DURATION_SECONDS = 300` and replaced with `SAFETY_TIMEOUT_SECONDS = 60` and early exit via `is_task_actionable(t)`.
   - Dynamic non-blocking sleep of 6.0 to 8.5 seconds post-march (covering 5s travel + 1-2s battle resolution).
   - Forced network sync via `CMD 2274 / SUBCMD 1` (`force_network=True`) immediately following march arrival, updating task `statue` from 2 (`BEGIN`) to 3 (`FINISH`).
   - Centralized immediate reward claiming via `CMD 2274 / SUBCMD 8` (`commitType: task.type, index: task.index`).
   - Remediated duplicate claim vulnerability: Rebel Army Group claiming centralized in `_claim_finished_tasks`, `status != 0` strictly enforced, defeated bosses purged from memory via `_purge_defeated_group_from_memory`, and claim keys wave-scoped `(wave_id, commit_type, task_index)`.

3. **Revenge of Sultans Tile Coordinate Translation (Field Challenger)**:
   - Official client `game_file/src/app/module/world/mapSyncUtilClient.lua:serverTOClientPos` proves client tile coordinates are `server - 1`. The server adds `+1, +1` when converting client coordinates back to server space.
   - When raw coordinates were sent, gateway returned error `8002` (`Err_MAP_QUEUE_POS_CHANGE`).
   - Translating `target_x, target_y = max(0, server_x - 1), max(0, server_y - 1)` and strictly validating march response (`res.get("err") in ("0", "", None)` and `queueId`) resolved all march dispatches.

4. **Multi-Account Live Field Verification (`tools/`)**:
   - `beetoo1@hotmail.com` (0-troop account): Verified graceful zero-troop bypass in **1.42s** (< 5.0s SLA) with `Delta Gold == 0` and clean socket teardown.
   - `beetoo3@hotmail.com` (combat account): Verified march dispatched with valid `queueId`, arrived in **6.0-6.2s** (< 10s vs 300s stall), battle resolved, task transitioned to `statue == 3`, and claimed 5 reward item stacks via `CMD 2274 / SUBCMD 8`. Executed 8 instant tasks and claimed 9 rewards in **16.21s** with `Delta Gold == 0`.
   - `LUCIFER@g4.com`: Verified march dispatched with `queueId: 31596828-4425` and zero error 8002.

5. **Independent Audits & Gate Status**:
   - `reviewer_lifecycle_logic`: **APPROVE**
   - `reviewer_lifecycle_protocol`: **APPROVE**
   - `challenger_adversarial_lifecycle`: **APPROVE**
   - `challenger_retest_r2`: **APPROVE** (87/87 tests pass)
   - `forensic_auditor_m3`: **CLEAN** (Zero shortcuts, zero dummy facades, 100% genuine production logic)
   - `field_tester_m4`: **APPROVE** (Live gateway testing across accounts)

---

## 2. Logic Chain

1. From Observation 1, expecting a march to Command Hall NPCs to take hundreds of seconds or waiting 300 seconds contradicted official game constants (`COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`).
2. From Observation 2 and 3, dispatching marches with tile coordinates (`server - 1`) enables the server to accept the queue (`queueId` returned, error 8002 eliminated). Waiting 6.0-8.5 seconds dynamically matches arrival and battle resolution.
3. Querying `CMD 2274 / SUBCMD 1` with `force_network=True` updates `conn.init_data["commandHall"]` to reflect `statue == 3`, allowing `_claim_finished_tasks` to commit rewards via `CMD 2274 / SUBCMD 8`, directly eliminating the "exiting with 0 rewards" defect.
4. Purging defeated groups and enforcing `status != 0` eliminates duplicate claims and infinite loop risks upon wave transitions.
5. From Observation 4, live execution across production gateways confirms that zero-troop castles exit in 1.42s and active combat castles resolve marches, claim rewards, and exit in ~16s with 0 gold spent.
6. From Observation 5, all Reviewers, Challengers, and the Forensic Integrity Auditor have unanimously verified and approved the solution.

---

## 3. Caveats

- **Congested Map Entity Movement**: If a world map NPC moves due to tile congestion, the server returns error 8002. `tasks/command_hall.py` handles this gracefully by rejecting the march without deducting troops in memory or entering infinite loops.
- **Daily Wave Ceiling**: When all daily waves are defeated, `tomorrowArmyGroupTaskData` is set while `armyGroupTaskData` is empty; the bot detects zero actionable tasks and exits cleanly without waiting for midnight server reset.

---

## 4. Conclusion

The Command Hall lifecycle overhaul is complete and verified:
- **Freeze Eliminated**: 300s stagnant loop eradicated; normal runs complete in seconds.
- **Dynamic March Tracking**: 6.0-8.5s dynamic wait based on official 5s Lua cap.
- **Coordinate Translation**: `server - 1` applied, eliminating gateway error 8002.
- **Reward Claiming**: Verified live with real reward item stacks claimed (`rewardsReceived > 0`).
- **Wave Progression**: Seamless progression across waves with zero infinite loop risk.
- **Zero-Troop Bypass**: Executes in 1.42s (< 5.0s SLA) with `Delta Gold == 0`.
- **Integrity Certified**: CLEAN verdict by Forensic Integrity Auditor; 100% test pass rate across 61+ unit, empirical, and adversarial tests.

---

## 5. Verification Method

```powershell
# 1. Zero-Troop Bypass (< 5s, 0 Gold):
python tools/test_zero_troop_bypass.py

# 2. Multi-Account Live Field Verification Runner:
python tools/test_live_field_command_hall_verification.py

# 3. Full Unit, Empirical & Adversarial Test Suites:
python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py tools/test_adversarial_lifecycle.py tools/test_empirical_lifecycle.py tools/test_adversarial_retest_r2.py

# 4. Forensic Integrity Audit:
python tools/audit_forensic_integrity.py
```
