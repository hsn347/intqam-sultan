# Handoff Report: Command Hall M3 Multi-Account Live Field Verification

**Agent**: `empirical_challenger` (`critic`, `specialist`)  
**Target Module**: `tasks/command_hall.py`  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\field_tester_m3\`  
**Date**: 2026-11-01  
**Verdict**: **`REQUEST_CHANGES`**

---

## 1. Observation

### Direct Tool Invocations and Empirical Results

1. **Zero-Troop Bypass Execution**:
   - Command: `python tools/test_zero_troop_bypass.py`
   - Target account: `beetoo1@hotmail.com` (UID: 11299184, Kingdom 150)
   - Observed log output:
     ```
     [1/4] Connecting to beetoo1@hotmail.com (UID: 11299184)...
     [2/4] Initial state: Gold=105018, Troops=256720
     [3/4] Running CommandHallTask with 0 troops available...
     [CommandHall] ⚠️ متطلب فيلق على الخريطة غير متاح حالياً (طوابير شاغرة: 2, جنود: 0, طاقة: 100).
     [CommandHall] ⚠️ تعذر إرسال فيلق على الخريطة لعدم توفر فيالق أو جنود أو طاقة — تم إنجاز كافة المهام الفرعية المتاحة والخروج بأمان طبقاً لتعليمات التشغيل.
     Result: success=True, executed=0, claimed=0, duration=1.62s
     [4/4] Verifying assertions:
       ✓ Duration < 5.0s: 1.62s
       ✓ Exit reason graceful: تعذر إرسال فيلق على الخريطة (تم إتمام باقي المهام والخروج بأمان)
       ✓ Delta Gold == 0: 0
       ✓ Socket closed cleanly
     ```

2. **Unpatched Combat March Dispatch Failure on Live Gateway**:
   - File: `tasks/command_hall.py`, lines 974-980 and 1008-1055.
   - Command: `python tools/test_live_field_command_hall_verification.py`
   - Target account: `beetoo3@hotmail.com` (UID: 11307263, Kingdom 150)
   - Target task data in `init_data`: `taskIndex=100`, `type=2`, `obj={"id": "1-100-397-423", "x": 397, "y": 423}`.
   - Dispatched payload: `{"to": {"x": 397, "y": 423}, ...}`
   - Raw Gateway Response:
     ```json
     {"cmd": "1007", "subcmd": "2", "err": "8002", "_ok": true}
     ```
   - Observed task log:
     ```
     [CommandHall] ⚔️ جاري إرسال فيلق إلى (397, 423) للمهمة: طليعة المتمردين (جنود: 3000, بطل: 130101)...
     [CommandHall] ✓ تم إرسال الفيلق بنجاح إلى (397, 423).
     [CommandHall] ⏳ تم إرسال 1 فيلق — جاري تتبع المسير وحسم المعركة (6.5 ثوانٍ وفق COMMANDHALL_REBEL_ARMY_MARCH_TIME)...
     [CommandHall] 🔄 حسمت معركة الفيلق — جاري تحديث الذاكرة الحية بالسيرفر (CMD 2274 / SUBCMD 1)...
     ```
   - In post-march sync `CMD 2274 / SUBCMD 1`: Task 100 remained `statue = 2` (never reached `statue = 3`).
   - The loop repeated 6 times until the 60-second safety timeout was reached.
   - Final Result: `dispatched = 6`, `claimed = 0`, `rewardsReceived = 0`.

3. **Game Client Code Inspection**:
   - File `game_file/src/app/module/world/mapSyncUtilClient.lua`:
     ```lua
     function mapSyncUtilClient.serverTOClientPos(server_x, server_y)
         return server_x - 1, server_y - 1
     end
     ```
   - File `game_file/src/app/constdef/errDef.lua`:
     ```lua
     Err_MAP_QUEUE_POS_CHANGE = "8002" -- Target position entity has changed / not present
     ```

4. **Empirical Verification of Coordinate Translation and Successful Battle Resolution**:
   - Command: `python tools/test_live_march_listener.py`
   - Target account: `beetoo3@hotmail.com`
   - Translated tile coordinates: `tile_x = 397 - 1 = 396`, `tile_y = 423 - 1 = 422`.
   - Sent `CMD 1007 / SUBCMD 2` with `{"to": {"x": 396, "y": 422}}`.
   - Gateway Response:
     ```json
     {"cmd": "1007", "subcmd": "2", "queueId": "11307263-3767", "marchTime": 5, "err": null, "_ok": true}
     ```
   - Dynamic travel wait duration: exactly **6.0 seconds**.
   - Post-march sync `CMD 2274 / SUBCMD 1`: Task 100 status transitioned from `2` -> `3`.
   - Reward Claim `CMD 2274 / SUBCMD 8` (`commitType: 2, index: 100`):
     ```json
     {
       "cmd": "2274",
       "subcmd": "8",
       "err": "0",
       "rspdata": {
         "finishTaskData": {"2012": 1},
         "rewards": [
           {"id": 500602, "num": 1},
           {"id": 510004, "num": 12},
           {"id": 110101, "num": 6},
           {"id": 110001, "num": 14},
           {"id": 110201, "num": 7}
         ]
       }
     }
     ```
   - Total rewards claimed: **5 item stacks**.
   - Delta Gold: `142,350` -> `142,350` (**0 gold spent**).
   - Socket connection closed cleanly (`conn.is_connected == False`).

---

## 2. Logic Chain

1. **From Observation 3 & 2**: `tasks/command_hall.py` extracts raw coordinates `(397, 423)` from `task.get("obj")` and sends them directly to `CMD 1007 / SUBCMD 2`. But in the game engine, `task.obj` contains server coordinates, whereas march dispatch expects client tile coordinates (`server - 1`). The server adds `+1, +1` to convert client coordinates back to server space, targeting `(398, 424)`. Because no NPC exists at `(398, 424)`, the gateway rejects the march with error code `8002` (`Err_MAP_QUEUE_POS_CHANGE`).

2. **From Observation 2**: In `tasks/command_hall.py` line 1045, `if res is not None:` is used to evaluate the march dispatch result. Because `safe_query` returns the parsed gateway response dictionary `{"cmd": "1007", "subcmd": "2", "err": "8002", "_ok": true}`, `res is not None` evaluates to `True`. The bot logs a false success message (`✓ تم إرسال الفيلق بنجاح`), increments `dispatched`, and consumes troops in memory.

3. **From Step 1 & 2**: Because the march was rejected by the gateway with error 8002, no army was ever placed on the server map. When the bot waits 6.5 seconds and queries `CMD 2274 / SUBCMD 1`, the task on the server remains at `statue = 2`. The bot sees the task is still actionable and repeats the failed dispatch loop until timeout, resulting in **0 rewards claimed (`claimed == 0`)**.

4. **From Observation 4**: When the coordinate translation `tile_x = server_x - 1, tile_y = server_y - 1` is applied, `CMD 1007 / SUBCMD 2` succeeds immediately with `queueId: "11307263-3767"`. The march travels in 5s (resolved at 6s), `CMD 2274 / SUBCMD 1` reflects `statue = 3`, and `CMD 2274 / SUBCMD 8` claims 5 reward items with `err: "0"`, proving conclusively that fixing the coordinate translation resolves the entire combat workflow.

5. **From Observation 1**: The zero-troop bypass pathway operates entirely in 0-network memory, correctly detects `available_troops_count == 0`, and exits gracefully in 1.62 seconds (< 5s requirement) with zero gold spent.

---

## 3. Caveats

1. **Live Monster Regeneration**: Once an NPC target on the map is defeated, the server marks the task as completed (`statue: 3` / `statue: 0`). Re-running tests against the exact same subtask index without a new wave or daily reset requires testing on other pending subtasks or wave enemies.
2. **Review-Only Constraint**: In strict adherence to our role as `empirical_challenger`, no modifications were made directly to `tasks/command_hall.py`. The working code has been proven in `tools/test_live_march_listener.py` and provided as explicit patch instructions for the worker agent.

---

## 4. Conclusion

**Verdict: `REQUEST_CHANGES`**

The implementation in `tasks/command_hall.py` fails the live field verification acceptance criteria for combat march resolution and reward claiming on `beetoo3@hotmail.com` due to:
1. Missing server-to-client tile coordinate translation (`tile = server - 1`) leading to gateway error `8002`.
2. Treating gateway error responses (`err: "8002"`) as successful dispatches (`if res is not None:`).

The worker agent must apply the following two patches to `tasks/command_hall.py`:
1. In `_handle_march_tasks` (lines 974-980):
   ```python
   server_x, server_y = coords
   target_x, target_y = max(0, server_x - 1), max(0, server_y - 1)
   ```
2. In `_handle_march_tasks` (lines 1045-1055):
   ```python
   is_success = (
       isinstance(res, dict)
       and str(res.get("err", "0")) in ("0", "")
       and (res.get("queueId") or not res.get("err"))
   )
   if is_success:
       dispatched += 1
       ...
   ```

---

## 5. Verification Method

### How to Independently Verify:

1. **Verify 0-Troop Bypass (< 5s, 0 Gold)**:
   ```powershell
   python tools/test_zero_troop_bypass.py
   ```
   *Expected*: Passes in < 2 seconds with exit reason `"تعذر إرسال فيلق على الخريطة (تم إتمام باقي المهام والخروج بأمان)"` and `Delta Gold == 0`.

2. **Verify Coordinate Translation & Live Reward Claiming**:
   ```powershell
   python tools/test_live_march_listener.py
   ```
   *Expected*: March creates `queueId`, reaches target in 6s, transitions task to `statue = 3`, claims rewards via CMD 2274/8 with `rewards > 0`, and exits with `Delta Gold == 0`.

3. **Verify Full Field Test Harness**:
   ```powershell
   python tools/test_live_field_command_hall_verification.py
   ```

### Invalidation Conditions:
- If `CMD 1007 / SUBCMD 2` returns `err: "8002"` or `queueId` is missing.
- If execution time on zero-troop account exceeds 5.0 seconds.
- If Delta Gold is greater than 0.
