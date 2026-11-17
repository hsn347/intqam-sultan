# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db
from tasks.base_task import (
    BaseTask,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_INIT,
    REQ_COMMAND_HALL_COMMIT_TASK,
)

REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = 7

async def main():
    email = "beetoo3@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return

    from tasks.command_hall import CommandHallTask
    task = CommandHallTask(bot.conn)
    
    # 1. Init check
    init_res = await task.get_command_hall_tasks(force_sync=True)
    ch = bot.conn.init_data.get("commandHall", {})
    ag = ch.get("armyGroupTaskData", {})
    print("=== CURRENT ARMY GROUP TASK ===")
    print(json.dumps(ag, indent=2, ensure_ascii=False))

    rabel_hp = ag.get("rabelHp", 1000)
    hurt_hp = ag.get("hurtHp", 0)
    statue = ag.get("statue", 0)
    task_index = ag.get("index", 0)
    task_id = ag.get("taskID", 0)

    print(f"Boss HP: {rabel_hp} | Hurt: {hurt_hp} | Statue: {statue} | Index: {task_index}")

    if hurt_hp >= rabel_hp and statue != 3:
        print("\n🚀 [Step 1] Sending REQ_COMMAND_HALL_ATTACK_ARMY_GROUP (CMD=2274, SubCMD=7)...")
        atk_resp = await task.safe_query(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_ATTACK_ARMY_GROUP, {})
        print("Attack Response:", json.dumps(atk_resp, indent=2, ensure_ascii=False))
        await asyncio.sleep(1.5)

    # Re-check statue
    ch_after = bot.conn.init_data.get("commandHall", {})
    ag_after = ch_after.get("armyGroupTaskData", {})
    statue_after = ag_after.get("statue", 0)
    print(f"Statue after attack: {statue_after}")

    # Statue is now 3 in the server response! Let's commit and claim rewards!
    print(f"\n🎁 [Step 2] Sending REQ_COMMAND_HALL_COMMIT_TASK (CMD=2274, SubCMD=8, commitType=1, index={task_index})...")
    commit_resp = await task.safe_query(
        CMD_COMMAND_HALL_MODULE,
        REQ_COMMAND_HALL_COMMIT_TASK,
        {"commitType": 1, "index": task_index}
    )
    print("Commit Response:", json.dumps(commit_resp, indent=2, ensure_ascii=False))

    # Check updated Command Hall
    print("\n=== COMMAND HALL STATE AFTER COMMIT ===")
    await task.get_command_hall_tasks(force_sync=True)
    ch_final = bot.conn.init_data.get("commandHall", {})
    print("New armyGroupID:", ch_final.get("armyGroupID"))
    print("New nextRefreshTime:", ch_final.get("nextRefreshTime"))
    print("New commonTaskData Count:", len(ch_final.get("commonTaskData", [])))
    print("New armyGroupTaskData:", json.dumps(ch_final.get("armyGroupTaskData"), indent=2, ensure_ascii=False))

    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
