# -*- coding: utf-8 -*-
import asyncio, os, sys
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == 'tools' else CURRENT_DIR
sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot
import core.database as db

async def main():
    email = 'beetoo2@hotmail.com'
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get('password') if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok: return
    
    conn = bot.conn
    hsys = conn.init_data.get('heroSysCtrl', {})
    hlist = hsys.get('heroList', {})
    print(f'Total heroes: {len(hlist)}')
    
    # Let's inspect each hero
    hero_info_file = 'game_file/src/app/localtb/config_server/hero_info.lua'
    # parse rarity
    hero_rarities = {}
    if os.path.exists(hero_info_file):
        with open(hero_info_file, 'r', encoding='utf-8') as f:
            cur_hid = None
            for line in f:
                if 'heroID' in line:
                    parts = line.split('=')
                    if len(parts) > 1:
                        try: cur_hid = int(parts[1].strip())
                        except: pass
                if 'rarity' in line and cur_hid:
                    parts = line.split('=')
                    if len(parts) > 1:
                        try:
                            hero_rarities[cur_hid] = int(parts[1].strip())
                            cur_hid = None
                        except: pass

    # load hero_rare_level
    rare_file = 'game_file/src/app/localtb/config_server/hero_rare_level.lua'
    rare_conf = {}
    if os.path.exists(rare_file):
        with open(rare_file, 'r', encoding='utf-8') as f:
            cur_rarity = None
            cur_lv = None
            for line in f:
                if 'rarity' in line:
                    parts = line.split('=')
                    if len(parts) > 1:
                        try: cur_rarity = int(parts[1].strip())
                        except: pass
                if 'level' in line and 'march_add' not in line:
                    parts = line.split('=')
                    if len(parts) > 1:
                        try: cur_lv = int(parts[1].strip())
                        except: pass
                if 'march_add' in line and cur_rarity is not None and cur_lv is not None:
                    parts = line.split('=')
                    if len(parts) > 1:
                        try:
                            m_val = int(parts[1].strip())
                            if cur_rarity not in rare_conf: rare_conf[cur_rarity] = {}
                            rare_conf[cur_rarity][cur_lv] = m_val
                            cur_lv = None
                        except: pass

    print(f"Parsed {len(hero_rarities)} hero rarities, {len(rare_conf)} rare tiers")

    for hid_str, h in sorted(hlist.items(), key=lambda x: int(x[0])):
        hid = int(hid_str)
        lv = h.get('level', 1)
        state = h.get('state', 0)
        rarity = hero_rarities.get(hid, 0)
        march_add = rare_conf.get(rarity, {}).get(lv, 0)
        print(f"Hero {hid}: rarity={rarity}, lv={lv}, state={state}, march_add={march_add}")

    if bot.conn:
        await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
