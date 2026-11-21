# -*- coding: utf-8 -*-
import json

def inspect_heroes(tag, path):
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
    print(f"\n=================== {tag} ===================")
    hero_sys = data.get('heroCtrl', {}) or data.get('heroList', {})
    if isinstance(hero_sys, dict):
        hlist = hero_sys.get('heroList', hero_sys)
    else:
        hlist = hero_sys
    print(f"Total heroes: {len(hlist)}")
    for k, v in hlist.items():
        if isinstance(v, dict):
            print(f"Hero {k}: lv={v.get('level')}, quality={v.get('quality')}, state={v.get('state')}, isAwake={v.get('isAwake')}, skills={list(v.get('skillList', {}).keys())}")

inspect_heroes('beetoo1', 'tools/beetoo1_full_init_data.json')
inspect_heroes('beetoo2', 'tools/beetoo2_full_init_data.json')
