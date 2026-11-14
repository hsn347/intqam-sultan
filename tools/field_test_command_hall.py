# -*- coding: utf-8 -*-
"""
tools/field_test_command_hall.py
══════════════════════════════════════════════════════════════════════════════════
Field Verification Runner for CommandHallTask on Live Database Castles
══════════════════════════════════════════════════════════════════════════════════
Tests live gateway connection, live memory initialization, and CommandHallTask
safe execution against real castle credentials (e.g. sultan_beetoo1).
"""

import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot
from tasks.command_hall import CommandHallTask


async def field_test_castle(email: str = "beetoo1@hotmail.com"):
    print(f"\n{'='*70}")
    print(f"🏰 [Field Verification] Testing castle account: {email}")
    print(f"{'='*70}")

    c_data = db.get_castle_by_id(email)
    if not c_data:
        print(f"❌ Castle {email} not found in database!")
        return False

    print(f"✓ Found castle record: {c_data.get('castle_name', email)} (is_active={c_data.get('is_active')})")

    bot = CastleBot(email=email, log_callback=lambda m: print(f"  [BOT-LOG] {m}"))
    if c_data.get("password"):
        bot.password = c_data["password"]

    # CRITICAL: bot.is_running must be True to pass lifecycle orphan prevention check
    bot.is_running = True

    print("🌐 Connecting to login server and gateway...")
    try:
        ok = await bot.connect()
    except Exception as e:
        print(f"💥 Exception during bot.connect(): {e}")
        return False

    if not ok or not bot.conn:
        print(f"❌ Failed to connect to gateway for {email}")
        return False

    conn = bot.conn
    print(f"✅ Connected to gateway successfully! UID={getattr(bot.creds, 'uid', 'N/A')} | Kingdom={getattr(bot.creds, 'kingdom_id', 'N/A')}")
    print(f"✓ Loaded {len(conn.init_data)} live memory controllers.")

    # Instantiate CommandHallTask
    task_config = {"enabled": True}
    task = CommandHallTask(conn, log_func=lambda m: print(f"  [TASK-LOG] {m}"), config=task_config)

    # 1. Test can_run
    can_run, reason = await task.can_run()
    print(f"✓ Pre-flight can_run check: {can_run} (reason: {reason})")
    if not can_run:
        print("❌ can_run returned False!")
        await conn.close()
        return False

    # 2. Test _ensure_synced_data (0-Network Pre-flight check)
    print("🔍 Testing _ensure_synced_data()...")
    hall_data = await task._ensure_synced_data()
    print(f"✓ Command Hall Data retrieved: type={type(hall_data).__name__}, keys={list(hall_data.keys()) if isinstance(hall_data, dict) else 'N/A'}")
    if isinstance(hall_data, dict):
        cmd_lv = hall_data.get("commandLv", "N/A")
        cmd_exp = hall_data.get("commandExp", "N/A")
        task_list = task._extract_task_list(hall_data)
        print(f"  • Command Level: {cmd_lv} | Command Exp: {cmd_exp}")
        print(f"  • Subtasks count: {len(task_list)}")
        for t in task_list[:5]:
            print(f"    - Task idx={t.get('index')}, type={t.get('type')}, statue={t.get('statue')}, consume={t.get('consume')}, gold={t.get('consumeGold', 0)}")

    # 3. Test safe single pass execution
    print("⚙️ Testing single pass execution (safe_execute)...")
    result = await task.safe_execute()
    print(f"✓ safe_execute result: success={result.success}, skipped={result.skipped}, message='{result.message}'")
    if result.data:
        print(f"  • Result details: {result.data}")

    # Safely close connection
    print("🔒 Safely closing gateway connection...")
    try:
        await conn.close()
        print("✓ Gateway connection closed cleanly.")
    except Exception as e:
        print(f"⚠️ Error closing connection: {e}")

    return True


if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "beetoo1@hotmail.com"
    success = asyncio.run(field_test_castle(target))
    sys.exit(0 if success else 1)
