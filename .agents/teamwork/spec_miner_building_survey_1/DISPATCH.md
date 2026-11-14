# Task Assignment: Specification Mining (Lua Configs & Building Prerequisites)

## Identity & Role
- Archetype: teamwork_spec_miner
- Working Directory: e:\intqam-sultan\.agents\teamwork\spec_miner_building_survey_1\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`

## Objectives
1. Investigate the game configuration files in `game_file/src/app/localtb/config_server/` (specifically `build*.lua`, `building*.lua`, `build_castle*.lua`, `build_wall*.lua`, `build_embassy*.lua`, or any relevant tables).
2. Examine the current prerequisite file: `core/buildings_prereqs.json`.
3. Identify all missing prerequisite entries and data:
   - Castle prerequisite tree up to level 40 (or maximum supported level in Lua).
   - Walls (`wall`) above level 34.
   - Embassy (`embassy`) above level 28.
   - Any other essential buildings prerequisites required for castle progression.
   - Level ceilings, requirements, IDs, and resource/time attributes if present in the Lua tables.
4. Provide a structured and precise JSON schema / specification for how `core/buildings_prereqs.json` should be updated to fill all gaps.
5. Do NOT modify source code or data files directly. Write your comprehensive findings and proposed JSON update to `handoff.md` in your working directory.

## Output Requirements
- Maintain `progress.md` with liveness updates.
- Write final report to `e:\intqam-sultan\.agents\teamwork\spec_miner_building_survey_1\handoff.md`.
- Send completion message to parent when done.


## 2026-10-31T21:09:49Z
[Message from c697e95d-0dca-48cb-983e-c46b3a40cfde]
You are assigned to investigate game configuration files and building prerequisites for the building upgrade task refactoring.
Your working directory is: e:\intqam-sultan\.agents\teamwork\spec_miner_building_survey_1\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\spec_miner_building_survey_1\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md and workspace rules at e:\intqam-sultan\GEMINI.md.
Investigate game_file/src/app/localtb/config_server/build*.lua and core/buildings_prereqs.json.
Identify all missing prerequisite entries and level ceilings (especially castle tree up to lv 40, walls > 34, embassy > 28).
Produce a complete specification report and proposed JSON update in your handoff.md.
Maintain progress.md with timestamped heartbeats.
When finished, send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde) reporting your handoff path.
