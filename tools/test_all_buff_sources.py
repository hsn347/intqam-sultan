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
    
    print("=== 1. CITY MASTERY ===")
    city = init.get("cityCtrl") or {}
    mastery = city.get("mastery")
    print("Mastery:", mastery)

    print("\n=== 2. PET ATTRIBUTES ===")
    pet = init.get("petCtrl") or {}
    print("Pet list:", pet.get("petList"))

    print("\n=== 3. ALLIANCE PROSPERITY ===")
    all_ctrl = init.get("allianceCtrl") or {}
    print("Prosperity:", all_ctrl.get("sciencelist", {}).get("prosperity"))
    print("Alliance sciencelist keys:", list(all_ctrl.get("sciencelist", {}).keys()))

    print("\n=== 4. LORD INFO FC / ATTRIBUTES ===")
    lord = init.get("lordInfoCtrl") or {}
    for k in lord:
        if any(x in k.lower() for x in ["rank", "offic", "title", "buff", "star", "milit"]):
            print(f"lord.{k}:", lord[k])

    print("\n=== 5. ARMY COMPILE ===")
    army = init.get("armyCtrl") or {}
    print("armyCtrl keys:", list(army.keys()))
    if "compile" in army:
        print("compile:", army["compile"])
    if "compileList" in army:
        print("compileList:", army["compileList"])

    if b.conn:
        await b.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
