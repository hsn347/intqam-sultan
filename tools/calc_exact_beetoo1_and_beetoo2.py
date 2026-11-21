# -*- coding: utf-8 -*-
"""
حساب السعة الحرفية الكاملة لـ beetoo1 و beetoo2 بناءً على أكواد اللعبة الرسمية
"""
import json
import math
import re

# 1. تحميل جداول البيانات
with open('tools/march_data_tables.json', 'r', encoding='utf-8') as f:
    march_tables = json.load(f)

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    hl_text = f.read()

# تحليل مستويات الأبطال
rare_lvs = {}
current = {}
for l in hl_text.splitlines():
    l = l.strip()
    if 'ID =' in l:
        if 'rarity' in current and 'level' in current:
            r = current['rarity']
            lv = current['level']
            rare_lvs.setdefault(r, {})[lv] = current.get('march_add', 0)
        current = {}
    elif 'rarity =' in l:
        current['rarity'] = int(l.split('=')[-1].strip().split(',')[0])
    elif 'level =' in l:
        current['level'] = int(l.split('=')[-1].strip().split(',')[0])
    elif 'march_add =' in l:
        current['march_add'] = int(l.split('=')[-1].strip().split(',')[0])
if 'rarity' in current and 'level' in current:
    rare_lvs.setdefault(current['rarity'], {})[current['level']] = current.get('march_add', 0)

# تحليل hero_view_info
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    hvi_text = f.read()
chunks = hvi_text.split(';(nil).heroID = ')
hero_meta = {}
for c in chunks[1:]:
    lines = c.splitlines()
    hid = int(lines[0].strip().split(',')[0])
    rarity_m = re.search(r'rarity\s*=\s*(?:nil,\s*)*(\d+)', c)
    name_m = re.search(r'name\s*=\s*"([^"]+)"', c)
    rarity = int(rarity_m.group(1)) if rarity_m else 1
    name = name_m.group(1) if name_m else str(hid)
    hero_meta[hid] = {'rarity': rarity, 'name': name}

tech_tables = march_tables.get("techs", {})

def analyze_castle(tag, json_path):
    with open(json_path, 'r', encoding='utf-8', errors='ignore') as f:
        data = json.load(f)
    print(f"\n==========================================")
    print(f"       ANALYSIS FOR: {tag}")
    print(f"==========================================")
    
    # A. Drill Ground (bid 121)
    blist = data.get('cityCtrl', {}).get('blist', [])
    drill_lv = 0
    for b in blist:
        binfo = b.get('binfo', b)
        if str(binfo.get('bid')) == '121':
            drill_lv = int(binfo.get('lv', 1))
            break
            
    base = 87500 if drill_lv == 27 else 0 # drill_lv 27 = 87500
    default_val = 1000 # gConstValue.DEFAULT_EXP_ARMY_COUNT
    print(f"1. Drill Ground Lv.{drill_lv}: base = {base}")
    print(f"2. gConstValue.DEFAULT_EXP_ARMY_COUNT = {default_val}")
    
    # B. Technology
    tech_ctrl = data.get('technologyCtrl', {})
    tech_add = 0
    techGroupAdd = 0
    print(f"3. Technologies (total entries: {len(tech_ctrl)}):")
    for tid_key, tdata in tech_ctrl.items():
        tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) and len(tdata) > 0 else (int(tid_key) if str(tid_key).isdigit() else 0)
        tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) and len(tdata) > 1 else (int(tdata) if isinstance(tdata, (int, str)) and str(tdata).isdigit() else 0)
        
        t_info = tech_tables.get(str(tid), {})
        lv_data = t_info.get(str(tlv))
        if lv_data:
            pw, bt, bnt = lv_data[0], lv_data[1], lv_data[2]
            if bt == 43: # SINGLE_TROOP_STRENGTH
                cardinal = 1 if bnt == 2 else 1000
                val = int(pw / cardinal)
                tech_add += val
                print(f"   - Tech {tid} Lv.{tlv} (bt=43): +{val} flat")
            elif bt in (73, 77, 95):
                grp = pw / 1000.0
                techGroupAdd += grp
                print(f"   - Tech {tid} Lv.{tlv} (bt={bt}): +{grp} ({pw/10}%)")
    print(f"   => Total tech_add = {tech_add}")
    print(f"   => Total techGroupAdd = {techGroupAdd}")
    
    # C. Buffs (buffCtrl)
    buff_ctrl = data.get('buffCtrl', {})
    print(f"4. Buffs (buffCtrl):")
    if isinstance(buff_ctrl, list):
        print(f"   buffCtrl array: {buff_ctrl}")
    elif isinstance(buff_ctrl, dict):
        print(f"   buffCtrl dict keys: {list(buff_ctrl.keys())}")
    
    # Let's inspect boeAttributeCtrl or other buff sources
    boe = data.get('boeAttributeCtrl', {})
    print(f"5. boeAttributeCtrl:")
    if isinstance(boe, dict):
        print(f"   boe keys: {list(boe.keys())}")
        # check effect 96 and 19
        v5 = boe.get('1', {}).get('1', {}).get('5', {})
        print(f"   boe 1.1.5: {v5}")
    
    # VIP
    vip = data.get('vipCtrl', {})
    print(f"6. VIP: {vip}")
    
    # D. Heroes
    hero_sys = data.get('heroSysCtrl', {})
    hl = hero_sys.get('heroList', {})
    defend_list = hero_sys.get('defendList', {})
    defend_ids = set()
    for item in defend_list.values():
        if isinstance(item, dict) and 'heroID' in item:
            defend_ids.add(item['heroID'])
        elif isinstance(item, int):
            defend_ids.add(item)
            
    print(f"7. Heroes in castle: {len(hl)}, Defending: {defend_ids}")
    
    hero_records = []
    for hid_str, hdata in hl.items():
        hid = int(hid_str)
        lv = hdata.get('level', 1)
        st = hdata.get('state', 1)
        q = hdata.get('quality', 1)
        rarity = hero_meta.get(hid, {}).get('rarity', 1)
        name = hero_meta.get(hid, {}).get('name', str(hid))
        march_base = rare_lvs.get(rarity, {}).get(lv, 0)
        
        # Available in dispatch:
        # states = {HERO_STATE_NORMAL = 1, HERO_STATE_GARRISON = 5}
        # In WorldDispatchArmyViewPanel:
        # self.stateList[gHeroState.HERO_STATE_GARRISON] = true
        # and default states has NORMAL=true.
        # But if hero is in defendList:
        # Does dispatch allow defending heroes?
        # In heroSelectBanner:
        # if gHeroSelectBannerStyle.dispatch == self.myMode then
        #   self.stateList[gHeroState.HERO_STATE_GARRISON] = true
        # (Defending heroes have state=HERO_STATE_DEFEND=5 or are in defendList)
        is_available = (st == 1)
        hero_records.append({
            'hid': hid,
            'name': name,
            'lv': lv,
            'state': st,
            'quality': q,
            'rarity': rarity,
            'march_base': march_base,
            'is_defending': hid in defend_ids
        })
        
    hero_records.sort(key=lambda x: (
        1 if x['state'] == 1 and not x['is_defending'] else 0,
        x['march_base'],
        x['lv'],
        x['rarity'],
        x['quality'],
        -x['hid']
    ), reverse=True)
    
    print("   Top 5 sorted dispatch heroes (excluding defending):")
    top5_sum = 0
    for i, hr in enumerate(hero_records[:5]):
        top5_sum += hr['march_base']
        print(f"     #{i+1}: Hero {hr['hid']} ({hr['name']}): Lv.{hr['lv']}, Rarity {hr['rarity']}, Quality {hr['quality']} -> +{hr['march_base']}")
    print(f"   => Total Hero March Capacity (top 5) = {top5_sum}")
    
    # Also sort including defending (if dispatch allows or doesn't exclude)
    hero_records_all = sorted(hero_records, key=lambda x: (
        1 if x['state'] == 1 else 0,
        x['march_base'],
        x['lv'],
        x['rarity'],
        x['quality'],
        -x['hid']
    ), reverse=True)
    top5_all_sum = sum(hr['march_base'] for hr in hero_records_all[:5])
    print(f"   => If defending heroes are included: top 5 = {top5_all_sum}")
    if top5_all_sum != top5_sum:
        for i, hr in enumerate(hero_records_all[:5]):
            print(f"     [All] #{i+1}: Hero {hr['hid']} ({hr['name']}): Lv.{hr['lv']}, Rarity {hr['rarity']} -> +{hr['march_base']} (defending={hr['is_defending']})")

analyze_castle('beetoo1', 'tools/beetoo1_full_init_data.json')
analyze_castle('beetoo2', 'tools/beetoo2_full_init_data.json')
