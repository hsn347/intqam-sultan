import re
import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

heroList = d1.get('heroSysCtrl', {}).get('heroList', {})

# Let's read hero_skill_conf.lua
with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8') as f:
    skill_conf = f.read()

# Let's read hero_masteryskill_config.lua
with open('game_file/src/app/localtb/config_server/hero_masteryskill_config.lua', 'r', encoding='utf-8') as f:
    mastery_conf = f.read()

print("Checking skills for beetoo1 heroes...")
for hid, h in heroList.items():
    if h.get('level', 0) >= 40:
        print(f"\n--- HERO {hid} (Lv {h.get('level')}, Q {h.get('quality')}) ---")
        for stype, sdata in h.get('skillList', {}).items():
            if sdata.get('isActive'):
                realID = int(stype) * 100 + h.get('quality')
                # search in skill_conf for realID
                m = re.search(rf'\[{realID}\]\s*=\s*\{{([^}}]+)\}}', skill_conf)
                if not m:
                    # try alternative pattern
                    m = re.search(rf'\.ID\s*=\s*{realID}\b(.*?)(?=\.(?:ID|ID_ros|\(nil\)\.ID)\s*=\s*\d+|\Z)', skill_conf, re.DOTALL)
                if m:
                    txt = m.group(0)
                    if '96' in txt or 'buff' in txt.lower():
                        print(f"  Skill {realID}:")
                        for line in txt.splitlines()[:15]:
                            if any(k in line for k in ['buff', 'buffType', 'buffValue', 'activeType']):
                                print(f"    {line.strip()}")
        
        # Check masterySkill
        for mtype, mdata in h.get('masterySkill', {}).items():
            print(f"  MasterySkill: {mtype} -> {mdata}")
            # find in mastery_conf
            m = re.search(rf'ID\s*=\s*{mtype}\b(.*?)(?=\.ID\s*=\s*\d+|\Z)', mastery_conf, re.DOTALL)
            if m:
                print("    Found in mastery_conf:", m.group(0)[:300])

        # Check powerSkill
        for ptype, pdata in h.get('powerSkill', {}).items():
            print(f"  PowerSkill: {ptype} -> {pdata}")
