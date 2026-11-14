# -*- coding: utf-8 -*-
"""
tools/test_live_lucifer_combat.py
Runs safe_execute() on LUCIFER@g4.com to verify end-to-end combat march,
coordinate translation, dynamic march wait, and reward claiming.
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


async def run_lucifer():
    email = "LUCIFER@g4.com"
    print(f"\n{'='*75}\n⚔️ [LIVE COMBAT RUN] Account: {email}\n{'='*75}")
    bot = CastleBot(email=email, log_callback=lambda m: print(f"[BOT] {m}"))
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    base = conn.init_data.get("lordInfoCtrl", {}).get("base", {})
    gold_before = int(base.get("gold", 0))
    print(f"Initial Gold: {gold_before:,}")

    task = CommandHallTask(conn, config={"enabled": True})

    t0 = time.time()
    result = await task.safe_execute()
    elapsed = time.time() - t0

    print(f"\nExecution finished in {elapsed:.2f}s")
    print(f"Result: success={result.success}, skipped={result.skipped}, message='{result.message}'")
    print(f"Result data: {result.data}")

    base_after = conn.init_data.get("lordInfoCtrl", {}).get("base", {})
    gold_after = int(base_after.get("gold", 0))
    delta_gold = gold_after - gold_before
    print(f"Gold invariant: Before={gold_before:,}, After={gold_after:,}, Delta={delta_gold}")

    assert result.success is True, f"Failed: {result.message}"
    assert delta_gold == 0, f"Gold changed! {delta_gold}"
    assert elapsed < 60.0, f"Took too long: {elapsed:.2f}s"

    await conn.close()
    print("Socket closed cleanly.")


if __name__ == "__main__":
    asyncio.run(run_lucifer())
