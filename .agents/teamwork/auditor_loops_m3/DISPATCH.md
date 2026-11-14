# Task Assignment: Milestone 3 — Loops (for/while) & If-Conditions Auditor

## Identity & Role
- Archetype: teamwork_auditor
- Working Directory: e:\intqam-sultan\.agents\teamwork\auditor_loops_m3\
- Parent: Project Orchestrator (Conversation ID: c697e95d-0dca-48cb-983e-c46b3a40cfde)

## Mandatory Reading
- Authoritative Request: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md` (Read this first!)
- Workspace Rules: `e:\intqam-sultan\GEMINI.md`
- Target Code: `tasks/building.py`

## Objectives
1. Perform a comprehensive line-by-line static and dynamic audit of ALL loops (`while`, `for`) and conditional branches (`if`, `elif`, `else`) in `tasks/building.py`:
   - Check every `while` loop: verify explicit finite bound (e.g. `passes < 10`), progress advancement, and termination conditions. Ensure ZERO possibility of infinite loop or event loop freeze.
   - Check every `for` loop: verify collection safety, no runtime modification of iterated dictionaries/lists without copy, and bounded iterations.
   - Check recursive tree traversal (`_traverse`): verify visited sets, depth ceilings (e.g. `depth > 8`), cycle detection, and base case termination.
   - Check all `if` statements: verify edge conditions, null-safety (`None`, empty dicts, missing keys), type conversions (`int()`, `str()`), and logical completeness.
   - Check exception handling and fault isolation: ensure unexpected server responses or missing keys cannot crash the castle loop or bot manager.
2. Render an explicit verdict in your handoff report: `CLEAN` or `INTEGRITY VIOLATION` / `REQUEST_CHANGES`.

## Output Requirements
- Write final report to `e:\intqam-sultan\.agents\teamwork\auditor_loops_m3\handoff.md`.
- Send completion message to parent with verdict.


## 2026-10-31T21:56:42Z
[Message] sender=c697e95d-0dca-48cb-983e-c46b3a40cfde priority=MESSAGE_PRIORITY_HIGH
You are assigned as the Auditor for Milestone 3: Loops (for/while) & If-Conditions Safety.
Your working directory is: e:\intqam-sultan\.agents\teamwork\auditor_loops_m3\
Read your task dispatch file at: e:\intqam-sultan\.agents\teamwork\auditor_loops_m3\DISPATCH.md
MANDATORY: Read the authoritative request at e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md, workspace rules at e:\intqam-sultan\GEMINI.md, and project architecture at e:\intqam-sultan\.agents\teamwork\PROJECT.md.
Also inspect tasks/building.py.
