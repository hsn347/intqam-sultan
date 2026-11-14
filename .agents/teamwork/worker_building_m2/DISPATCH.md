# Task Assignment: Milestone 2 — Building Task Core Implementation

## Identity & Role
- Archetype: teamwork_worker
- Working Directory: e:\intqam-sultan\.agents\teamwork\worker_building_m2\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Integrity Warning
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Project Architecture: `e:\intqam-sultan\.agents\teamwork\PROJECT.md`
- Technical Analysis: `e:\intqam-sultan\.agents\teamwork\orchestrator\REPORT_ANALYSIS.md`
- Architecture & Pseudo-code: `e:\intqam-sultan\.agents\teamwork\explorer_building_survey_3\handoff.md`
- Live Memory & Network Packets: `e:\intqam-sultan\.agents\teamwork\explorer_building_survey_2\handoff.md`

## Objectives
1. You have **exclusive write ownership** over `tasks/building.py`. You must NOT touch or modify any other code or test file.
2. Refactor `tasks/building.py` to implement Requirements R1 through R5 in strict compliance with `GEMINI.md`:
   - **0-Network Pre-Flight & Live Memory Sync**:
     - Fix `calculate_max_build_slots`: check `conn.init_data["lordInfoCtrl"]["vip"]["level"] >= 2` and `cityCtrl.queue["1201"]`.
     - Fix `refresh_active_queues`: if `queueCtrl` exists in `conn.init_data`, return active queues immediately without querying `CMD 1003 / 1` when queues are idle.
     - Local memory synchronization upon upgrade (`cityCtrl.blist`, `queueCtrl`, `cityCtrl.reslist`) and upon speedup completion (`backpackCtrl`, `cityCtrl.blist`, `queueCtrl`).
     - Dynamic free speedup seconds from VIP privilege 7201 table (`lordInfoCtrl["vip"]`).
   - **R1: Castle Upgrade & Recursive Prerequisite Tree**:
     - Recursive bottom-up leaf prerequisite collector (`find_ready_prerequisites`).
     - Support 1 or 2 queues simultaneously: assign independent leaf prerequisites to both queues when free.
     - Check internal activity locks (research `1212`, training `1203`-`1206`, healing `1202`) before upgrading.
   - **R2: Acceleration Logic & 5-Building Cycle Limit**:
     - On task entry: if speedup is enabled, accelerate existing active queues first.
     - Greedy speedup solver: building speedups (`5011xx`) -> general speedups (`5006xx`), with 5m tail closure.
     - Batched speedup request: submit all items in a single `CMD 1003 / SubCMD 2 mode "2"` array.
     - Track completed buildings up to exactly 5 buildings per cycle.
     - Insufficient items fallback: consume available items, apply free speedup, leave queue running naturally, set `speedup_exhausted = True`, and exit acceleration loop cleanly.
   - **R3: Fallback & Supportive Buildings**:
     - When speedup is disabled: occupy queues with castle prerequisites without speedup.
     - When castle loop ends and queues remain free and `upgrade_support_buildings` is enabled: upgrade eligible supportive building (lowest level first).
     - STRICT RULE: NO speedup for supportive buildings in the same cycle!
   - **R4: Loop Safety & Zero-Gold Guarantee**:
     - All `while` loops bounded (max 10 iterations for castle loop).
     - Zero-gold guarantee: `mode: "0"` for construction/upgrade, `mode: "0"` or `mode: "2"` for speedup.
3. Verification:
   - Compile cleanly: `python -m py_compile tasks/building.py`.
   - Run offline test: `python test_task_method.py --offline -m docs/beetoo1_live_memory.json --task building run`.
4. Document all changes in `handoff.md` and report completion to parent.

## Output Requirements
- Maintain `progress.md` with liveness updates.
- Write final report to `e:\intqam-sultan\.agents\teamwork\worker_building_m2\handoff.md`.
- Send completion message to parent when done.


## 2026-10-31T21:38:23Z
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

You are assigned as the Worker for Milestone 2: Building Task Core Implementation.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_building_m2\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\worker_building_m2\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md, workspace rules at e:\intqam-sultan\GEMINI.md, and project architecture at e:\intqam-sultan\.agents\teamwork\PROJECT.md.
Also read e:\intqam-sultan\.agents\teamwork\orchestrator\REPORT_ANALYSIS.md, e:\intqam-sultan\.agents\teamwork\explorer_building_survey_3\handoff.md, and e:\intqam-sultan\.agents\teamwork\explorer_building_survey_2\handoff.md.

You have exclusive write ownership over tasks/building.py.
Refactor tasks/building.py to implement:
- 0-Network Pre-Flight & Live Memory Sync (lordInfoCtrl.vip.level >= 2, no CMD 1003/1 query on idle queues).
- R1: Castle upgrade & recursive prerequisite tree (bottom-up leaf collector, 2-queue concurrent allocation).
- R2: Acceleration logic (entry acceleration, batched item speedup, 5-building limit, speedup exhaustion fallback).
- R3: Supportive buildings fallback (strict no-speedup rule for supportive buildings in same cycle).
- R4: Loop safety, finite bounds, zero-gold guarantee.
- R5: Verification via test_task_method.py.

Maintain progress.md with timestamped heartbeats.
When finished, write your handoff report to e:\intqam-sultan\.agents\teamwork\worker_building_m2\handoff.md and send a message back to parent (conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde).


## 2026-10-31T21:48:47Z
**Context**: Milestone 2 Building Task Refactoring status check
**Content**: Please report your current progress on `tasks/building.py`, update `progress.md` with your latest timestamp and completed steps, and let us know your estimated completion time.
**Action**: Update progress.md and send status update.
