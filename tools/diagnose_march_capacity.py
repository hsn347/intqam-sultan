# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import asyncio
import json
import core.database as db
from bot_manager import CastleBot

async def main():
    target_email = 'beetoo2@hotmail.com'
    c_data = db.get_castle_by_id(target_email)
    pwd = c_data.get('password') if c_data else None
    bot = CastleBot(email=target_email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print('Failed to connect')
        return

    conn = bot.conn
    init_data = conn.init_data

    result = {}

    # 1. Drill grounds
    city_ctrl = init_data.get('cityCtrl', {})
    blist = city_ctrl.get('blist', [])
    for b in blist:
        binfo = b.get('binfo', {})
        if binfo.get('bid') == 121:
            result['drill_grounds'] = binfo
            break

    # 2. Technology
    tech_ctrl = init_data.get('technologyCtrl', {})
    result['technology_keys'] = list(tech_ctrl.keys())
    result['tech_list'] = tech_ctrl.get('techList', tech_ctrl.get('tlist', []))

    # 3. BuffCtrl
    result['buff_ctrl'] = init_data.get('buffCtrl')

    # 4. HeroSysCtrl
    hero_sys = init_data.get('heroSysCtrl', {})
    result['hero_sys_keys'] = list(hero_sys.keys())
    heros_raw = hero_sys.get('heros') or hero_sys.get('heroList') or hero_sys.get('heroInfo') or hero_sys
    result['hero_count'] = len(heros_raw) if hasattr(heros_raw, '__len__') else 0
    hero_details = []
    if isinstance(heros_raw, dict):
        for k, h in heros_raw.items():
            if isinstance(h, dict):
                hero_details.append({
                    'key': k,
                    'id': h.get('heroID') or h.get('id') or k,
                    'level': h.get('level'),
                    'quality': h.get('quality'),
                    'state': h.get('state'),
                    'isAwake': h.get('isAwake'),
                    'powerSkill': h.get('powerSkill'),
                    'masterySkill': h.get('masterySkill'),
                    'skillList': h.get('skillList'),
                    'dressList': h.get('dressList')
                })
            else:
                hero_details.append({'key': k, 'val': str(h)[:100]})
    elif isinstance(heros_raw, list):
        for h in heros_raw:
            if isinstance(h, dict):
                hero_details.append({
                    'id': h.get('heroID') or h.get('id'),
                    'level': h.get('level'),
                    'quality': h.get('quality'),
                    'state': h.get('state'),
                    'isAwake': h.get('isAwake'),
                    'powerSkill': h.get('powerSkill'),
                    'masterySkill': h.get('masterySkill'),
                    'skillList': h.get('skillList'),
                    'dressList': h.get('dressList')
                })
            else:
                hero_details.append({'val': str(h)[:100]})
    result['heroes'] = hero_details

    # 5. LordInfoCtrl
    lord_info = init_data.get('lordInfoCtrl', {})
    result['lord_info_keys'] = list(lord_info.keys())
    result['vip_info'] = lord_info.get('vipInfo')
    result['achieve_info'] = lord_info.get('achieveInfo')
    result['rank_info'] = lord_info.get('rankInfo')
    result['title_info'] = lord_info.get('titleInfo')

    # 6. ArmyCtrl
    army_ctrl = init_data.get('armyCtrl', {})
    result['army_ctrl_keys'] = list(army_ctrl.keys())
    result['army_compile'] = army_ctrl.get('compile')
    result['team_info'] = army_ctrl.get('teamInfo')

    # 7. EquipmentCtrl
    equip_ctrl = init_data.get('equipmentCtrl', {})
    result['equipment_ctrl_keys'] = list(equip_ctrl.keys())

    # 8. PetCtrl
    pet_ctrl = init_data.get('petCtrl', {})
    result['pet_ctrl_keys'] = list(pet_ctrl.keys())

    with open('tools/beetoo2_diagnostics.json', 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    print("Diagnostics saved to tools/beetoo2_diagnostics.json")

    if bot.conn:
        await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
