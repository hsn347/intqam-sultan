# Task Assignment: Logic, Prerequisite Tree, Loops & Verification Exploration

## Identity & Role
- Archetype: teamwork_explorer
- Working Directory: e:\intqam-sultan\.agents\teamwork\explorer_building_survey_3\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`

## Objectives
1. Examine `tasks/building.py` and `test_task_method.py` in detail:
   - Understand the current architecture of `BuildingTask` and why it needs refactoring.
   - Analyze Requirement R1: Castle upgrade loop & recursive prerequisite tree algorithm:
     - How to traverse dependencies recursively (e.g., Castle Lv N requires Wall Lv N-1, Wall Lv N-1 requires Quarry Lv N-1, etc.).
     - How to pick the deepest unsatisfied available prerequisite first.
     - How to handle 1 vs 2 building queues simultaneously.
   - Analyze Requirement R2: Acceleration logic & 5-building limit:
     - How to accelerate an in-progress building upon cycle entry.
     - How to calculate optimal speedup items (greedy from largest to smallest, or smallest to avoid waste) without wasting speedups or leaving queue hanging if speedup completes it.
     - When speedup items are insufficient, consume available, stop, and do NOT hang or loop infinitely.
     - Count accelerated buildings (max 5 per cycle).
   - Analyze Requirement R3: Fallback & Supportive buildings:
     - When speedup is disabled: occupy available queues with prerequisites without speedup.
     - When castle and all prerequisites are blocked or completed and a queue remains empty, fallback to supportive buildings.
     - Strict rule: NO speedup for supportive buildings in the same cycle!
   - Analyze Requirement R4: Loop safety & resource protection:
     - Audit all proposed `while` and `for` loops, loop termination conditions, timeout guards, and resource limits (no CPU lock, no memory leak).
   - Analyze Requirement R5: Field verification methodology:
     - How `test_task_method.py` invokes `building` task and what arguments/flags are needed.
2. Formulate a comprehensive architecture proposal and pseudo-code/control flow.
3. Do NOT modify source code files. Write your findings to `handoff.md` in your working directory.

## Output Requirements
- Maintain `progress.md` with liveness updates.
- Write final report to `e:\intqam-sultan\.agents\teamwork\explorer_building_survey_3\handoff.md`.
- Send completion message to parent when done.
