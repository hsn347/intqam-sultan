## 2026-10-31T12:05:52Z
You are Challenger 1: Task Adversarial Challenger.
Your Working Directory: e:\intqam-sultan\.agents\teamwork\challenger_stress_1\
Original Request Reference: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Project Reference: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Implementation File: tasks/forge_equipment.py

Task:
You are an adversarial verifier. Your job is to try to break `ForgeEquipmentTask`:
1. Write a dedicated stress-test script in your working directory `stress_test.py` that tests:
   - Malformed/corrupted live memory: `conn.init_data` is empty, None, or missing `equipmentCtrl`, `backpackCtrl`, `cityCtrl`, or `everydayTaskCtrl`.
   - Extreme resource conditions: 0 steel, negative steel, 0 materials, missing materials, all materials rare/high-tier only.
   - Missing base equipment in bag for high-tier recipes: verify graceful fallback to Level 1 without crashing.
   - Malformed config: category is None, empty string, integer, or unknown name (e.g. "laser_gun") — verify safe fallback to "weapon".
   - Fault isolation: ensure `safe_execute()` never leaks unhandled exceptions to `bot_manager`.
   - 0-Network invariant: assert with mock network that when pre-flight condition is met, exactly 0 query/network calls are made.
2. Execute your stress-test script.
3. Report all findings, pass/fail metrics, and an unequivocal verdict: `APPROVE` or `REJECT`.

Produce your structured handoff report at: `e:\intqam-sultan\.agents\teamwork\challenger_stress_1\handoff.md`.
When done, send a message to your orchestrator (parent).
