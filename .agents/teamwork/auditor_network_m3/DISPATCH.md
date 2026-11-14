# Task Assignment: Milestone 3 — Network Commands & Game Code Auditor

## Identity & Role
- Archetype: teamwork_auditor
- Working Directory: e:\intqam-sultan\.agents\teamwork\auditor_network_m3\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Game Client Reference: `game_file/src/app/constdef/cmdDef.lua`, `cityCtrl.lua`, `queueCtrl.lua`, `commonSpeedUpBestViewPanel.lua`

## Objectives
1. Audit every single network request (`safe_query`) in `tasks/building.py`:
   - `CMD 1001` / `SubCMD 3`: Upgrade building (`REQ_BUILD_UPGRADE`)
   - `CMD 1001` / `SubCMD 2`: Construct building (`REQ_BUILD_BUILDING`)
   - `CMD 1003` / `SubCMD 2` (`mode: "0"`): Free speedup (`REQ_SPEED_UP_QUEUE`)
   - `CMD 1003` / `SubCMD 2` (`mode: "2"`): Item speedup (`REQ_SPEED_UP_QUEUE`)
   - `CMD 1003` / `SubCMD 1`: Init queue data (fallback only)
   - `CMD 1010` / `SubCMD 45`: Alliance help request
2. Verify exact parameter schema, field names, and value types against official Lua tables.
3. Verify 100% Zero-Gold Guarantee:
   - Confirm that `mode: "1"` is NEVER sent under any condition.
   - Confirm that all upgrade commands specify `mode: "0"`.
   - Confirm that all speedup commands specify `mode: "0"` or `mode: "2"`.
4. Verify Batched Speedup Packets:
   - Verify that multiple speedup items are correctly formatted as a JSON array of `{"id": int, "count": int}` in a single request, matching `commonSpeedUpBestViewPanel.lua`.
5. Render an explicit verdict in your handoff report: `CLEAN` or `INTEGRITY VIOLATION` / `REQUEST_CHANGES`.

## Output Requirements
- Write final report to `e:\intqam-sultan\.agents\teamwork\auditor_network_m3\handoff.md`.
- Send completion message to parent with verdict.


## 2026-10-31T21:56:30Z
You are assigned as the Auditor for Milestone 3: Network Commands & Game Code Matching.
Your working directory is: e:\intqam-sultan\.agents\teamwork\auditor_network_m3\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\auditor_network_m3\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md, workspace rules at e:\intqam-sultan\GEMINI.md, and project architecture at e:\intqam-sultan\.agents\teamwork\PROJECT.md.
Also inspect game_file/src/app/constdef/cmdDef.lua, cityCtrl.lua, queueCtrl.lua, and tasks/building.py.

Audit every network command in tasks/building.py:
- Upgrade: CMD 1001 / SubCMD 3.
- Construct: CMD 1001 / SubCMD 2.
- Speedup: CMD 1003 / SubCMD 2 mode 0 and mode 2.
- Batch speedup array matching commonSpeedUpBestViewPanel.lua.
- 100% Zero-Gold Guarantee: confirm mode "1" is never sent.

Maintain progress.md with timestamped heartbeats.
When finished, write your handoff report to e:\intqam-sultan\.agents\teamwork\auditor_network_m3\handoff.md with an explicit verdict (CLEAN or INTEGRITY VIOLATION / REQUEST_CHANGES) and send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde).
