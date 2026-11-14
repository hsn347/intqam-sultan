# -*- coding: utf-8 -*-
"""
tools/test_live_march_listener.py
Empirical listener to monitor live gateway packets during march dispatch, travel,
and battle resolution.
"""

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


async def live_march_test(email="beetoo3@hotmail.com"):
    print(f"\n{'='*75}\n⚔️ [LIVE MARCH LISTENER] Testing: {email}\n{'='*75}")
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    # Inspect current state
    task = CommandHallTask(conn, config={"enabled": True})
    hall_res = await conn.query("2274", "1", {})
    init_data = hall_res.get("rspdata", {}).get("initData", {}) or hall_res.get("data", {})
    task_list = task._extract_task_list(init_data)
    
    print(f"Subtasks count: {len(task_list)}")
    battle_tasks = [t for t in task_list if t.get("type") in (2, 5) and t.get("statue") == 2]
    print(f"Available battle tasks: {len(battle_tasks)}")
    for bt in battle_tasks:
        print(f"  • Task index={bt.get('index')}, type={bt.get('type')}, taskID={bt.get('taskID')}, obj={bt.get('obj')}")

    if not battle_tasks:
        print("No battle tasks available!")
        await conn.close()
        return

    target_task = battle_tasks[0]
    task_index = target_task.get("index")
    task_type = target_task.get("type")
    task_id = target_task.get("taskID") or target_task.get("taskId") or target_task.get("id") or task_index
    obj = target_task.get("obj", {})
    server_x = int(obj.get("x", 0))
    server_y = int(obj.get("y", 0))
    
    # Client tile coordinates (server - 1)
    tile_x = server_x - 1
    tile_y = server_y - 1

    troops = task._select_march_troops(max_capacity=3000)
    heroes = task._select_combat_heroes(max_heroes=1)
    print(f"\nDispatching to task {task_index} (Type {task_type}):")
    print(f"  • Server coords: ({server_x}, {server_y}) -> Tile coords: ({tile_x}, {tile_y})")
    print(f"  • Troops: {sum(t['num'] for t in troops)} units {troops}")
    print(f"  • Hero: {heroes}")

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

    # Listen to incoming packets
    received_packets = []
    orig_on_message = getattr(conn, "_on_message", None)

    def packet_hook(packet):
        cmd = packet.get("cmd")
        subcmd = packet.get("subcmd")
        if cmd or subcmd:
            received_packets.append(packet)
            print(f"  📩 INCOMING PACKET: cmd={cmd}, subcmd={subcmd}, err={packet.get('err')}, keys={list(packet.keys())}")
            if cmd == "2274":
                print(f"     CMD 2274 DATA: {json.dumps(packet, ensure_ascii=False)[:300]}")
            if packet.get("notifyType") or packet.get("notify"):
                print(f"     NOTIFY: {json.dumps(packet, ensure_ascii=False)[:300]}")

    t0 = time.time()
    print("\nSending march request CMD 1007 / SUBCMD 2...")
    march_res = await conn.query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, march_payload)
    print(f"March response (err={march_res.get('err')}): queueId={march_res.get('queueId')}")

    # Now monitor for 10 seconds
    print("\nWaiting and monitoring for battle resolution (10 seconds)...")
    for sec in range(1, 11):
        await asyncio.sleep(1.0)
        print(f"  ... waited {sec}s (elapsed: {time.time()-t0:.1f}s)")
        # Check command hall data every 2 seconds
        if sec in (3, 6, 9):
            sync_res = await conn.query("2274", "1", {})
            cur_init = sync_res.get("rspdata", {}).get("initData", {}) or sync_res.get("data", {})
            cur_tasks = task._extract_task_list(cur_init)
            matched = [t for t in cur_tasks if t.get("index") == task_index]
            if matched:
                st = matched[0].get("statue")
                print(f"    [Sync at {sec}s] Task {task_index} statue = {st}")
                if st == 3:
                    print(f"    🎉 TASK {task_index} FINISHED! Attempting claim CMD 2274 / SUBCMD 8...")
                    claim_res = await conn.query("2274", "8", {"commitType": task_type, "index": task_index})
                    print(f"    🎁 Claim response: {json.dumps(claim_res, ensure_ascii=False)}")
                    break

    await conn.close()
    print("\nClosed cleanly.")

if __name__ == "__main__":
    asyncio.run(live_march_test())
