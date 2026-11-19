import asyncio, json, os, sys
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot

async def inspect():
    bot = CastleBot(email='beetoo2@hotmail.com', password=None, log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    d = bot.conn.init_data
    
    # 1. cityCtrl
    city = d.get('cityCtrl', {})
    print(f"\n--- cityCtrl type: {type(city)} ---")
    if isinstance(city, dict):
        print("cityCtrl keys:", list(city.keys()))
        build = city.get('building', {})
        print(f"cityCtrl['building'] type: {type(build)}, len: {len(build)}")
        if isinstance(build, dict):
            for k, b in list(build.items())[:5]:
                print(f"sample building {k}: {b}")
            for k, b in build.items():
                if b.get('bid') == 121 or b.get('buildingId') == 121:
                    print(f"FOUND DRILL GROUNDS: {k} -> {b}")
        elif isinstance(build, list):
            for b in build:
                if isinstance(b, dict) and (b.get('bid') == 121 or b.get('buildingId') == 121):
                    print(f"FOUND DRILL GROUNDS: {b}")

    # 2. buffCtrl
    buff = d.get('buffCtrl', {})
    print(f"\n--- buffCtrl type: {type(buff)} ---")
    if isinstance(buff, list):
        print(f"buffCtrl items count: {len(buff)}")
        for item in buff:
            print(f"buff item: {item}")
    elif isinstance(buff, dict):
        print("buffCtrl keys:", list(buff.keys()))
        for k, v in buff.items():
            print(f"buff[{k}] = {v}")

    # 3. equipmentCtrl
    equip = d.get('equipmentCtrl', {})
    print(f"\n--- equipmentCtrl type: {type(equip)} ---")
    if isinstance(equip, dict):
        print("equipmentCtrl keys:", list(equip.keys()))
        print("setData:", equip.get('setData'))
        eq_arr = equip.get('equipment_array', [])
        print(f"equipment_array count: {len(eq_arr)}")
        for eq in eq_arr:
            print(f"Eq: {eq}")

    # 4. heroSysCtrl
    hero = d.get('heroSysCtrl', {})
    print(f"\n--- heroSysCtrl type: {type(hero)} ---")
    if isinstance(hero, dict):
        print("heroSysCtrl keys:", list(hero.keys()))
        for k in ['heroAppoint', 'appointList', 'activeHero', 'heros', 'heroList']:
            if k in hero:
                print(f"hero[{k}] = {hero[k]}")

    # 5. petCtrl
    pet = d.get('petCtrl', {})
    print(f"\n--- petCtrl type: {type(pet)} ---")
    print(f"petCtrl = {pet}")

    # 6. armyCtrl
    army = d.get('armyCtrl', {})
    print(f"\n--- armyCtrl type: {type(army)} ---")
    if isinstance(army, dict):
        print("armyCtrl keys:", list(army.keys()))
        for k in army:
            print(f"army[{k}] = {army[k]}")

    await bot.stop()

asyncio.run(inspect())
