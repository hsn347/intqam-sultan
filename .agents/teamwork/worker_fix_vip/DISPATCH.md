# DISPATCH — worker_fix_vip

You are a teamwork_worker assigned to fix the VIP expired status and build slots logic in `tasks/building.py`.

## Reference Materials
- `tasks/building.py`
- `game_file/src/app/module/lord/lordAuxiliary.lua` (lines 470-485)
- `game_file/src/app/module/lord/lordInfoCtrl.lua` (lines 1100-1110)
- `e:\intqam-sultan\.agents\teamwork\field_tester_m4\handoff.md`

## Mandatory Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Detailed Requirements
1. In `tasks/building.py`, inspect `calculate_max_build_slots()`:
   - Read `vip = lord_info.get("vip", {})`
   - Read `vip_lv = int(vip.get("level", 0) or 0)`
   - Read `vip_end = int(vip.get("vipEndTime", 0) or 0)`
   - VIP second build queue is active ONLY if:
     `vip_lv >= 2 and vip_end > time.time()`
   - If VIP is expired (`vip_end <= 0` or `vip_end <= time.time()`), the VIP slot is locked. Check if temporary build queue item is active (e.g. from bag / items if applicable, or default to 1 slot).
   - Log clearly whether VIP slot is active or expired.
2. In `tasks/building.py`, inspect `calculate_free_speedup_seconds()`:
   - Check `vip_end > time.time()`. If expired, VIP buff privileges must not be applied; return base free speedup (300 seconds).
3. Ensure no syntax errors or regressions. Run static compilation checks:
   `python -m py_compile tasks/building.py`
4. Document all changes and test results in `.agents/teamwork/worker_fix_vip/handoff.md` and send a completion message.
