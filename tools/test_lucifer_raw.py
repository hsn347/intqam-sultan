import asyncio
import json
import os
import sys

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, ROOT_DIR)

from bot_manager import CastleBot
import core.database as db

async def test_lucifer_raw():
    email = "LUCIFER@g4.coom"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    print("--- 2054 (Kingdom Level) ---")
    r_kl = await bot.conn.query("2054", "1", {}, action="KL")
    print(json.dumps(r_kl, ensure_ascii=False))

    print("\n--- 2258 (Nebula Tower) ---")
    r_nt = await bot.conn.query("2258", "1", {}, action="NT")
    print(json.dumps(r_nt, ensure_ascii=False))

    print("\n--- 2164 (Hero Biography) ---")
    r_hb = await bot.conn.query("2164", "1", {}, action="HB")
    print(json.dumps(r_hb, ensure_ascii=False))

    print("\n--- 2055 (War Gems) ---")
    r_wg = await bot.conn.query("2055", "1", {}, action="WG")
    print(json.dumps(r_wg, ensure_ascii=False))

    await bot.stop()

if __name__ == "__main__":
    asyncio.run(test_lucifer_raw())
