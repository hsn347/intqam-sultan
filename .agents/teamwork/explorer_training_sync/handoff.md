# Handoff Report: Requirement R1 - Training Sync & Queue/Quest In-Memory State

## 1. Observation
1. **Official Server Configuration & Protocol:**
   - In `game_file/src/app/localtb/config_server/daily_reward_point_config.lua` lines 90-129:
     - Infantry (bid 118, armyid 401): ID `4100012`, type `12`, quest `50`, limitTime `5` (total 250 units).
     - Archers (bid 117, armyid 601): ID `4100013`, type `13`, quest `50`, limitTime `5` (total 250 units).
     - Cavalry (bid 116, armyid 501): ID `4100014`, type `14`, quest `50`, limitTime `5` (total 250 units).
     - Chariots (bid 119, armyid 701): ID `4100015`, type `15`, quest `50`, limitTime `5` (total 250 units).
     - Traps/Fortress (bid 120, armyid 801): ID `4100016`, type `16`, quest `50`, limitTime `5` (total 250 units).
   - In `game_file/src/app/constdef/queueTypeDef.lua` lines 10-14:
     - `1203`: Chariot plant / Barracks queue mapping
     - `1204`: Stables queue
     - `1205`: Range queue
     - `1206`: Barracks queue
     - `1207`: Fortress queue
   - In `game_file/src/app/module/army/armyCtrl.lua` lines 673-710:
     - Upon training success (`trainArmyRsp`), the official client adds the active queue to `queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)` where `lefttime > 0`.

2. **Live Memory Dumps Verification:**
   - In `docs/beetoo3_live_memory.json`:
     - `everydayTaskCtrl.eventInfo` contains: `{'9': 1, '13': 5, '7': 1, '8': 10, '11': 5, '12': 5, '22': 5, '10': 1, '17': 1, '14': 5, '28': 1, '27': 1, '15': 5, '26': 1, '23': 20, '24': 10}`. Types `'12'`, `'13'`, `'14'`, `'15'` are all at value `5` (100% completed).
     - `queueCtrl` contains active dictionaries keyed by `"1203"`, `"1204"`, `"1205"`, `"1206"`, with `starttime`, `totaltime`, and `data: {"bid": "118", "armyid": "401", "armycount": "1735", ...}`.
   - In `docs/beetoo1_live_memory.json` and `docs/lucifer_live_memory.json`:
     - `queueCtrl` has no active troop queues (`[]` or only hospital `"1202"`).
     - `armyCtrl.trainArmy` contains finished troops waiting to be harvested: `{"116": {"501": "1985"}, "117": {"601": "1985"}, "118": {"401": "1985"}, "119": {"701": "1985"}}`.

3. **Current Code Implementation Flaws:**
   - In `tasks/train.py` (lines 665-678) and `tasks/daily_train.py` (lines 232-244):
     - When `_train_adaptive` succeeds, neither task updates `conn.init_data['queueCtrl']` or `everydayTaskCtrl['eventInfo']` or `questCtrl['point_finish_list']`.
   - In `core/game_client.py` (lines 1396-1412):
     - On cmd 1005 / subcmd 2, it only updates `armyCtrl.trainArmy` and does not update `queueCtrl`.
   - In `tasks/train.py` (lines 625-636):
     - The busy barracks check only evaluates `if bid in q_map:` without checking `armyCtrl.trainArmy` and without a complete bidirectional mapping from `qtype` (`1203`..`1207`) to `bid`.
   - In `tasks/train.py` (lines 535-570):
     - `_train_adaptive` retries 3 times on `timeout` without checking whether `conn.is_connected` is `False`.
   - In `tasks/daily_train.py` (lines 131-147):
     - `_is_type_handled_by_main_train` only inspects `config.get("train", {}).get("levels")` and fails to detect configurations under `config["tasks"]["train"]` or configured via `train.types`.

## 2. Logic Chain
1. Observation 1 & 2 establish that the ROS client and server track ongoing training via `queueCtrl[qtype]` (`1203` to `1207`) and finished troops ready for collection via `armyCtrl.trainArmy[bid]`. Daily activity quests are tracked via `everydayTaskCtrl.eventInfo` keys `'12'` to `'16'` with a max target of 5 cycles (250 units).
2. Observation 3 reveals that when `daily_train` successfully trains a unit, `conn.init_data['queueCtrl']` is never modified in memory.
3. In `bot_manager.py` (lines 82-86), `DailyTrainTask` executes immediately prior to `TrainTask`.
4. When `TrainTask` executes shortly after `DailyTrainTask`, it queries `conn.init_data['queueCtrl']`. Since `queueCtrl` was not updated, `TrainTask` assumes the barracks is idle.
5. `TrainTask` attempts to start training high-tier troops in the occupied barracks by sending `cmd: "1005", subcmd: "2"`.
6. The game server rejects the query with Error `4002` ("الثكنة مشغولة بعملية تدريب جارية حالياً"), violating the zero-failed-network-queries rule of `GEMINI.md`.
7. Similarly, if the network connection drops during training, `_train_adaptive` enters a retry loop (3 attempts per troop type across 5 types), generating up to 15 failing network calls on a dead socket.
8. Therefore, resolving the conflict requires: (a) immediate local in-memory synchronization of `queueCtrl`, `everydayTaskCtrl`, and `questCtrl` upon training query success; (b) robust dual-source busy checking (`queueCtrl` + `trainArmy`); (c) smart delegation in `daily_train` to skip types handled by `train`; and (d) strict pre-flight connection and capacity abort guards.

## 3. Caveats
- Traps (`bid = 120`, `queue_type = 1207`) in `fortress` have max tier 4 (instead of 10) and cost structure based on fortress logic; they are handled under the same protocol.
- Day rollover (`tomorrowZeroUTC` in `everydayTaskCtrl`): If the bot runs across UTC midnight without re-logging in, `eventInfo` reflects the previous day until refreshed by the server or login flow.

## 4. Conclusion
Requirement R1 can be completely solved without modifying the database schema or protocol by implementing:
1. **In-Memory Queue Sync**: A centralized helper `sync_training_queue_in_memory(conn, bid, armyid, count, retdata)` called immediately upon `cmd 1005 / subcmd 2` success, populating `queueCtrl[qtype]` and `armyCtrl.trainArmy[bid]`.
2. **In-Memory Quest Sync**: Updating `everydayTaskCtrl.eventInfo[str(event_type)]` and appending to `questCtrl.point_finish_list`.
3. **Queue Release on Harvest**: When `_harvest_all_ready_barracks` collects troops via `subcmd 5`, delete the building queue from `queueCtrl` and `trainArmy` in `conn.init_data`.
4. **Pre-flight & Disconnect Protection**: Check `self.conn.is_connected` before each troop type and inside `_train_adaptive`. Stop immediately on disconnection or zero capacity without retries.
5. **Smart Delegation in `daily_train`**: Defer any troop type where `train` is active (`train.enabled` and target tier > 0).

## 5. Verification Method
1. **Offline State Check**:
   - Inspect `docs/beetoo3_live_memory.json` to confirm `eventInfo` keys `'12'`..`'15'` have value `5` and `queueCtrl` has keys `'1203'`..`'1206'`.
   - Run python verification script:
     ```bash
     python -c "import json; d=json.load(open('docs/beetoo3_live_memory.json', encoding='utf-8')); print(d['everydayTaskCtrl']['eventInfo'])"
     ```
2. **Execution Simulation Test**:
   - Load `docs/beetoo1_live_memory.json` in mock connection, execute `DailyTrainTask` and verify that `conn.init_data['queueCtrl']` is updated, followed by `TrainTask` verifying that the occupied barracks is skipped with zero network queries.
3. **Field Verification**:
   - Run `python test_task_method.py --email beetoo1@hotmail.com --task daily_train run` followed by `train run` and verify the log shows zero 4002 error responses.
