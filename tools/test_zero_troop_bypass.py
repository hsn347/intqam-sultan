# -*- coding: utf-8 -*-
"""
tools/test_zero_troop_bypass.py
Tests 0-troop bypass behavior on live connection with 0 troops simulated.
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


async def test_zero_troops(email="beetoo1@hotmail.com"):
    print(f"\n{'='*75}\n🛡️ [0-TROOP BYPASS TEST] Testing: {email}\n{'='*75}")
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    # Instantiate task
    task = CommandHallTask(conn, config={"enabled": True})
    
    # Override available_troops_count to return 0 to test exact zero-troop bypass
    type(task).available_troops_count = property(lambda self: 0)

    t0 = time.time()
    result = await task.safe_execute()
    elapsed = time.time() - t0

    print(f"\nExecution finished in {elapsed:.2f}s")
    print(f"Result: success={result.success}, skipped={result.skipped}, message='{result.message}'")
    print(f"Result data: {result.data}")
    assert elapsed < 5.0, f"0-troop bypass took {elapsed:.2f}s, expected < 5s!"
    assert result.data.get("marches") == 0, f"Expected 0 marches, got {result.data.get('marches')}"
    print("✅ 0-Troop bypass test passed in < 5s!")

    await conn.close()


if __name__ == "__main__":
    asyncio.run(test_zero_troops())
