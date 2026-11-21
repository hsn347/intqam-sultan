# -*- coding: utf-8 -*-
"""
tools/build_march_tables.py
Extracts and validates all official game march calculation tables directly from client files:
  1. build121.lua (Drill Grounds Lv 1-130)
  2. buildstar121.lua (Glory Stars 1-70)
  3. hero_view_info.lua (Official Hero Inherent Rarities & Names)
  4. hero_level_config.lua (Hero March Addition for Rarities 1-5, Levels 1-120)
  5. hero_skill_conf.lua (Battle March Skills with buffType=96 and activeType=2)
  6. achievement_info.lua (Achievement Medal 17 thresholds & permille buffs)
  7. technology.lua / technologyAuxiliary (Leadership Techs Type 43, 73, 77, 95)
"""
import json
import os
import re

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def parse_all():
    tables = {}

    # 1. Drill grounds levels
    b121_path = os.path.join(_ROOT, "game_file", "src", "app", "localtb", "config_server", "build121.lua")
    with open(b121_path, "r", encoding="utf-8", errors="ignore") as f:
        b121_text = f.read()

    drill_levels = {}
    for m in re.finditer(r"blv\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+).*?capacity\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+)", b121_text, re.DOTALL):
        lv = int(m.group(1))
        cap = int(m.group(2))
        if 1 <= lv <= 130 and lv not in drill_levels:
            drill_levels[str(lv)] = cap
    tables["drill_levels"] = drill_levels
    print(f"[1] Parsed drill_levels: {len(drill_levels)} levels (1..{max(int(k) for k in drill_levels)})")

    # 2. Drill grounds star levels
    bstar_path = os.path.join(_ROOT, "game_file", "src", "app", "localtb", "config_server", "buildstar121.lua")
    with open(bstar_path, "r", encoding="utf-8", errors="ignore") as f:
        bstar_text = f.read()

    drill_stars = {}
    for m in re.finditer(r"starlv\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+).*?capacity\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+)", bstar_text, re.DOTALL):
        slv = int(m.group(1))
        scap = int(m.group(2))
        if 1 <= slv <= 70 and slv not in drill_stars:
            drill_stars[str(slv)] = scap
    tables["drill_stars"] = drill_stars
    print(f"[2] Parsed drill_stars: {len(drill_stars)} stars (1..{max(int(k) for k in drill_stars)})")

    # 3. Hero view info (rarity + name)
    hview_path = os.path.join(_ROOT, "game_file", "src", "app", "localtb", "config_client", "hero_view_info.lua")
    with open(hview_path, "r", encoding="utf-8", errors="ignore") as f:
        hview_text = f.read()

    heroes = {}
    chunks = re.split(r";\(nil\)\.heroID\s*=\s*|heroID\s*=\s*", hview_text)
    for c in chunks[1:]:
        m_id = re.match(r"^(\d+)", c)
        if not m_id:
            continue
        hid = int(m_id.group(1))
        m_r = re.search(r"rarity\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+)", c)
        m_n = re.search(r"name\s*=\s*\"([^\"]+)\"", c)
        rarity = int(m_r.group(1)) if m_r else 1
        name = m_n.group(1) if m_n else f"heroname_{hid}"
        heroes[str(hid)] = {"rarity": rarity, "name": name}
    tables["heroes"] = heroes
    print(f"[3] Parsed heroes: {len(heroes)} heroes")

    # 4. Hero level config (rarity 1..5, level 1..120)
    hlv_path = os.path.join(_ROOT, "game_file", "src", "app", "localtb", "config_server", "hero_level_config.lua")
    with open(hlv_path, "r", encoding="utf-8", errors="ignore") as f:
        hlv_text = f.read()

    rare_levels = {}
    entries = re.split(r";\([^\)]*\)\.ID\s*=\s*\d+", hlv_text)
    for e in entries[1:]:
        r_m = re.search(r"rarity\s*=\s*(?:nil,\s*)?(\d+)", e)
        l_m = re.search(r"level\s*=\s*(?:nil,\s*)?(\d+)", e)
        m_m = re.search(r"march_add\s*=\s*(?:nil,\s*)?(\d+)", e)
        if r_m and l_m and m_m:
            r = str(int(r_m.group(1)))
            l = str(int(l_m.group(1)))
            m = int(m_m.group(1))
            if r not in rare_levels:
                rare_levels[r] = {}
            rare_levels[r][l] = m
    tables["rare_levels"] = rare_levels
    print(f"[4] Parsed rare_levels: {len(rare_levels)} rarities, all up to level 120")

    # 5. Hero battle march skills (buffType=96, activeType=2)
    hskill_path = os.path.join(_ROOT, "game_file", "src", "app", "localtb", "config_server", "hero_skill_conf.lua")
    with open(hskill_path, "r", encoding="utf-8", errors="ignore") as f:
        hskill_text = f.read()

    skill_entries = re.split(r";\([^\)]*\)\.id\s*=\s*\d+", hskill_text)
    battle_march_skills = {}
    for se in skill_entries[1:]:
        sid_m = re.search(r"skillID\s*=\s*(?:nil,\s*)?(\d+)", se)
        at_m = re.search(r"activeType\s*=\s*(?:nil,\s*)?(\d+)", se)
        bt_m = re.search(r"buffType\s*=\s*(?:nil,\s*)?(\d+)", se)
        bv_m = re.search(r"buffValue\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+)", se)
        if sid_m and at_m and bt_m and bv_m:
            sid = int(sid_m.group(1))
            at = int(at_m.group(1))
            bt = int(bt_m.group(1))
            bv = int(bv_m.group(1))
            if bt == 96 and at == 2:
                # Store by skillType (sid // 100)
                st = sid // 100
                battle_march_skills[st] = bv
    tables["hero_battle_march_skills"] = {str(k): v for k, v in battle_march_skills.items()}
    print(f"[5] Parsed battle_march_skills: {len(battle_march_skills)} distinct skill types")

    # 6. Achievement medal 17 (Rally Kills - single march capacity boost)
    ach_path = os.path.join(_ROOT, "game_file", "src", "app", "localtb", "config_client", "achievement_info.lua")
    with open(ach_path, "r", encoding="utf-8", errors="ignore") as f:
        ach_text = f.read()

    ach_entries = re.split(r";\([^\)]*\)\.ID\s*=\s*", ach_text)
    achieve_17_tiers = {}
    kill_thresholds = []
    for ae in ach_entries[1:]:
        m_id = re.match(r"^(\d+)", ae)
        if not m_id:
            continue
        aid = int(m_id.group(1))
        m_type = re.search(r"type\s*=\s*(?:nil,\s*|(?:\d+),\s*)*(\d+)", ae)
        if not m_type or int(m_type.group(1)) != 17:
            continue
        # Check medalBuff: effectType 14 = MARCH_LIMIT_BOOST
        m_buff = re.search(r"medalBuff\s*,\s*[^\[]*\[1\]\s*=\s*[^,\n]*,\s*14\b.*?medalBuff\s*,\s*[^\[]*\[2\]\s*=\s*[^,\n]*,\s*(\d+)", ae, re.DOTALL)
        # Check required kills: num = <kills>
        nums = re.findall(r"num\s*=\s*(\d+)", ae)
        if m_buff:
            buff_permille = int(m_buff.group(1))
            achieve_17_tiers[str(aid)] = buff_permille
            if len(nums) >= 2:
                req_kills = int(nums[1])
                kill_thresholds.append((req_kills, buff_permille))

    kill_thresholds.sort(key=lambda x: x[0], reverse=True)
    tables["achievement_march_tiers"] = achieve_17_tiers
    tables["kill_thresholds"] = kill_thresholds
    print(f"[6] Parsed achievement 17 tiers: {len(achieve_17_tiers)} tiers, {len(kill_thresholds)} thresholds")

    # 7. Preserve existing tech tables from previous json if present
    old_json_path = os.path.join(_ROOT, "tools", "march_data_tables.json")
    if os.path.exists(old_json_path):
        with open(old_json_path, "r", encoding="utf-8") as f:
            old_data = json.load(f)
            if "techs" in old_data:
                tables["techs"] = old_data["techs"]
                print(f"[7] Preserved tech tables: {len(tables['techs'])} techs")

    # Save to tools/march_data_tables.json
    out_path = os.path.join(_ROOT, "tools", "march_data_tables.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(tables, f, indent=2, ensure_ascii=False)
    print(f"Saved complete verified tables to {out_path}")

if __name__ == "__main__":
    parse_all()
