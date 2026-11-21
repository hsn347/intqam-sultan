import json
import re

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    skill_conf = f.read()

heroes = d1.get('heroSysCtrl', {}).get('heroList', {})
for hid in ['1717', '1711', '1710', '1704', '1718']:
    h = heroes.get(hid, {})
    skills = h.get('skillList', {})
    print(f"\n=== Hero {hid} (lv={h.get('level')}, q={h.get('quality')}) ===")
    for sk_key, s_data in skills.items():
        st = s_data.get('skillType')
        is_act = s_data.get('isActive')
        # search in skill_conf
        m = re.search(r'skillID\s*=\s*' + str(st) + r'01\b.*?buffType\s*=\s*(\d+).*?buffValue\s*=\s*(\d+)', skill_conf, re.DOTALL)
        if m:
            bt = m.group(1)
            bv = m.group(2)
            print(f"  Skill {st}: isActive={is_act}, buffType={bt}, buffValue={bv}")
        else:
            # try finding skillID without 01
            m2 = re.search(r'skillID\s*=\s*' + str(st) + r'\b.*?buffType\s*=\s*(\d+).*?buffValue\s*=\s*(\d+)', skill_conf, re.DOTALL)
            if m2:
                print(f"  Skill {st}: isActive={is_act}, buffType={m2.group(1)}, buffValue={m2.group(2)}")
            else:
                print(f"  Skill {st}: isActive={is_act} (no direct match)")
