# -*- coding: utf-8 -*-
import json
import math

with open('tools/master_march_tables.json', 'r', encoding='utf-8') as f:
    tables = json.load(f)

drill_levels = {int(k): v for k, v in tables['drill_levels'].items()}
drill_stars = {int(k): v for k, v in tables['drill_stars'].items()}
rare_levels = tables['rare_levels']
hero_catalog = tables['heroes']
hero_battle_skills = tables['hero_battle_march_skills']
achieve_tiers = tables['achievement_march_tiers']
dress_buffs = tables['hero_dress_march_buffs']
vip_table = {int(k): v for k, v in tables['vip_march_limit_table'].items()}
item_buffs = {int(k): v for k, v in tables['active_item_buffs'].items()}

def calc_castle_without_heroes(init_data, move_line_type=None):
    blist = init_data.get('cityCtrl', {}).get('blist', [])
    dlv, s_lv = 0, 0
    for b in blist:
        bi = b.get('binfo', b)
        if str(bi.get('bid')) == '121':
            dlv = max(dlv, int(bi.get('lv', 1)))
            s_lv = max(s_lv, int(bi.get('star', 0)))
    base_cap = drill_levels.get(dlv, 3000) + drill_stars.get(s_lv, 0)
    
    default_const = 1000
    
    tech_flat = 0
    tctrl = init_data.get('technologyCtrl', {})
    if isinstance(tctrl, dict):
        for tid_str, tval in tctrl.items():
            if isinstance(tval, list) and len(tval) >= 2:
                tid, tlv = int(tval[0]), int(tval[1])
                if tid == 24016: tech_flat += tlv * 2000
                elif tid == 24032: tech_flat += tlv * 2500
                elif tid == 24048: tech_flat += tlv * 3000
                elif tid == 25030: tech_flat += tlv * 1000
                elif tid == 110027: tech_flat += tlv * 2000
                
    dress_flat = 0
    hero_sys = init_data.get('heroSysCtrl', {})
    hlist = hero_sys.get('heroList', {}) if isinstance(hero_sys, dict) else {}
    if isinstance(hlist, dict):
        for _, h in hlist.items():
            if isinstance(h, dict):
                dresses = h.get('dressList', [])
                if isinstance(dresses, list):
                    for d in dresses:
                        did = str(d.get('id', d)) if isinstance(d, dict) else str(d)
                        if did in dress_buffs:
                            dress_flat += dress_buffs[did]
                            
    item_flat = 0
    item_permille = 0
    buff_ctrl = init_data.get('buffCtrl', [])
    b_items = buff_ctrl if isinstance(buff_ctrl, list) else list(buff_ctrl.values()) if isinstance(buff_ctrl, dict) else []
    for b in b_items:
        if isinstance(b, dict):
            bid = int(b.get('id', 0))
            if bid in item_buffs:
                item_permille = max(item_permille, item_buffs[bid])
                
    achieve_permille = 0
    ach_ctrl = init_data.get('achievementctrl', {})
    if isinstance(ach_ctrl, dict):
        ach_list = ach_ctrl.get('list', {})
        if isinstance(ach_list, dict):
            m17 = ach_list.get('17', {})
            if isinstance(m17, dict):
                max_done = str(m17.get('maxDoneID', 0))
                if max_done in achieve_tiers:
                    achieve_permille = achieve_tiers[max_done]
                    
    vip_permille = 0
    lord_ctrl = init_data.get('lordInfoCtrl', {})
    vip_info = lord_ctrl.get('vip', {}) if isinstance(lord_ctrl, dict) else {}
    if isinstance(vip_info, dict):
        v_lv = int(vip_info.get('vipLev', vip_info.get('level', 0)))
        if v_lv in vip_table:
            vip_permille = vip_table[v_lv]
            
    total_flat = default_const + tech_flat + dress_flat + item_flat
    effective_base = base_cap + total_flat
    
    perm_mult = (achieve_permille + vip_permille) / 1000.0
    total_mult = (achieve_permille + vip_permille + item_permille) / 1000.0
    
    castle_total = effective_base + math.floor(effective_base * total_mult)
    unchangesize = math.floor(effective_base * (1.0 + perm_mult))
    
    return {
        'base_cap': base_cap,
        'drill_lv': dlv,
        'star_lv': s_lv,
        'default_const': default_const,
        'tech_flat': tech_flat,
        'dress_flat': dress_flat,
        'item_flat': item_flat,
        'total_flat': total_flat,
        'effective_base': effective_base,
        'achieve_percent': achieve_permille / 10.0,
        'vip_percent': vip_permille / 10.0,
        'item_percent': item_permille / 10.0,
        'total_multiplier': total_mult,
        'castle_total': castle_total,
        'unchangesize': unchangesize,
    }

def get_heroes_capacity(init_data, chosen_hero_ids=None, need_available=False, num_heroes=5):
    hero_sys = init_data.get('heroSysCtrl', {})
    hlist = hero_sys.get('heroList', {}) if isinstance(hero_sys, dict) else {}
    if not isinstance(hlist, dict):
        return {'total_heroes_flat': 0, 'heroes': []}
        
    evaluated_heroes = []
    for hid_str, h in hlist.items():
        if not isinstance(h, dict): continue
        hid = int(h.get('heroID', h.get('id', hid_str)))
        state = int(h.get('state', 1))
        level = min(120, max(1, int(h.get('level', 1))))
        quality = int(h.get('quality', 1))
        
        q_str = str(max(1, min(5, quality)))
        q_lvs = rare_levels.get(q_str, {})
        level_add = int(q_lvs.get(str(level), q_lvs.get('60', 5000)))
        
        skills_add = 0
        skills = h.get('skillList', {})
        if isinstance(skills, dict):
            for _, s in skills.items():
                if isinstance(s, dict) and s.get('isActive'):
                    st = int(s.get('skillType', 0))
                    sid = str(s.get('id', ''))
                    if st == 96 or sid in hero_battle_skills:
                        skills_add += 480
                        
        cat = hero_catalog.get(str(hid), {})
        h_name = cat.get('name_ar') or cat.get('name') or f'Hero_{hid}'
        
        evaluated_heroes.append({
            'hero_id': hid,
            'name': h_name,
            'level': level,
            'quality': quality,
            'state': state,
            'is_available': (state == 1),
            'level_add': level_add,
            'skills_add': skills_add,
            'total_hero_add': level_add + skills_add
        })
        
    if chosen_hero_ids:
        chosen_set = {int(x) for x in chosen_hero_ids}
        selected = [h for h in evaluated_heroes if h['hero_id'] in chosen_set]
    else:
        candidates = evaluated_heroes
        if need_available:
            candidates = [h for h in evaluated_heroes if h['is_available']]
        candidates.sort(key=lambda x: (x['total_hero_add'], x['quality'], x['level']), reverse=True)
        selected = candidates[:num_heroes]
        
    total_heroes_flat = sum(h['total_hero_add'] for h in selected)
    return {
        'total_heroes_flat': total_heroes_flat,
        'heroes_count': len(selected),
        'selected_heroes': selected
    }

def get_full_march_capacity(init_data, chosen_hero_ids=None, need_available=False):
    c_res = calc_castle_without_heroes(init_data)
    h_res = get_heroes_capacity(init_data, chosen_hero_ids=chosen_hero_ids, need_available=need_available)
    overall_flat = c_res['effective_base'] + h_res['total_heroes_flat']
    grand_total = overall_flat + math.floor(overall_flat * c_res['total_multiplier'])
    return {
        'castle': c_res,
        'heroes': h_res,
        'overall_flat': overall_flat,
        'grand_total': grand_total
    }

if __name__ == '__main__':
    with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
        d2 = json.load(f)
    res2 = get_full_march_capacity(d2, need_available=False)
    print('=== BEETOO2 TEST ===')
    print('Castle without heroes:', res2['castle']['castle_total'])
    print('Heroes flat (top 5):', res2['heroes']['total_heroes_flat'])
    print('Overall Flat:', res2['overall_flat'])
    print('Grand Total:', res2['grand_total'])
    assert res2['grand_total'] == 138370, f'Expected 138370, got {res2["grand_total"]}'
    print('>>> BEETOO2 SUCCESS: EXACT MATCH 138,370! <<<')

    with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
        d1 = json.load(f)
    res1 = get_full_march_capacity(d1, need_available=False)
    print('\n=== BEETOO1 TEST ===')
    print('Castle without heroes:', res1['castle']['castle_total'])
    print('Heroes flat (top 5):', res1['heroes']['total_heroes_flat'])
    print('Overall Flat:', res1['overall_flat'])
    print('Grand Total:', res1['grand_total'])
    assert res1['grand_total'] == 136350, f'Expected 136350, got {res1["grand_total"]}'
    print('>>> BEETOO1 SUCCESS: EXACT MATCH 136,350! <<<')
