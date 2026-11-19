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
    
    hero_list = d.get('heroSysCtrl', {}).get('heroList', {})
    print(f"Total heroes in beetoo2: {len(hero_list)}")
    
    # Load hero rarity from march_data_tables.json
    with open('tools/march_data_tables.json', 'r', encoding='utf-8') as f:
        tables = json.load(f)
    hero_configs = tables.get('HEROES', {})
    rare2levels = tables.get('HERO_RARE_LEVEL_MARCH', {})

    for hid_str, hdata in hero_list.items():
        hid = int(hid_str)
        cfg = hero_configs.get(str(hid), {})
        name_ar = cfg.get('name_ar', f'Hero {hid}')
        rarity = cfg.get('rarity', 1)
        lvl = hdata.get('level', 1)
        state = hdata.get('state', 1)
        
        # look up level march add
        lvl_info = rare2levels.get(str(rarity), {}).get(str(lvl), {})
        march_add = lvl_info.get('march_add', 0)
        
        print(f"Hero {hid} ({name_ar}): Rarity {rarity}, Level {lvl}, State {state} -> Base march_add = {march_add}")
        print(f"   Details: {hdata}")

    await bot.stop()

asyncio.run(inspect())
