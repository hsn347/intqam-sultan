# BRIEFING — 2026-10-31T23:03:00Z

## Mission
Fix VIP expiration checks in `tasks/building.py` for `calculate_max_build_slots()` and `calculate_free_speedup_seconds()`.

## 🔒 My Identity
- Archetype: worker
- Roles: implementer, qa
- Working directory: e:\intqam-sultan\.agents\teamwork\worker_vip_fix\
- Original parent: 204bd276-4806-4a31-b977-a0879ea65712
- Milestone: Milestone 4 - Building VIP & Slot Verification

## 🔒 Key Constraints
- Rigorous check against `time.time()`. Handle potential string/int/null/float formats for `vipEndTime`.
- When VIP is expired (`vipEndTime == 0` or `vipEndTime <= time.time()`), VIP >= 2 must NOT grant slot 2.
- When queue 1201 is not actively rented in `cityCtrl.queue["1201"]` and not actively building in `queueCtrl["1201"]` or `self.active_queues`, `max_build_slots` must return 1.
- In `calculate_free_speedup_seconds()`: expired VIP must safely return `base_free` (300 seconds).
- Minimal changes, transparent direct editing via edit tool, no fake test assertions.

## Current Parent
- Conversation ID: 204bd276-4806-4a31-b977-a0879ea65712
- Updated: 2026-10-31T23:03:00Z

## Task Summary
- **What to build**: Fix VIP expiration checking in `calculate_max_build_slots` and `calculate_free_speedup_seconds` in `tasks/building.py`.
- **Success criteria**: Python compilation succeeds, expired VIP correctly falls back to 1 slot and 300s speedup, active VIP works properly, robust against type variations.
- **Interface contracts**: `tasks/building.py`

## Change Tracker
- **Files modified**:
  - `tasks/building.py`: Added `_is_vip_active()` helper with multi-type parsing, updated `calculate_free_speedup_seconds()` and `calculate_max_build_slots()` to strictly verify VIP activity, active rental, and active building status.
  - `test_vip_slots_speedup.py`: Independent unit test covering 8 test scenarios.
- **Build status**: PASS (`python -m py_compile tasks/building.py` passed cleanly).
- **Pending issues**: None.

## Quality Status
- **Build/test result**: PASS (8/8 tests passed in `test_vip_slots_speedup.py`, offline run in `test_task_method.py` passed).
- **Lint status**: Clean.
- **Tests added/modified**: `test_vip_slots_speedup.py` created with 8 unit tests.
