## 2026-11-01T05:51:56Z
You are a Process Management and Concurrency Implementation Worker.
Your working directory is: e:\intqam-sultan\.agents\teamwork\worker_process_m2\
Your task assignment is Milestone 2: Zombie / Orphan Process & Worker Lifecycle Elimination (Requirement R2).

MANDATORY FIRST STEP:
Read the Original Request at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Read the Project Architecture at: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Read the Process Explorer Handoff at: e:\intqam-sultan\.agents\teamwork\explorer_r2_process\handoff.md
Read the Full Technical Blueprint at: e:\intqam-sultan\.agents\teamwork\explorer_r2_process\analysis.md
Read Workspace Rules at: e:\intqam-sultan\GEMINI.md and e:\intqam-sultan\AGENTS_CONSTITUTION.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Scope & Implementation Steps:
1. `bot_manager.py`:
   - In `CastleBot.run()`: Wrap the entire execution block with `try...finally: await self.stop()` so that cancellation (e.g. `asyncio.CancelledError`) or errors always execute cleanup.
   - In `BotManager.stop_bot()`: Purge stopped bots from memory (`self.bots.pop(email, None)`), remove their task (`self.tasks.pop(email, None)`), and await graceful cancellation.
   - In `BotManager.list_all_bots()`: Only include bots that are actively running (`if bot.is_running`), ensuring stopped castles never linger as zombie processes in `/api/admin/live-processes`.
   - In `BotManager.start_bot()`: Add per-castle `asyncio.Lock` (`_start_locks`) and verify atomic start transitions (`STARTING` -> `RUNNING`), preventing rapid duplicate clicks from spawning duplicate tasks or connections.
2. `core/game_client.py`:
   - In `GameConnection.close()`: Explicitly cancel AND await child tasks (`_recv_task`, `_init_flow_task`, `_heartbeat_task`) with a timeout (`asyncio.wait_for(asyncio.gather(..., return_exceptions=True), timeout=2.0)`).
   - Properly close the underlying transport/stream (`writer.close(); await writer.wait_closed()`) to immediately release OS TCP sockets on Windows.
3. Verification Tool (`tools/test_process_lifecycle.py`):
   - Implement the automated verification script designed in `explorer_r2_process/analysis.md` (zero pip dependencies, using standard library `asyncio`, `socket`, `ctypes`, etc.).
   - Verify:
     a) Active task tracking.
     b) Anti-duplication under rapid start calls.
     c) Immediate task cancellation and removal from `list_all_bots()` upon stop.
     d) 0 lingering child tasks, 0 unattached sockets, and 0 zombie processes.
     e) Rapid start/stop stress cycles (3x).
   - Execute the test script and verify all tests pass with exit code 0.

Output Requirements:
- Write full details, test output, and file diffs to: `e:\intqam-sultan\.agents\teamwork\worker_process_m2\handoff.md`.
- Send a completion message via send_message when done.
