## 2026-11-01T14:25:27Z
You are teamwork_spec_miner.
Your working directory is: e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_lifecycle\
You MUST read the authoritative request file at: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

Your role is to deeply analyze the official game client Lua source code in `game_file/` (e.g. `game_file/src/app/module/commandHall/`, `game_file/src/app/manager/`, `game_file/src/app/network/`, `game_file/src/app/constdef/`, etc.) to uncover the exact, authoritative lifecycle of Command Hall tasks:

1. Task Status / Statue lifecycle:
   - What are all possible values of `statue` (or `status`) for Command Hall subtasks? (e.g., 0, 1, 2, 3...)
   - What does each value mean in Lua? When does a task transition to completed / ready to claim?
   - Cite exact file paths and line numbers.

2. Marching Tasks Lifecycle (Types 2 & 5: REBEL_ARMY_PIONEER_TASK and BATTLE_TASK):
   - When CMD 1007 SubCMD 2 is dispatched with moveLineType = 15, how does the game client track this march?
   - Where in client data structures does this march appear (e.g. queueCtrl, marchingTeams, worldMapQueue)?
   - How does the client know when the march arrives at the target or completes battle?
   - Does the server send push packets, or does the client calculate arrival time from start/end times, or does it poll?

3. Sync and Reward Claiming Protocol:
   - When does the game client send CMD 2274 SubCMD 1 (REQ_COMMAND_HALL_INIT)? Does it send it after a march finishes or battle concludes?
   - How does the game client claim rewards via CMD 2274 SubCMD 8 (REQ_COMMAND_HALL_COMMIT_TASK)? What are commitType and index?
   - What rewards are returned and how is live memory updated?

4. Task Renewal and Army Group Progression:
   - When the Rebel Army Group (Type 1) is defeated (hurtHp >= rabelHp or statue == 3), what packet is sent?
   - How does advancing armyGroupID refresh the task list?
   - Are there wave timers (e.g. freshTime, CD) between waves, or is renewal instant upon claiming?

Write your detailed analysis to `e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_lifecycle\analysis.md` and summarize your findings in `e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_lifecycle\handoff.md`.
Send a completion message back when done.
