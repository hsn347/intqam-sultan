# -*- coding: utf-8 -*-
"""
tools/test_upgrade_command_lv.py
فحص واختبار طلب ترقية مستوى قاعة القيادة (CMD 2274, SubCMD 2) على حساب حي.
"""

import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db
from tasks.command_hall import CommandHallTask


async def main():
    email = "beetoo3@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    print(f"[*] Connecting to live account: {email}...")
    connected = await bot.connect()
    if not connected:
        print("[!] Failed to connect.")
        return

    try:
        task = CommandHallTask(bot.conn)
        tasks_data = await task.get_command_hall_tasks(force_sync=True)
        summary = tasks_data.get("summary", {})
        print(f"[*] Initial Summary: {summary}")

        cur_lv = summary.get("command_lv", 0)
        cur_exp = summary.get("command_exp", 0)
        need_exp = summary.get("need_exp", 0)
        can_upgrade = summary.get("can_upgrade", False)

        print(f"[*] Can upgrade: {can_upgrade} (Lv: {cur_lv}, Exp: {cur_exp}/{need_exp})")

        if can_upgrade:
            print("[*] Sending CMD 2274, SubCMD 2 (reqUpgradeCommandLv)...")
            resp = await task.safe_query(2274, 2, {})
            print(f"[+] Server Response: {resp}")

            # Re-check summary
            tasks_data_after = await task.get_command_hall_tasks(force_sync=True)
            print(f"[+] After Upgrade Summary: {tasks_data_after.get('summary', {})}")
        else:
            print("[!] Cannot upgrade (not enough exp or max level reached).")
    finally:
        if bot.conn:
            await bot.conn.disconnect()
        print("[*] Disconnected.")

if __name__ == "__main__":
    asyncio.run(main())
