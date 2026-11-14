# Task Assignment: Milestone 1 — Prerequisite Data Regeneration

## Identity & Role
- Archetype: teamwork_worker
- Working Directory: e:\intqam-sultan\.agents\teamwork\worker_data_m1\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Project Architecture: `e:\intqam-sultan\.agents\teamwork\PROJECT.md`
- Spec Miner Findings & Algorithm: `e:\intqam-sultan\.agents\teamwork\spec_miner_building_survey_1\handoff.md`

## Objectives
1. You have **exclusive write ownership** over `core/buildings_prereqs.json`. You must NOT touch or modify any other code file.
2. Read the verified parsing algorithm and findings in `spec_miner_building_survey_1/handoff.md` (Section 6.1).
3. Implement the script to parse all 30 building configuration files (`build101.lua` through `build305.lua`) in `game_file/src/app/localtb/config_server/`.
4. Generate the clean, complete `core/buildings_prereqs.json`:
   - All 30 building IDs present as strings (`"101"` to `"305"`).
   - Total levels increased from 879 to ~3,127 levels.
   - Castle (`101`) levels up to 40+ and up to 130.
   - Walls (`102`) levels up to 50+ and up to 130 (resolving the missing levels > 34).
   - Embassy (`111`) levels up to 50+ and up to 130 (resolving missing levels > 28).
   - Sultan's Glory (`301`) levels up to 50+ and up to 130.
   - All corrupt keys (`"420000"`, `"450000"`, `"640000"`, `"1350"`, `"260"`, `"580"`, `"64500"`) completely eliminated.
   - `preCond` accurately parsed as odd/even pairs `[1]=bid, [2]=lv` without empty dicts for valid levels.
5. Run automated verification on `core/buildings_prereqs.json`:
   - Check JSON validity.
   - Check level ceilings and verify absence of corrupted keys.
   - Verify that `tasks/building.py` can load `core/buildings_prereqs.json` cleanly.
6. Write your complete handoff report to `handoff.md` in your working directory and notify the parent orchestrator upon completion.

## Output Requirements
- Maintain `progress.md` with liveness updates.
- Write final report to `e:\intqam-sultan\.agents\teamwork\worker_data_m1\handoff.md`.
- Send completion message to parent when done.

## 2026-10-31T21:29:15Z
[Message] timestamp=2026-10-31T21:29:15Z sender=c697e95d-0dca-48cb-983e-c46b3a40cfde priority=MESSAGE_PRIORITY_HIGH
content=DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

You are assigned as the Worker for Milestone 1: Prerequisite Data Regeneration.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_data_m1\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\worker_data_m1\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md, workspace rules at e:\intqam-sultan\GEMINI.md, and project architecture at e:\intqam-sultan\.agents\teamwork\PROJECT.md.
Also read the verified parsing algorithm and findings in e:\intqam-sultan\.agents\teamwork\spec_miner_building_survey_1\handoff.md.

You have exclusive write ownership over core/buildings_prereqs.json.
Regenerate core/buildings_prereqs.json from game_file/src/app/localtb/config_server/build*.lua for all 30 buildings up to Lv.130, filling walls > 34, embassy > 28, castle tree, and eliminating all corrupted keys.
Run programmatic verification checks on the output JSON.
Maintain progress.md with timestamped heartbeats.
When finished, write your handoff report to e:\intqam-sultan\.agents\teamwork\worker_data_m1\handoff.md and send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde).
