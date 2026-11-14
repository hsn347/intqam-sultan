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


async def test_lucifer():
    email = "LUCIFER@g4.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})

    # Fresh coordinates from CMD 2274 / SUBCMD 9: server (827, 821)
    # Tile coords: (827 - 1, 821 - 1) = (826, 820)
    server_x, server_y = 827, 821
    tile_x, tile_y = server_x - 1, server_y - 1
    task_index = 6713
    task_type = 5
    task_id = 5051

    troops = task._select_march_troops(max_capacity=3000)
    heroes = task._select_combat_heroes(max_heroes=1)

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
    print(f"Sending march query CMD 1007 / SUBCMD 2 to Tile ({tile_x}, {tile_y})...")
    march_res = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, march_payload)
    print("March response:", march_res)
    err = march_res.get("err")
    queue_id = march_res.get("queueId")
    print(f"Result: queueId={queue_id}, err={err}")

    assert str(err or "0") == "0", f"Error returned: {err}"
    assert queue_id, "No queueId!"

    print("🎉 March sent successfully! Monitoring arrival and battle resolution (< 10s)...")
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
                    print("    🎉 Task finished (statue == 3)! Claiming reward via CMD 2274 / SUBCMD 8...")
                    claim_res = await conn.query("2274", "8", {"commitType": task_type, "index": task_index})
                    print("    Reward claimed:", claim_res)
                    break

    await conn.close()


if __name__ == "__main__":
    asyncio.run(test_lucifer())
