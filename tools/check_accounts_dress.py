import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import asyncio
import json
from bot_manager import CastleBot
import core.database as db
from tools.check_dress_attr5 import check_dress

async def check_all_accounts():
    # 1. Get dress maps
    import re
    with open('game_file/src/app/localtb/config_server/dress_type_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        c = f.read()

    blocks = c.split('.subType = ')
    subtype_own = {}
    subtype_use = {}
    for b in blocks[1:]:
        sub_str = b.split('\n')[0].strip()
        if not sub_str.isdigit():
            continue
        subtype = int(sub_str)
        own_pos = b.find('.ownAttribute')
        if own_pos != -1:
            own_sec = b[own_pos:own_pos+800]
            pairs = re.findall(r'ownAttribute.*?=\s*(?:nil,\s*)*(\d+)', own_sec)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        subtype_own[subtype] = nums[i+1]
        use_pos = b.find('.useAttribute')
        if use_pos != -1:
            use_sec = b[use_pos:use_pos+800]
            pairs = re.findall(r'useAttribute.*?=\s*(?:nil,\s*)*(\d+)', use_sec)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        subtype_use[subtype] = nums[i+1]

    with open('game_file/src/app/localtb/config_server/dress_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        dc = f.read()

    d_blocks = dc.split('.dressID = ')
    dress_to_sub = {}
    for db_item in d_blocks[1:]:
        did_str = db_item.split('\n')[0].strip()
        if not did_str.isdigit():
            continue
        did = int(did_str)
        m_sub = re.search(r'\.subType\s*=\s*(?:nil,\s*)*(\d+)', db_item)
        if m_sub:
            dress_to_sub[did] = int(m_sub.group(1))

    dress_own = {did: subtype_own[st] for did, st in dress_to_sub.items() if st in subtype_own}
    dress_use = {did: subtype_use[st] for did, st in dress_to_sub.items() if st in subtype_use}

    for email in ["LUCIFER@g4.coom", "beetoo1@hotmail.com", "beetoo2@hotmail.com"]:
        c_data = db.get_castle_by_id(email)
        if not c_data:
            continue
        pwd = c_data.get("password")
        bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
        bot.is_running = True
        ok = await bot.connect()
        if not ok or not bot.conn:
            print(f"Failed to connect {email}")
            continue
        
        dress_ctrl = bot.conn.init_data.get('dressCtrl') or {}
        d_list = dress_ctrl.get('list') or {}
        d_set = dress_ctrl.get('setting') or {}
        
        own_add = sum(dress_own.get(int(did), 0) for did in d_list.keys())
        use_add = sum(dress_use.get(int(did), 0) for did in d_set.values())

        pet_ctrl = bot.conn.init_data.get('petCtrl') or {}
        pet_list = pet_ctrl.get('petList') or {}
        
        print(f"\nAccount {email}:")
        print(f"  dress list: {list(d_list.keys())} -> own_add attr 5: {own_add}")
        print(f"  dress setting: {d_set} -> use_add attr 5: {use_add}")
        print(f"  pet count: {len(pet_list)}")
        for pk, pv in pet_list.items():
            print(f"    pet: {pv.get('petid')}, lv: {pv.get('level')}, rank: {pv.get('rank')}")
            
        await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check_all_accounts())
