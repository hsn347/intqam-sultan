## 2026-10-31T22:55:43Z
Working Directory: e:\intqam-sultan\.agents\teamwork\worker_vip_fix\
Identity: Worker (teamwork_worker)
Parent Conversation ID: 204bd276-4806-4a31-b977-a0879ea65712

MANDATORY FIRST STEP:
Read e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md in full before starting any work.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

CONTEXT & BACKGROUND:
Read:
- e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
- e:\intqam-sultan\.agents\teamwork\PROJECT.md
- e:\intqam-sultan\.agents\teamwork\orchestrator\handoff.md
- e:\intqam-sultan\.agents\teamwork\field_tester_m4\handoff.md

TASK DESCRIPTION:
1. Examine `calculate_max_build_slots()` and `calculate_free_speedup_seconds()` in `tasks/building.py`.
2. Ensure that VIP expiration is rigorously checked against `time.time()`. Handle potential string/int/null/float formats for `vipEndTime`.
3. In `calculate_max_build_slots()`:
   - When VIP is expired (`vipEndTime == 0` or `vipEndTime <= time.time()`), VIP >= 2 must NOT grant slot 2.
   - When queue 1201 is not actively rented in `cityCtrl.queue["1201"]` and not actively building in `queueCtrl["1201"]` or `self.active_queues`, `max_build_slots` must return 1.
4. In `calculate_free_speedup_seconds()`:
   - When VIP is expired (`vipEndTime == 0` or `vipEndTime <= time.time()`), it must safely return `base_free` (300 seconds).
5. Verify syntax and logic by running:
   `python -m py_compile tasks/building.py`
   and write a quick unit test / verification script to confirm both functions return 1 and 300 respectively on expired VIP mock data (like `beetoo1`).
6. Write a comprehensive handoff report to:
   `e:\intqam-sultan\.agents\teamwork\worker_vip_fix\handoff.md`
   and send a completion message back to your parent.
