# -*- coding: utf-8 -*-
import json
import os
import re

# Load tables from tools/march_data_tables.json
with open("tools/march_data_tables.json", "r", encoding="utf-8") as f:
    march_tables = json.load(f)

drill_levels = march_tables.get("drill_levels", {})
heroes_meta = march_tables.get("heroes", {})
rare_levels = march_tables.get("rare_levels", {})
battle_march_skills = march_tables.get("hero_battle_march_skills", {})

# Load hero skills config to get exact skill values
hskill_path = "game_file/src/app/localtb/config_server/hero_skill_conf.lua"
with open(hskill_path, "r", encoding="utf-8", errors="ignore") as f:
    hskill_text = f.read()

# Parse all skills from hero_skill_conf
skill_entries = re.split(r";\([^\)]*\)\.id\s*=\s*\d+", hskill_text)
all_skills = {}
for se in skill_entries[1:]:
    sid_m = re.search(r"skillID\s*=\s*(?:nil,\s*)?(\d+)", se)
    at_m = re.search(r"activeType\s*=\s*(?:nil,\s*)?(\d+)", se)
    bt_m = re.search(r"buffType\s*=\s*(?:nil,\s*)?(\d+)", se)
    bv_m = re.search(r"buffValue\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+)", se)
    if sid_m:
        sid = int(sid_m.group(1))
        all_skills[sid] = {
            "activeType": int(at_m.group(1)) if at_m else None,
            "buffType": int(bt_m.group(1)) if bt_m else None,
            "buffValue": int(bv_m.group(1)) if bv_m else 0,
        }

def analyze_heroes(json_path, name):
    with open(json_path, "r", encoding="utf-8") as f:
        d = json.load(f)
    
    hero_sys = d.get("heroSysCtrl", {})
    hero_list = hero_sys.get("heroList", {})
    
    print(f"\n==========================================")
    print(f"=== HERO AUDIT: {name} ({len(hero_list)} heroes) ===")
    print(f"==========================================")
    
    parsed_heroes = []
    
    for hid_str, hinfo in hero_list.items():
        hid = int(hid_str)
        meta = heroes_meta.get(str(hid), {})
        hname = meta.get("name", f"Hero_{hid}")
        rarity = meta.get("rarity", 1)
        level = hinfo.get("level", 1)
        quality = hinfo.get("quality", 1)
        state = hinfo.get("state", 0)
        is_awake = hinfo.get("isAwake", False)
        
        # Level march_add
        march_add_base = rare_levels.get(str(rarity), {}).get(str(level), 0)
        
        # Skills
        skills = hinfo.get("skill", {}) or hinfo.get("skills", {})
        march_skill_add = 0
        skill_details = []
        if isinstance(skills, dict):
            for slot_key, s_data in skills.items():
                # s_data might be list [skillId, ...] or dict
                sid = None
                if isinstance(s_data, list) and len(s_data) > 0:
                    sid = s_data[0]
                elif isinstance(s_data, dict):
                    sid = s_data.get("id") or s_data.get("skillID") or s_data.get("skillId")
                elif isinstance(s_data, int):
                    sid = s_data
                
                if sid:
                    scfg = all_skills.get(int(sid), {})
                    if scfg.get("buffType") == 96: # MARCH_VALUE_LIMIT_BOOST
                        march_skill_add += scfg.get("buffValue", 0)
                        skill_details.append(f"Skill {sid}: +{scfg.get('buffValue')}")
        
        total_hero_march = march_add_base + march_skill_add
        
        # Weapons / Dress
        dress = hinfo.get("dress", {})
        weapon = hinfo.get("weapon", {})
        star = hinfo.get("star", 0)
        
        parsed_heroes.append({
            "hid": hid,
            "name": hname,
            "rarity": rarity,
            "level": level,
            "quality": quality,
            "state": state,
            "is_awake": is_awake,
            "march_add_base": march_add_base,
            "march_skill_add": march_skill_add,
            "total_hero_march": total_hero_march,
            "skills": skill_details,
            "dress": dress,
            "weapon": weapon,
            "star": star,
            "raw": hinfo
        })
    
    # Sort heroes exactly as heroCtrl:sortDispatchHerosID
    # Order: V (state normal) desc, ownL desc, MarchNum desc, level desc, rarity desc, quality desc, hid asc
    def sort_key(h):
        v_state = 1 if h["state"] == 0 else 0 # 0 is normal state in gHeroState
        return (
            v_state,
            h["total_hero_march"],
            h["level"],
            h["rarity"],
            h["quality"],
            -h["hid"]
        )
    
    parsed_heroes.sort(key=sort_key, reverse=True)
    
    print(f"{'HID':<6} {'Name':<20} {'Rarity':<7} {'Lv':<4} {'Qual':<5} {'BaseAdd':<8} {'SkillAdd':<9} {'TotalAdd':<9} {'State'}")
    print("-" * 80)
    for h in parsed_heroes:
        print(f"{h['hid']:<6} {h['name']:<20} {h['rarity']:<7} {h['level']:<4} {h['quality']:<5} {h['march_add_base']:<8} {h['march_skill_add']:<9} {h['total_hero_march']:<9} {h['state']}")
        if h["skills"]:
            print(f"       -> Skills: {', '.join(h['skills'])}")
    
    top5 = parsed_heroes[:5]
    top5_sum = sum(h["total_hero_march"] for h in top5)
    print(f"\nTop 5 Heroes for {name}: {[h['hid'] for h in top5]}")
    print(f"Top 5 Heroes Total Capacity Add: {top5_sum}")
    return parsed_heroes

p1 = analyze_heroes("tools/beetoo1_full_init_data.json", "BEETOO 1")
p2 = analyze_heroes("tools/beetoo2_full_init_data.json", "BEETOO 2")
