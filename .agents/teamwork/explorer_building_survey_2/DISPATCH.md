# Task Assignment: Live Memory & Network Commands Exploration

## Identity & Role
- Archetype: teamwork_explorer
- Working Directory: e:\intqam-sultan\.agents\teamwork\explorer_building_survey_2\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`

## Objectives
1. Thoroughly analyze the live memory structure in `docs/beetoo1_live_memory.json` and `docs/beetoo3_live_memory.json`, as well as `refresh_live_memory.py`:
   - Identify exact live memory paths for buildings in `conn.init_data` (e.g., `cityCtrl`, `buildCtrl`, `buildingCtrl`, or where building levels/status are kept).
   - Identify build queues structure: where are current building queues tracked (how many queues exist, which queue is free, end times, queue types - normal vs second queue/item queue).
   - Identify speedup items in inventory (`bagCtrl`, `backpackCtrl`, or items list): item IDs for building speedups, general speedups, durations (1 min, 5 min, 1 hour, etc.), counts.
   - Identify free speedup mechanisms (free speedup threshold time, VIP level benefits, alliance help status).
2. Analyze network commands (CMDs and SubCMDs) in `tasks/building.py` and across `game_file`:
   - Building upgrade request packet structure (CMD, SubCMD, parameters: building ID, pos, etc.).
   - Speedup item usage packet structure (CMD, SubCMD, item ID, count, target queue/building).
   - Free speedup packet structure (CMD, SubCMD, target queue).
3. Investigate the 0-Network Pre-flight requirements per `GEMINI.md`:
   - How to verify build queues and preconditions from memory without hitting the network.
   - How to synchronize `conn.init_data` in memory after sending upgrade or speedup commands.
   - Propose safe query practices and ban-prevention safeguards.
4. Do NOT modify source code files. Write your findings, mapped paths, and code snippets to `handoff.md` in your working directory.

## Output Requirements
- Maintain `progress.md` with liveness updates.
- Write final report to `e:\intqam-sultan\.agents\teamwork\explorer_building_survey_2\handoff.md`.
- Send completion message to parent when done.

## 2026-10-31T21:09:56Z
[Message] timestamp=2026-10-31T21:09:56Z sender=c697e95d-0dca-48cb-983e-c46b3a40cfde priority=MESSAGE_PRIORITY_HIGH content=You are assigned to explore live memory paths and network commands for the building upgrade task refactoring.
Your working directory is: e:\intqam-sultan\.agents\teamwork\explorer_building_survey_2\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\explorer_building_survey_2\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md and workspace rules at e:\intqam-sultan\GEMINI.md.
Investigate docs/beetoo1_live_memory.json, docs/beetoo3_live_memory.json, refresh_live_memory.py, tasks/building.py, and game_file.
Map exact paths for buildings, build queues, speedup items in inventory, free speedup thresholds, CMD/SubCMD packets, 0-network pre-flight checks, and local memory synchronization.
Produce a comprehensive technical handoff in your handoff.md.
Maintain progress.md with timestamped heartbeats.
When finished, send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde) reporting your handoff path.

## 2026-10-31T21:21:15Z
[Message] timestamp=2026-10-31T21:21:15Z sender=c697e95d-0dca-48cb-983e-c46b3a40cfde priority=MESSAGE_PRIORITY_HIGH content=**Context**: Status check on Live Memory & Network Commands exploration
**Content**: Please report your current progress, update progress.md with your latest visited timestamp, and let us know your estimated completion time for handoff.md.
**Action**: Update progress.md and send status reply.
