import asyncio
import sys
import os
import json

sys.path.insert(0, os.path.abspath("."))
from bot_manager import CastleBot
import core.database as db

async def main():
    c_data = db.get_castle_by_id("beetoo2@hotmail.com")
    b = CastleBot(email="beetoo2@hotmail.com", password=c_data.get("password"), log_callback=lambda m: None)
    b.is_running = True
    await b.connect()
    init = b.conn.init_data
    
    city = init.get("cityCtrl") or {}
    print("cityCtrl keys:", list(city.keys()))
    for k in city:
        if isinstance(city[k], list) and city[k] and isinstance(city[k][0], dict) and "bid" in city[k][0]:
            print(f"Key {k} has buildings:")
            for bld in city[k]:
                if bld.get("bid") == 407:
                    print("  Drill grounds:", bld)
        elif isinstance(city[k], dict):
            for subk, subv in city[k].items():
                if isinstance(subv, dict) and subv.get("bid") == 407:
                    print(f"  Drill grounds in {k}.{subk}:", subv)

    print("\n--- HEROES ---")
    hero_list = init.get("heroSysCtrl", {}).get("heroList", {})
    for hid, h in hero_list.items():
        print(f"Hero {hid}: lv={h.get('level')} state={h.get('state')} star={h.get('star')} quality={h.get('quality')} dress={h.get('dress')}")

    if b.conn:
        await b.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
