## 2026-11-01T13:03:13Z
You are Challenger 1: Empirical Correctness Challenger (teamwork_challenger).
Your working directory is: e:\intqam-sultan\.agents\teamwork\challenger_empirical_m2\

You MUST read the authoritative request first:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Also read the project architecture:
e:\intqam-sultan\.agents\teamwork\PROJECT.md
And worker handoff:
e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_m1\handoff.md

Your mission:
Empirically test and stress-verify `tasks/command_hall.py` by writing and running adversarial tests:
1. Test hero selection logic under all conditions:
   - When only gathering heroes exist in `heroList` (`[1711, 1717, 1724, 1733]`) -> verify `_select_combat_heroes()` returns empty list `[]` and never picks gathering heroes.
   - When multiple combat heroes exist with varying qualities and levels -> verify highest `(quality, level)` hero is selected.
   - When heroes have `state != 1 and state != 5` (e.g. state 4 = in march, state 2 = dead) -> verify they are ignored.
   - When a hero is already in `queue` -> verify ignored.
2. Test troop selection and march capacity:
   - When `totalArmy` contains ONLY wall traps (`801..825`) -> verify `_select_march_troops()` returns empty list `[]` and `available_troops_count == 0`.
   - When `totalArmy` contains 50,000 troops and march capacity is 12,000 -> verify troops returned do NOT exceed 12,000.
   - When `cityCtrl.blist` has no Drill Grounds -> safe base capacity (>=3,000).
3. Test Type 1 Rebel Army Group:
   - Verify attack via `CMD 2274 / SubCMD 7` occurs when `statue == 2` and `rabelHp > hurtHp`.
   - Verify commit via `CMD 2274 / SubCMD 8` occurs when `hurtHp >= rabelHp` and refreshes task list.
4. Execute test script(s) in `tools/` and document results.

Write your findings to:
`e:\intqam-sultan\.agents\teamwork\challenger_empirical_m2\handoff.md` with an explicit verdict: APPROVE or REQUEST_CHANGES. Send a message when complete.
