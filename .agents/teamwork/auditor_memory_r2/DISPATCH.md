# Task Assignment: Milestone 3 Iteration 2 — Live Memory & 0-Network Re-Audit

## Identity & Role
- Archetype: teamwork_auditor
- Working Directory: e:\intqam-sultan\.agents\teamwork\auditor_memory_r2\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Project Architecture: `e:\intqam-sultan\.agents\teamwork\PROJECT.md`
- Worker Remediation Report: `e:\intqam-sultan\.agents\teamwork\worker_fix_iteration_2\handoff.md`
- Previous Memory Audit: `e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\handoff.md`

## Objectives
1. Inspect the updated `tasks/building.py` and run `.agents/teamwork/auditor_memory_m3/test_audit_memory.py`.
2. Verify that the previous defects are 100% resolved:
   - Multi-instance in-memory building sync: `sync_in_memory_completed_queue` resolves target instance by `index` or `state == "2"`.
   - 0-Network leak in construction: `construct_missing_building` line 758 no longer calls `force_query=True`, using local `sync_in_memory_upgrade`.
   - Harvest check: `harvest_building_resource` only called if `float(instance.get("curres", 0) or 0) > 0`.
   - 0-Network Pre-Flight on idle and busy queues remains 100% clean (0 network calls).
3. Run verification against `docs/beetoo1_live_memory.json` and `docs/beetoo3_live_memory.json`.
4. Render an explicit binary verdict in your handoff report: `CLEAN` or `INTEGRITY VIOLATION` / `REQUEST_CHANGES`.

## Output Requirements
- Write final report to `e:\intqam-sultan\.agents\teamwork\auditor_memory_r2\handoff.md`.
- Send completion message to parent with verdict.

## 2026-10-31T22:22:53Z
You are assigned as Auditor for Milestone 3 Iteration 2: Live Memory & 0-Network Re-Audit.
Your working directory is: e:\intqam-sultan\.agents\teamwork\auditor_memory_r2\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\auditor_memory_r2\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md, workspace rules at e:\intqam-sultan\GEMINI.md, and project architecture at e:\intqam-sultan\.agents\teamwork\PROJECT.md.
Also read e:\intqam-sultan\.agents\teamwork\worker_fix_iteration_2\handoff.md and e:\intqam-sultan\.agents\teamwork\auditor_memory_m3\handoff.md.

Re-audit tasks/building.py and run .agents/teamwork/auditor_memory_m3/test_audit_memory.py:
- Verify multi-instance in-memory building sync (matching index or state == "2").
- Verify 0-network leak in construction removed (local sync_in_memory_upgrade).
- Verify harvest curres > 0 check.
- Verify 0-Network Pre-Flight on idle and busy queues.

Maintain progress.md with timestamped heartbeats.
When finished, write your handoff report to e:\intqam-sultan\.agents\teamwork\auditor_memory_r2\handoff.md with an explicit verdict (CLEAN or INTEGRITY VIOLATION / REQUEST_CHANGES) and send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde).
