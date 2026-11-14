# Handoff Report: Command Hall Lifecycle, March Tracking & Wave Progression Overhaul

**Agent**: `teamwork_worker` (`worker_cmd_hall_lifecycle`)  
**Assignment**: Overhaul `tasks/command_hall.py` to eliminate 300-second freeze, implement dynamic march tracking, support force network synchronization, ensure immediate reward claiming, and enable wave progression.  
**Timestamp**: 2026-11-01T15:05:00Z  

---

## 1. Observation

1. **Root Cause of the 300-Second Freeze**:
   - `tasks/command_hall.py:66` defined `LOOP_MAX_DURATION_SECONDS = 300`.
   - In `tasks/command_hall.py:1025`, `has_active_marches` was defined as `(total_marches > 0)`. Because `total_marches` was an accumulator (`total_marches += dispatched`), once a single march was dispatched, this boolean remained permanently `True`.
   - In `tasks/command_hall.py:941`, the dispatched march was set locally to `task["statue"] = TASK_STATUE_PREPARE`. This caused `has_preparing_tasks = any(... == TASK_STATUE_PREPARE)` in line 1026 to remain permanently `True`.
   - The exit condition in line 1029 required `not has_active_marches and not has_preparing_tasks and elapsed >= 30`. Once a march was dispatched, this condition could never evaluate to `True`.
   - Because `_ensure_synced_data()` previously cached in-memory data with `if self._is_synced: return hall_data`, it never touched the server again to check whether the battle finished. The bot entered repeated sleeps of `random.uniform(4.0, 7.0)` until the 300-second outer loop timeout expired, producing a 5-minute freeze and exiting with 0 rewards.

2. **Official Lua Source March Timing**:
   - `game_file/src/app/module/world/queueTimeUtil.lua:327-333`:
     ```lua
     if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
         local marchTime = commandHallUtil.getRebelArmyMarchTime()
         if totalTime > marchTime then totalTime = marchTime end
     end
     ```
   - `game_file/src/app/module/commandHall/commandHallUtil.lua:310-318`:
     `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` seconds, and `COMMANDHALL_COMMON_TASK_MARCH_TIME = 2` seconds.
   - Travel time to Command Hall NPCs is hard-capped to 5 seconds regardless of world distance, and battle resolution requires 1-2 seconds.

3. **Live Server Reward Claiming & Wave Progression Protocol**:
   - Tasks with `statue == 3` (`TASK_STATUE_FINISH`) or defeated Rebel Army Group (Type 1) with `hurtHp >= rabelHp` are claimed via `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) with `{"commitType": task.type, "index": task.index}`.
   - Claiming Type 1 returns `rspdata.initData` with `armyGroupID = armyGroupID + 1` and the next wave's tasks, which can be executed immediately without waiting.

---

## 2. Logic Chain

1. From Observation 1, the 300-second stall was caused by three flawed checks (`total_marches > 0`, `has_preparing_tasks`, `LOOP_MAX_DURATION_SECONDS = 300`) and the absence of post-march network synchronization.
2. From Observation 2, because Lua clamps march duration to 5 seconds for Rebel Army monsters and 2 seconds for common monsters, a dynamic wait of 6.0 to 8.5 seconds completely covers travel time and server-side battle computation.
3. Therefore, replacing the 300-second wait with a dynamic 6.0-8.5s wait followed immediately by `_ensure_synced_data(force_network=True)` querying `CMD 2274 / SUBCMD 1` allows the bot to fetch the authoritative server state reflecting `statue == 3`.
4. From Observation 3, calling `_claim_finished_tasks(hall_data)` immediately after `force_network` sync dispatches `CMD 2274 / SUBCMD 8` to claim rewards, ensuring `claimed_rewards > 0`.
5. Upon claiming Type 1 (`commitType = 1`), the server returns `rspdata.initData` with `armyGroupID + 1`. Calling `_handle_wave_progression_after_claim()` updates `hall_data`, clears `_attacked_rebel_groups` and `_claimed_tasks`, and allows the loop to seamlessly continue to the next wave within the same session.
6. Replacing the exit condition with `is_task_actionable(t)` guarantees that when all subtasks in the current wave are completed, claimed, or blocked on marches/stamina, the loop terminates immediately with `"تم إنجاز كافة المهام المتاحة بالكامل"` in 2 to 10 seconds total.

---

## 3. Caveats

- **Network Jitter Tolerance**: While official march travel time is <= 5 seconds, an additional safety margin (6.0 to 8.5 seconds total) was provided to absorb network packet latency and server battle queue processing.
- **Daily Quota Reset**: When all waves for the day are defeated, `armyGroupTaskData` is empty and `tomorrowArmyGroupTaskData` is populated. The bot detects `has_pending_actions == False` and exits cleanly without waiting for midnight reset.
- **No caveats regarding regression**: All 36 tests across existing and new test suites pass with 100% success rate.

---

## 4. Conclusion

The Command Hall lifecycle has been completely overhauled:
- The 300-second freeze and stagnant loop have been eliminated.
- Safety timeout is reduced to 60 seconds maximum (`SAFETY_TIMEOUT_SECONDS = 60`).
- Dynamic march tracking (6.0-8.5s) is implemented and verified.
- Forced network sync (`CMD 2274 / SUBCMD 1`) is executed post-march.
- Immediate reward claiming (`CMD 2274 / SUBCMD 8`) is verified for both subtasks and Type 1 Rebel Army Group.
- Seamless multi-wave progression is verified across waves.
- Total test coverage: 36 tests passing (0 failures, 0 errors).

---

## 5. Verification Method

To independently verify the implementation, execute the following commands in powershell from `e:\intqam-sultan`:

```powershell
python -m unittest tools/test_command_hall_task.py
python -m unittest tools/test_challenger_command_hall.py
python -m unittest tools/test_cmd_hall_adversarial.py
```

### Combined Verification Command:
```powershell
python -m unittest tools/test_command_hall_task.py tools/test_challenger_command_hall.py tools/test_cmd_hall_adversarial.py
```

Expected result:
```
Ran 36 tests in ~34s
OK
```

### Files to Inspect:
- `tasks/command_hall.py`: Lines 60-75 (constants), 580-680 (`_ensure_synced_data`, `_claim_finished_tasks`), 740-770 (`_handle_rebel_group_attack`), 1010-1160 (`run`).
- `tools/test_command_hall_task.py`: Tests 11 and 12.
- `tools/test_challenger_command_hall.py`: Tests 07, 10, and 11.
