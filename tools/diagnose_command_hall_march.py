# -*- coding: utf-8 -*-
"""
tools/diagnose_command_hall_march.py
Empirical diagnostic probe to inspect:
1. Exact castle coordinates vs target task coordinates.
2. CMD 2274 / SUBCMD 1 response details (tasks, statues, finishTaskData, etc.).
3. CMD 1007 / SUBCMD 2 march dispatch response and returned queue times.
4. Active queues in queueCtrl and their actual end times.
5. What happens when the march actually reaches the target.
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
from tasks.command_hall import CommandHallTask


async def diagnose(email="beetoo3@hotmail.com"):
    print(f"\n{'='*75}\n🔍 [DIAGNOSTIC] Inspecting live account: {email}\n{'='*75}")
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True

    ok = await bot.connect()
    assert ok and bot.conn, "Failed to connect"
    conn = bot.conn

    # 1. Inspect Castle coordinates
    lord_base = conn.init_data.get("lordInfoCtrl", {}).get("base", {})
    city_ctrl = conn.init_data.get("cityCtrl", {})
    pos_x = lord_base.get("x") or city_ctrl.get("x")
    pos_y = lord_base.get("y") or city_ctrl.get("y")
    print(f"🏰 Castle Position: ({pos_x}, {pos_y}) | Gold: {lord_base.get('gold')} | Health: {lord_base.get('health')}")

    # 2. Inspect Army
    army_ctrl = conn.init_data.get("armyCtrl", {})
    total_army = army_ctrl.get("totalArmy", {})
    combat_troops = {k: v for k, v in total_army.items() if int(k) < 800 and int(v) > 0}
    print(f"⚔️ Combat Troops: {combat_troops}")

    # 3. Query CMD 2274 SUBCMD 1
    t0 = time.time()
    res1 = await conn.query("2274", "1", {})
    print(f"📡 CMD 2274 / SUBCMD 1 latency: {time.time()-t0:.3f}s")
    init_data = res1.get("rspdata", {}).get("initData", {}) or res1.get("data", {})
    print(f"  • Level: {init_data.get('commandLv')}")
    print(f"  • Exp: {init_data.get('commandExp')}")
    print(f"  • ArmyGroupID: {init_data.get('armyGroupID')}")
    print(f"  • ArmyGroupTaskData: {init_data.get('armyGroupTaskData')}")
    print(f"  • ArmyPioneerTaskData: {init_data.get('armyPioneerTaskData')}")
    print(f"  • CommonTaskData: {json.dumps(init_data.get('commonTaskData'), ensure_ascii=False)}")
    print(f"  • FinishTaskData: {init_data.get('finishTaskData')}")
    print(f"  • DefendData: {init_data.get('defendData')}")

    # 4. Check active queues right now
    q_ctrl = conn.init_data.get("queueCtrl", {})
    queues = q_ctrl.get("queues", [])
    now_ts = int(time.time())
    print(f"\n🚶 Active queues currently in memory ({len(queues)}):")
    for q in queues:
        q_type = q.get("type")
        q_start = q.get("startTime", 0)
        q_end = q.get("endTime", 0)
        rem = max(0, q_end - now_ts)
        print(f"  • Queue type={q_type}, id={q.get('id')}, start={q_start}, end={q_end}, remaining={rem}s, data={q.get('data')}")

    # 5. Check Lua files or task definition
    task = CommandHallTask(conn, config={"enabled": True})
    task_list = task._extract_task_list(init_data)
    print(f"\n📋 Extracted Tasks ({len(task_list)}):")
    for t in task_list:
        idx = t.get("index")
        tp = t.get("type")
        st = t.get("statue")
        coords = task._get_target_coordinates(t)
        dist = None
        if coords and pos_x is not None and pos_y is not None:
            dist = ((int(coords[0]) - int(pos_x))**2 + (int(coords[1]) - int(pos_y))**2)**0.5
        print(f"  • Task index={idx}, type={tp}, statue={st}, coords={coords}, distance={dist:.1f} tiles if dist else None")

    await conn.close()
    print("\n✓ Closed cleanly.")


if __name__ == "__main__":
    email = sys.argv[1] if len(sys.argv) > 1 else "beetoo3@hotmail.com"
    asyncio.run(diagnose(email))
