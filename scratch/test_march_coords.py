# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

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

async def test_march_client_coords(email="beetoo3@hotmail.com"):
    print(f"Connecting to {email}...")
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})
    hall_data = await task._ensure_synced_data(force_network=True)
    task_list = task._extract_task_list(hall_data)
    
    target_task = None
    for t in task_list:
        if t.get("type") in (2, 5) and t.get("statue") == 2:
            target_task = t
            break

    if not target_task:
        print("No eligible march task found!")
        await conn.close()
        return

    raw_coords = task._get_target_coordinates(target_task)
    print(f"Server obj coords: {raw_coords}")
    
    # Test 1: tile coords = (server_x - 1, server_y - 1)
    tile_x = raw_coords[0] - 1
    tile_y = raw_coords[1] - 1
    print(f"Testing client tile coords: ({tile_x}, {tile_y})")

    troops = task._select_march_troops(max_capacity=100) # send minimal troops
    heroes = task._select_combat_heroes(max_heroes=1)
    task_index = target_task.get("index")
    task_type = target_task.get("type")
    task_id = target_task.get("id") or target_task.get("taskId") or target_task.get("taskID") or task_index

    # Let's test what instanceID should be: does it need target_id or empty or string?
    # In worldMapCommandHallNpcViewPanel:
    # otherData.commandHallTaskType = self.taskType
    # otherData.commandHallTaskID = self.taskID
    # instanceID is nil (so to.id was nil or empty)
    
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

    print("\nSending march with client tile coordinates...")
    res = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, march_payload)
    print(f"March response:\n{json.dumps(res, indent=2, ensure_ascii=False)}")

    # Check queueCtrl
    q_ctrl = conn.init_data.get("queueCtrl", {})
    print(f"\nqueueCtrl: {json.dumps(q_ctrl, ensure_ascii=False)}")

    await conn.close()
    print("Closed.")

if __name__ == "__main__":
    asyncio.run(test_march_client_coords())
