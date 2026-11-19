"""
Comprehensive March Capacity Inspector for beetoo2
Reads conn.init_data directly and evaluates all subsystems contributing to single march troop capacity.
"""
import asyncio
import json
import os
import sqlite3
import sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
DB_PATH = os.path.join(WORKSPACE_DIR, "database", "castles.db")

if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot

async def inspect_account(email: str):
    conn_db = sqlite3.connect(DB_PATH)
    cur = conn_db.cursor()
    cur.execute("SELECT email, password FROM castle_states WHERE email = ?", (email,))
    row = cur.fetchone()
    conn_db.close()

    if not row:
        print(f"Castle {email} not found in DB!")
        return

    pwd = row[1]
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    print(f"Connecting to {email} via CastleBot...")
    ok = await bot.connect()
    if not ok:
        print(f"Failed to connect to {email}")
        return

    init_data = bot.conn.init_data
    print(f"Connected successfully! Total keys in init_data: {len(init_data)}")

    # 1. Building 121 (Drill Grounds)
    buildings = init_data.get("building", {})
    drill = None
    for b in buildings.values():
        if b.get("bid") == 121:
            drill = b
            break
    print(f"\n[1] Drill Grounds (bid 121): {drill}")

    # 2. Technology
    tech_info = init_data.get("technologyInfo", {})
    print(f"\n[2] technologyInfo: {json.dumps(tech_info, indent=2)}")

    # 3. Buff list
    buff_list = init_data.get("buff_list", {}) or init_data.get("buffList", {})
    print(f"\n[3] buff_list: {json.dumps(buff_list, indent=2)}")
    
    # 4. Equipment
    equip_ctrl = init_data.get("equipmentCtrl", {})
    if isinstance(equip_ctrl, dict):
        set_data = equip_ctrl.get("setData", {})
        active_set = set_data.get("activeSet", "1")
        active_items = set_data.get("setList", {}).get(active_set, {})
        print(f"\n[4] Active Equipment Set ({active_set}): {active_items}")
        equip_array = equip_ctrl.get("equipment_array", [])
        equipped_details = []
        for eq in equip_array:
            if eq.get("id") in active_items.values() or str(eq.get("id")) in [str(x) for x in active_items.values()]:
                equipped_details.append(eq)
        print(f"Equipped items details: {json.dumps(equipped_details, indent=2)}")

    # 5. Appointed heroes
    hero_appoint = init_data.get("heroAppointInfo", {}) or init_data.get("heroAppoint", {})
    print(f"\n[5] heroAppointInfo: {json.dumps(hero_appoint, indent=2)}")
    
    # 6. Military Rank
    mil_rank = init_data.get("militaryRankInfo", {})
    print(f"\n[6] militaryRankInfo: {json.dumps(mil_rank, indent=2)}")

    # 7. Pets
    pets = init_data.get("petInfo", {}) or init_data.get("pet", {})
    print(f"\n[7] Pets: {json.dumps(pets, indent=2)}")

    # 8. Lord skills / talents
    lord_ctrl = init_data.get("lordInfoCtrl", {})
    lord_skill = init_data.get("lordSkill", {}) or (lord_ctrl.get("skill", {}) if isinstance(lord_ctrl, dict) else {})
    print(f"\n[8] Lord skill: {json.dumps(lord_skill, indent=2)}")

    # 9. VIP
    vip = (lord_ctrl.get("vip", {}) if isinstance(lord_ctrl, dict) else {}) or init_data.get("vip", {})
    print(f"\n[9] VIP: {json.dumps(vip, indent=2)}")

    # 10. Check lordPowerInfo / lordMilitaryInfo or any precomputed field if present
    for k in init_data:
        if any(w in k.lower() for w in ["power", "army", "march", "military", "dress"]):
            val = init_data[k]
            val_str = str(val)[:150]
            print(f"Key '{k}': {val_str}")

    await bot.stop()

if __name__ == "__main__":
    asyncio.run(inspect_account("beetoo2@hotmail.com"))
