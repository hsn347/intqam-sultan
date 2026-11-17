# -*- coding: utf-8 -*-
import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db

async def main():
    email = "beetoo3@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("[!] Failed to connect")
        return

    try:
        keys = list(bot.conn.init_data.keys())
        print(f"[*] Available controllers ({len(keys)}): {sorted(keys)}")
        for k in sorted(keys):
            data = bot.conn.init_data[k]
            k_lower = k.lower()
            if any(w in k_lower for w in ["task", "day", "glory", "prestige", "quest", "event", "star"]):
                print(f"\n--- Controller: {k} ---")
                if isinstance(data, dict):
                    print("Keys:", list(data.keys()))
                    # print sample
                    for subk, subv in data.items():
                        if isinstance(subv, (dict, list)):
                            print(f"  {subk}: len={len(subv)}")
                        else:
                            print(f"  {subk}: {subv}")
                else:
                    print(f"Type: {type(data)}")
    finally:
        if bot.conn:
            await bot.conn.close()
        print("[*] Disconnected.")

if __name__ == "__main__":
    asyncio.run(main())
