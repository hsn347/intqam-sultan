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
    
    print("--- 1. EQUIPMENT ---")
    equip_ctrl = init.get("equipmentCtrl") or {}
    print("equipment_array count:", len(equip_ctrl.get("equipment_array", [])))
    for eq in equip_ctrl.get("equipment_array", []):
        if eq.get("wear") == 1 or eq.get("isWear") == 1:
            print("WORN EQUIP:", eq)

    print("setData:", equip_ctrl.get("setData"))

    print("\n--- 2. DRESS / SKINS ---")
    lord = init.get("lordInfoCtrl") or {}
    print("lord.dress or skins:", [k for k in lord if 'dress' in k.lower() or 'skin' in k.lower()])
    for k in [k for k in lord if 'dress' in k.lower() or 'skin' in k.lower()]:
        print(f"  lord[{k}]:", lord[k])

    if b.conn:
        await b.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
