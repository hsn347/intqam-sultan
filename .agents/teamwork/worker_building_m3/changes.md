# Summary of Changes: Milestone 3 (Building Random Delays - R3)

**File Modified**: `e:\intqam-sultan\tasks\building.py` (Exclusive write ownership respected)

---

## 1. Safe Query Delays Standardization (`min_delay=0.5, max_delay=0.9`)
All network queries executed via `self.safe_query` in `tasks/building.py` were standardized to human-like random jitter between `0.5s` and `0.9s`:

1. **`refresh_active_queues` (Line 526)**:
   - Target query: CMD 1003 / SubCMD 1
   - Previous: `min_delay=0.6, max_delay=1.2`
   - Updated: `min_delay=0.5, max_delay=0.9`

2. **`harvest_building_resource` (Line 798)**:
   - Target query: CMD 1001 / SubCMD 8
   - Previous: `min_delay=0.3, max_delay=0.7`
   - Updated: `min_delay=0.5, max_delay=0.9`

3. **`construct_missing_building` (Line 863)**:
   - Target query: CMD 1001 / SubCMD 2
   - Previous: `min_delay=0.8, max_delay=1.5`
   - Updated: `min_delay=0.5, max_delay=0.9`

4. **`execute_building_action` - Construction (Line 1114)**:
   - Target query: CMD 1001 / SubCMD 2
   - Previous: `min_delay=0.8, max_delay=1.5`
   - Updated: `min_delay=0.5, max_delay=0.9`

5. **`execute_building_action` - Upgrade (Line 1150)**:
   - Target query: CMD 1001 / SubCMD 3
   - Previous: `min_delay=0.8, max_delay=1.5`
   - Updated: `min_delay=0.5, max_delay=0.9`

6. **`accelerate_queue_to_completion` - Free Speedup (Line 1265)**:
   - Target query: CMD 1003 / SubCMD 2 (mode "0")
   - Previous & Retained: `min_delay=0.5, max_delay=0.9`

7. **`accelerate_queue_to_completion` - Batch Bag Speedup (Line 1325)**:
   - Target query: CMD 1003 / SubCMD 2 (mode "2")
   - Previous: `min_delay=0.8, max_delay=1.5`
   - Updated: `min_delay=0.5, max_delay=0.9`

8. **`accelerate_queue_to_completion` - Tail Free Speedup (Line 1340)**:
   - Target query: CMD 1003 / SubCMD 2 (mode "0")
   - Previous: `min_delay=0.4, max_delay=0.8`
   - Updated: `min_delay=0.5, max_delay=0.9`

---

## 2. Inter-Action Loop Human-Like Delays (`await asyncio.sleep(random.uniform(0.5, 0.9))`)
Human-like non-blocking delays were integrated into sequential execution transitions to protect against pattern recognition and server rate-limiting:

1. **Post-Harvest Transition (Line 1146)**:
   - After harvesting resource and before sending the upgrade request.
   - Previous: `await asyncio.sleep(0.3)`
   - Updated: `await asyncio.sleep(random.uniform(0.5, 0.9))`

2. **Cycle Entry Queue Acceleration (Line 1521)**:
   - Delay between consecutive queue accelerations when multiple active queues exist at entry.
   - Added: `await asyncio.sleep(random.uniform(0.5, 0.9))`

3. **Action-to-Speedup Transition (Line 1600)**:
   - Delay after successfully launching a building upgrade and before sending the speedup query.
   - Added: `await asyncio.sleep(random.uniform(0.5, 0.9))`

4. **Tree Prerequisite Candidates Transition (Line 1609)**:
   - Delay between upgrading consecutive prerequisite candidates within the tree.
   - Added: `await asyncio.sleep(random.uniform(0.5, 0.9))`

5. **Castle Pass Transition (Line 1616)**:
   - Delay between successive passes of castle prerequisites resolution.
   - Previous: `await asyncio.sleep(random.uniform(0.5, 1.2))`
   - Updated: `await asyncio.sleep(random.uniform(0.5, 0.9))`

6. **Supportive Buildings Transition (Line 1634)**:
   - Delay between consecutive supportive building upgrades when multiple slots are free.
   - Added: `await asyncio.sleep(random.uniform(0.5, 0.9))`

---

## 3. Event Loop & Safety Protection
- 100% of delay operations use non-blocking `await asyncio.sleep(...)`.
- Zero occurrences of `time.sleep(...)` exist in `tasks/building.py`.
- No timeout or starvation risks introduced to bot background threads.
