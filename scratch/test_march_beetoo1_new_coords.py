# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys
import time

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot
from tasks.command_hall import (
    CommandHallTask,
    CMD_KINGDOM_QUEUE_MODULE,
    REQ_ADD_KINGDOM_QUEUE,
    MOVE_LINE_TYPE_COMMAND_HALL_NPC,
    MOVE_LINE_MATRIX_TYPE_TROOP,
)


async def test_march_new_coords():
    email = "beetoo1@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})
    
    # Refresh position first via CMD 2274 / SUBCMD 9
    print("Calling CMD 2274 / SUBCMD 9 to get fresh coords...")
    ref_res = await conn.query("2274", "9", {"x": 928, "y": 1174})
    print("Refresh result:", ref_res)
    new_server_x = ref_res.get("rspdata", {}).get("x", 924)
    new_server_y = ref_res.get("rspdata", {}).get("y", 1167)
    print(f"Fresh server coords: ({new_server_x}, {new_server_y})")

    # Tile coords: server - 1
    tile_x = new_server_x - 1
    tile_y = new_server_y - 1
    print(f"Target tile coords: ({tile_x}, {tile_y})")

    troops = task._select_march_troops(max_capacity=3000)
    heroes = task._select_combat_heroes(max_heroes=1)
    task_index = 4
    task_type = 2
    task_id = 2002

    march_payload = {
        "to": {"x": tile_x, "y": tile_y},
        "moveLineType": MOVE_LINE_TYPE_COMMAND_HALL_NPC,
        "matrixType": MOVE_LINE_MATRIX_TYPE_TROOP,
        "taskIndex": task_index,
        "taskType": task_type,
        "commandHallTaskType": task_type,
        "commandHallTaskID": task_id,
        "army": troops,
        "heroInfo": heroes,
        "armsInfo": [],
        "divineBeastInfo": [],
        "data": {
            "to": {"x": tile_x, "y": tile_y},
            "data": {
                "commandHallTaskType": task_type,
                "commandHallTaskID": task_id,
            },
            "army": troops,
            "heroInfo": heroes,
            "armsInfo": [],
            "divineBeastInfo": [],
            "mapId": 1,
            "isDuel": False,
            "isKillLeaderNpc": False,
            "killNormalNpcLv": 0,
            "isForbidSpeed": False,
            "isSecondaryLock": False,
        },
    }

    t0 = time.time()
    print("Sending march query CMD 1007 / SUBCMD 2...")
    march_res = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, march_payload)
    print("March response:", march_res)
    err = march_res.get("err")
    queue_id = march_res.get("queueId")
    print(f"Result: queueId={queue_id}, err={err}")

    if str(err or "0") == "0":
        print("🎉 March sent successfully! Monitoring arrival and battle resolution...")
        for sec in range(1, 12):
            await asyncio.sleep(1.0)
            elapsed = time.time() - t0
            print(f"  ... elapsed {elapsed:.1f}s")
            if elapsed >= 5.5:
                sync_res = await conn.query("2274", "1", {})
                init_data = sync_res.get("rspdata", {}).get("initData", {}) or sync_res.get("data", {})
                cur_tasks = task._extract_task_list(init_data)
                matched = [t for t in cur_tasks if t.get("index") == task_index]
                if matched:
                    st = matched[0].get("statue")
                    print(f"    Task {task_index} statue = {st}")
                    if st == 3:
                        print("    🎉 Task finished! Claiming reward...")
                        claim_res = await conn.query("2274", "8", {"commitType": task_type, "index": task_index})
                        print("    Reward claimed:", claim_res)
                        break

    await conn.close()


if __name__ == "__main__":
    asyncio.run(test_march_new_coords())
