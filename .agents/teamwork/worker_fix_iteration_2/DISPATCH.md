# Task Assignment: Milestone 2 — Remediation Iteration 2 (tasks/building.py)

## Identity & Role
- Archetype: teamwork_worker
- Working Directory: e:\intqam-sultan\.agents\teamwork\worker_fix_iteration_2\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Gate Fail Status: `e:\intqam-sultan\.agents\teamwork\orchestrator\GATE_STATUS.md`
- Reviewer Findings: `e:\intqam-sultan\.agents\teamwork\reviewer_logic_m3\handoff.md`
- Loops Auditor Findings: `e:\intqam-sultan\.agents\teamwork\auditor_loops_m3\handoff.md`
- Memory Auditor Findings: `e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\handoff.md`

## Objectives
You have **exclusive write ownership** over `tasks/building.py`. Apply the required fixes identified by the 3 specialized auditors:

1. **Fix Critical Queue Allocation & Ghost Speedup in `tasks/building.py`**:
   - In `execute_building_action`, determine `allocated_qtype` and return `(True, act_msg, allocated_qtype)`.
   - In `run()` around line 1444, capture `ok_up, up_msg, allocated_qtype = await self.execute_building_action(cand)` and pass this exact `allocated_qtype` to `self.accelerate_queue_to_completion(allocated_qtype)`. DO NOT re-calculate `allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"` after the queue has already been added to `self.active_queues`!
   - In `accelerate_queue_to_completion(qtype)` around line 1102: if `not q_info`, return `False, 0, "الطابور فارغ بالفعل"` (NOT `True`). This prevents ghost speedups on empty queues.

2. **Fix In-Memory Resource Deficit Calculation in `tasks/building.py`**:
   - In `execute_building_action` (and `construct_missing_building`):
     Before calling `self.ensure_resources`, check `cityCtrl.reslist`.
     Calculate actual deficit:
     ```python
     city = self._get_city_ctrl()
     reslist = city.get("reslist", {}) or city.get("resList", {})
     missing_res = {r_id: int(float(amt) - float(reslist.get(str(r_id), 0) or 0))
                    for r_id, amt in cost_res.items()
                    if float(reslist.get(str(r_id), 0) or 0) < float(amt)}
     if missing_res and bool(self.config.get("auto_open_chests", True)):
         res_result = await self.ensure_resources(missing_res, multiplier=1)
         if not res_result.get("success", False):
             ...
     ```
     If `missing_res` is empty, skip `ensure_resources` entirely (0 network calls, 0 chests opened).

3. **Fix Multi-Instance In-Memory Sync**:
   - In `sync_in_memory_completed_queue(qtype, bid, index=None)`:
     When locating the building instance in `cityCtrl.blist`:
     If `index` is provided: match `str(b.get("binfo", {}).get("index")) == str(index)`.
     Otherwise: match `str(b.get("binfo", {}).get("bid")) == str(bid) and str(b.get("binfo", {}).get("state")) == "2"`.
     This ensures that multi-instance buildings (Farms, Sawmills, Tents) do not mutate an idle building while leaving the upgrading building stuck in state "2".

4. **Fix 0-Network Leak in `construct_missing_building`**:
   - Line 758: remove `await self.refresh_active_queues(force_query=True)`.
   - Instead, synchronize in-memory state:
     `self.sync_in_memory_upgrade(allocated_qtype, bid_str, 1, str(target_index), cost_time, cost_res)`.

5. **Minor Safety Guards**:
   - Guard `cityCtrl.blist` loops with `if isinstance(b, dict):`.
   - In `format_duration(seconds)`, use `int(max(0, seconds or 0))`.
   - In line 1010, check `float(instance.get("curres", 0) or 0) > 0` before calling `harvest_building_resource`.

6. **Verification**:
   - Run `python -m py_compile tasks/building.py`.
   - Run the reproduction tests from `reviewer_logic_m3/handoff.md` and `auditor_memory_m3/handoff.md` to confirm all 5 defects are completely resolved.
   - Write full report to `handoff.md`.

## Output Requirements
- Maintain `progress.md`.
- Write final report to `e:\intqam-sultan\.agents\teamwork\worker_fix_iteration_2\handoff.md`.
- Send completion message to parent when done.

## 2026-10-31T22:17:47Z
**Context**: Status check on Milestone 2 Remediation Iteration 2
**Content**: Please report your progress on applying the 5 fixes in `tasks/building.py`, update `progress.md` with your latest timestamp and completed steps, and let us know your estimated completion time.
**Action**: Update progress.md and send status update.

