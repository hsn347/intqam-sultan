# Task Assignment: Milestone 3 — Live Memory Paths & 0-Network Auditor

## Identity & Role
- Archetype: teamwork_auditor
- Working Directory: e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Live Memory Reference: `docs/beetoo1_live_memory.json`, `docs/beetoo3_live_memory.json`
- Live Memory Dump Tool: `refresh_live_memory.py`

## Objectives
1. Perform a microscopic audit of every query, access, and modification of live memory (`conn.init_data`) in `tasks/building.py`:
   - Inspect buildings path: `conn.init_data["cityCtrl"]["blist"]`
   - Inspect resources path: `conn.init_data["cityCtrl"]["reslist"]`
   - Inspect queues path: `conn.init_data["queueCtrl"]` (1200 / 1201)
   - Inspect second builder queue rental: `conn.init_data["cityCtrl"]["queue"]["1201"]`
   - Inspect VIP path: `conn.init_data["lordInfoCtrl"]["vip"]["level"]` and `vipEndTime`
   - Inspect inventory items: `conn.init_data["backpackCtrl"]`
2. Audit 0-Network Pre-flight:
   - Verify that when `queueCtrl` is present in memory and queues are idle, NO network query (`CMD 1003 / 1`) is fired.
   - Verify that in-memory synchronization functions (`sync_in_memory_upgrade`, `sync_in_memory_completed_queue`, `sync_in_memory_consumed_items`) accurately update all affected memory keys locally without needing network refresh.
   - Suggest any additional opportunities to replace network queries with live memory data.
3. Render an explicit verdict in your handoff report: `CLEAN` or `INTEGRITY VIOLATION` / `REQUEST_CHANGES`.

## Output Requirements
- Write final report to `e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\handoff.md`.
- Send completion message to parent with verdict.


## 2026-10-31T21:56:15Z
[Message] sender=c697e95d-0dca-48cb-983e-c46b3a40cfde priority=MESSAGE_PRIORITY_HIGH
Content: You are assigned as the Auditor for Milestone 3: Live Memory Paths & 0-Network Pre-Flight.
Your working directory is: e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md, workspace rules at e:\intqam-sultan\GEMINI.md, and project architecture at e:\intqam-sultan\.agents\teamwork\PROJECT.md.
Also inspect docs/beetoo1_live_memory.json, docs/beetoo3_live_memory.json, and tasks/building.py.

Audit every single live memory path and query in tasks/building.py:
- cityCtrl.blist, reslist, queueCtrl, cityCtrl.queue["1201"], lordInfoCtrl.vip.level.
- Verify 0-Network Pre-flight: confirm idle queues return with 0 network calls.
- Verify in-memory synchronization functions accurately reflect state changes locally.
- Suggest replacing any remaining network queries with live memory data if possible.

Maintain progress.md with timestamped heartbeats.
When finished, write your handoff report to e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\handoff.md with an explicit verdict (CLEAN or INTEGRITY VIOLATION / REQUEST_CHANGES) and send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde).
