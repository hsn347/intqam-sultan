import sys
import os
import json
import asyncio

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from bot_manager import CastleBot
import core.database as db

async def run():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    b = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    b.is_running = True
    ok = await b.connect()
    if not ok:
        print("Failed to connect")
        return

    init = b.conn.init_data
    
    print("\n--- 1. CITY DRILL GROUNDS ---")
    city = init.get("cityCtrl") or {}
    buildings = city.get("building") or city.get("build") or []
    for bg in buildings:
        if bg.get("bid") == 407:
            print("Drill grounds:", bg)

    print("\n--- 2. HERO SYS CTRL ---")
    hero_sys = init.get("heroSysCtrl") or {}
    print("heroSysCtrl keys:", list(hero_sys.keys()) if isinstance(hero_sys, dict) else type(hero_sys))
    if isinstance(hero_sys, dict):
        for k in hero_sys:
            val = hero_sys[k]
            if isinstance(val, dict):
                print(f"  heroSys[{k}] keys: {list(val.keys())[:10]}")
            elif isinstance(val, list):
                print(f"  heroSys[{k}] len: {len(val)}")
            else:
                print(f"  heroSys[{k}]: {val}")

    print("\n--- 3. BUFF CTRL ---")
    buff_ctrl = init.get("buffCtrl") or []
    print("buffCtrl type:", type(buff_ctrl))
    if isinstance(buff_ctrl, list):
        print(f"buffCtrl count: {len(buff_ctrl)}")
        for item in buff_ctrl:
            print("  buff:", item)
    elif isinstance(buff_ctrl, dict):
        for k, v in buff_ctrl.items():
            print(f"  buff[{k}]: {v}")

    print("\n--- 4. LORD SKILL CTRL ---")
    lord_skill = init.get("lordSkillCtrl") or {}
    print("lordSkill keys:", list(lord_skill.keys()) if isinstance(lord_skill, dict) else type(lord_skill))
    if isinstance(lord_skill, dict):
        for k, v in lord_skill.items():
            print(f"  lordSkill[{k}]: {v}")

    print("\n--- 5. PET CTRL ---")
    pet = init.get("petCtrl") or {}
    print("petCtrl keys:", list(pet.keys()) if isinstance(pet, dict) else type(pet))
    if isinstance(pet, dict):
        for k, v in pet.items():
            print(f"  pet[{k}]: {v}")

    print("\n--- 6. EQUIPMENT CTRL ---")
    equip = init.get("equipmentCtrl") or {}
    print("equipmentCtrl keys:", list(equip.keys()) if isinstance(equip, dict) else type(equip))

    # Close connection properly without exception
    if b.conn and hasattr(b.conn, 'close'):
        b.conn.close()

if __name__ == "__main__":
    asyncio.run(run())
