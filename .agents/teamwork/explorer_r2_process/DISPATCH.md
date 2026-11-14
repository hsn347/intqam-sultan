## 2026-11-01T05:29:57Z
You are a Codebase Researcher specializing in Operating System Process Management, Lifecycle, and Concurrency.
Your working directory is: e:\intqam-sultan\.agents\teamwork\explorer_r2_process\
Your task assignment is detailed below.

MANDATORY FIRST STEP:
Read the Original Request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Also read project constitution rules at: e:\intqam-sultan\GEMINI.md and e:\intqam-sultan\AGENTS_CONSTITUTION.md

Objective:
Investigate and provide complete technical blueprints for Requirement R2:
"Zombie / Orphan Process Lifecycle Elimination:
- Ensure no background worker or live process remains running unless it is actively attached to a running castle.
- Cleanly terminate all associated processes and workers when a castle is stopped, eliminating any orphan or zombie operating system processes.
- Prevent duplicate or unattached process spawning."

Your Investigation Must Determine:
1. Current Process & Worker Architecture:
   - How are castle bots and tasks started, stopped, and managed? Inspect `bot_manager.py`, `api_server.py`, `main.py`, and any other scripts.
   - Are castles running as `asyncio` tasks inside the main Python process, or are there OS subprocesses (e.g. `multiprocessing`, `subprocess.Popen`)?
   - Are there any child processes spawned by tasks or connection drivers? (Check network connections, WebSocket/TCP connections, browser drivers if any, thread pools, executor tasks).
2. Root Causes of Orphan/Zombie Processes:
   - What happens when a user clicks "Stop" on a castle or calls `/api/castles/{id}/stop`?
   - How are asyncio tasks cancelled? Does cancellation wait for cleanup (`task.cancel()`, `await task` with timeout)?
   - Can sockets, threads, or subprocesses linger after castle stop?
   - What happens if the server itself is stopped or reloaded (e.g. uvicorn reload, SIGINT, SIGTERM, crash)?
   - Can duplicate castle bots be spawned if a start request is sent multiple times or while a castle is in a transition state?
3. Elimination & Clean Termination Strategy on Windows:
   - Note the host OS is Windows (`win32`).
   - How to track all active processes, subprocesses, threads, and tasks per castle ID?
   - How to ensure atomic transition states (STOPPING, STOPPED, STARTING, RUNNING) to prevent race conditions and duplicate spawning?
   - How to perform forceful cleanup of any lingering OS sockets or child processes (using `psutil` or Windows process termination APIs) if graceful cancellation fails?
4. Verification Script Design in `tools/`:
   - Design an automated verification script (e.g. `tools/test_process_lifecycle.py`) that can:
     a) Check system process table before starting castles.
     b) Start castles, verify active tracking.
     c) Stop castles, verify immediate and clean termination of all tasks, sockets, and subprocesses.
     d) Confirm zero orphan/zombie processes remain.

Output Requirements:
- Write your detailed analysis to: e:\intqam-sultan\.agents\teamwork\explorer_r2_process\analysis.md
- Write your final handoff report to: e:\intqam-sultan\.agents\teamwork\explorer_r2_process\handoff.md
- Include exact file paths, line numbers, and concrete code blueprints.
- Send a completion message via send_message when done.
