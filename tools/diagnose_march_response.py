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

async def test_single_march(email="beetoo3@hotmail.com"):
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
    print(f"Subtasks found: {len(task_list)}")
    
    # Find first battle task or pioneer task
    target_task = None
    for t in task_list:
        if t.get("type") in (2, 5) and t.get("statue") == 2:
            target_task = t
            break

    if not target_task:
        print("No eligible march task found!")
        await conn.close()
        return

    coords = task._get_target_coordinates(target_task)
    print(f"Target task: idx={target_task.get('index')}, type={target_task.get('type')}, coords={coords}")

    troops = task._select_march_troops()
    heroes = task._select_combat_heroes()
    print(f"Selected troops: {troops}")
    print(f"Selected heroes: {heroes}")

    target_x, target_y = coords
    task_index = target_task.get("index")
    task_type = target_task.get("type")
    task_id = target_task.get("id") or target_task.get("taskId") or target_task.get("taskID") or task_index
    target_obj = target_task.get("obj")
    target_id = (
        target_task.get("instanceId")
        or target_task.get("id")
        or (target_obj.get("id") if isinstance(target_obj, dict) else None)
        or f"1-{task_id}-{target_x}-{target_y}"
    )

    march_payload = {
        "to": {"x": target_x, "y": target_y},
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
            "to": {"x": target_x, "y": target_y, "id": str(target_id)},
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

    print("\nSending march CMD 1007 / SUBCMD 2...")
    res = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, march_payload)
    print(f"March response:\n{json.dumps(res, indent=2, ensure_ascii=False)}")

    # Check queue in queueCtrl
    q_ctrl = conn.init_data.get("queueCtrl", {})
    print(f"\nqueueCtrl after march: {json.dumps(q_ctrl, ensure_ascii=False)}")

    await conn.close()
    print("Closed.")

if __name__ == "__main__":
    asyncio.run(test_single_march())
