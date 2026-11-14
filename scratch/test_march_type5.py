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

async def test_type5_variations(email="beetoo3@hotmail.com"):
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})
    hall_res = await conn.query("2274", "1", {})
    init_data = hall_res.get("rspdata", {}).get("initData", {})
    task_list = task._extract_task_list(init_data)
    
    t = [x for x in task_list if x.get("type") == 5 and x.get("statue") == 2][0]
    idx = t.get("index")
    tp = t.get("type")
    tid = t.get("taskID")
    obj = t.get("obj", {})
    sx = int(obj.get("x", 0))
    sy = int(obj.get("y", 0))
    tx = sx - 1
    ty = sy - 1
    
    troops = task._select_march_troops(max_capacity=100)
    heroes = task._select_combat_heroes(max_heroes=1)
    
    # Variation 1: without 'id' in data.to
    payload1 = {
        "to": {"x": tx, "y": ty},
        "moveLineType": MOVE_LINE_TYPE_COMMAND_HALL_NPC,
        "matrixType": MOVE_LINE_MATRIX_TYPE_TROOP,
        "taskIndex": idx,
        "taskType": tp,
        "commandHallTaskType": tp,
        "commandHallTaskID": tid,
        "army": troops,
        "heroInfo": heroes,
        "armsInfo": [],
        "divineBeastInfo": [],
        "data": {
            "to": {"x": tx, "y": ty},
            "data": {
                "commandHallTaskType": tp,
                "commandHallTaskID": tid,
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
    res1 = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, payload1)
    print(f"Var 1 (no id in data.to): err={res1.get('err')}, queueId={res1.get('queueId')}")

    # Variation 2: id with tile coords: f"1-{tid}-{tx}-{ty}"
    if res1.get("err"):
        target_id2 = f"1-{tid}-{tx}-{ty}"
        payload1["data"]["to"]["id"] = target_id2
        res2 = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, payload1)
        print(f"Var 2 (id {target_id2}): err={res2.get('err')}, queueId={res2.get('queueId')}")

    # Variation 3: Check how WorldDispatchArmyView sets otherData
    # In worldMapCommandHallNpcViewPanel:
    # otherData.commandHallTaskType = self.taskType
    # otherData.commandHallTaskID = self.taskID
    # otherData.commandHallTaskIndex = self.taskIndex
    if res1.get("err"):
        payload1["data"]["data"]["commandHallTaskIndex"] = idx
        payload1["commandHallTaskIndex"] = idx
        res3 = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, payload1)
        print(f"Var 3 (with commandHallTaskIndex): err={res3.get('err')}, queueId={res3.get('queueId')}")

    await conn.close()

if __name__ == "__main__":
    asyncio.run(test_type5_variations())
