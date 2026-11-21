# -*- coding: utf-8 -*-
import json
import os

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

def inspect_acc(name, d):
    print(f"=== {name} ===")
    
    # 1. Lord info
    lord = d.get('lordInfoCtrl', {})
    print("Lord Level:", lord.get('level'), "Vip Level:", lord.get('vipLevel'), "Name:", lord.get('nickName'))

    # 2. Castle & Drill grounds building level
    city = d.get('cityCtrl', {})
    build_list = city.get('build_list', {}) or city.get('buildList', {})
    if isinstance(build_list, list):
        build_dict = {str(b.get('bid') or b.get('id') or b.get('buildingId')): b for b in build_list}
    elif isinstance(build_list, dict):
        build_dict = build_list
    else:
        build_dict = {}

    castle_cell = build_dict.get('101') or build_dict.get(101)
    drill_cell = build_dict.get('121') or build_dict.get(121)
    print("Castle (101):", castle_cell)
    print("Drill Ground (121):", drill_cell)

    # 3. Technologies
    tech = d.get('technologyCtrl', {})
    tech_list = tech.get('techList', {}) or tech.get('technologyList', {}) or tech
    print("Tech keys / sample:", list(tech.keys()) if isinstance(tech, dict) else len(tech))

    # 4. Buffs
    buff = d.get('buffCtrl', {})
    print("Buff keys / sample:", list(buff.keys()) if isinstance(buff, dict) else len(buff))

    # 5. Heroes
    hero = d.get('heroSysCtrl', {})
    print("Hero keys:", list(hero.keys()) if isinstance(hero, dict) else len(hero))

inspect_acc("BEETOO 1", d1)
inspect_acc("BEETOO 2", d2)
