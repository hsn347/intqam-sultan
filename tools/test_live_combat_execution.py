# -*- coding: utf-8 -*-
"""
tools/test_live_combat_execution.py
Empirical Live Verification of CommandHallTask.safe_execute() with real combat march,
coordinate translation (server - 1), dynamic march tracking, and reward claiming.
"""

import asyncio
import os
import sys
import time

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot
from tasks.command_hall import CommandHallTask


async def verify_live_combat(email="beetoo1@hotmail.com"):
    print(f"\n{'='*75}\n⚔️ [LIVE COMBAT TASK VERIFICATION] Account: {email}\n{'='*75}")
    bot = CastleBot(email=email, log_callback=lambda m: print(f"[BOT] {m}"))
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn, f"Failed to connect to {email}"
    conn = bot.conn

    # Check Lord state and gold before
    base = conn.init_data.get("lordInfoCtrl", {}).get("base", {})
    gold_before = int(base.get("gold", 0))
    stamina_before = int(base.get("health", 0))
    print(f"✓ Initial Lord State: Gold={gold_before:,}, Stamina={stamina_before}")

    task = CommandHallTask(conn, config={"enabled": True})
    troops_count = task.available_troops_count
    marches_count = task.available_marches
    print(f"✓ Available Troops: {troops_count:,}, Available Marches: {marches_count}")
    assert troops_count > 0, "Expected garrison combat troops"
    assert marches_count > 0, "Expected available march queues"

    # Pre-inspect Command Hall tasks
    res_init = await conn.query("2274", "1", {})
    init_data = res_init.get("rspdata", {}).get("initData", {}) or res_init.get("data", {})
    task_list = task._extract_task_list(init_data)
    print(f"✓ Pre-run Tasks Count: {len(task_list)}")
    for t in task_list:
        print(f"  • Task index={t.get('index')}, type={t.get('type')}, statue={t.get('statue')}, obj={t.get('obj')}")

    # Run actual safe_execute()
    t0 = time.time()
    result = await task.safe_execute()
    elapsed = time.time() - t0

    print(f"\nExecution finished in {elapsed:.2f}s")
    print(f"Result: success={result.success}, skipped={result.skipped}, message='{result.message}'")
    print(f"Result data: {result.data}")

    # Check Gold Invariant
    base_after = conn.init_data.get("lordInfoCtrl", {}).get("base", {})
    gold_after = int(base_after.get("gold", 0))
    delta_gold = gold_after - gold_before
    print(f"✓ Gold Invariant: Before={gold_before:,}, After={gold_after:,}, Delta Gold={delta_gold}")

    # Assertions
    assert result.success is True, f"Task failed: {result.message}"
    assert result.data.get("marches", 0) > 0 or result.data.get("claimed", 0) > 0, "Expected at least 1 march or claimed task"
    assert delta_gold == 0, f"Gold was spent! Delta Gold = {delta_gold}"
    assert elapsed < 35.0, f"Execution took too long: {elapsed:.2f}s"

    await conn.close()
    print("✓ Socket closed cleanly.")
    print(f"✅ Live Combat Verification on {email} PASSED!")


if __name__ == "__main__":
    email = sys.argv[1] if len(sys.argv) > 1 else "beetoo1@hotmail.com"
    asyncio.run(verify_live_combat(email))
