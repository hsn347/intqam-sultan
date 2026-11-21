import json
import os

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

heroes = d1.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in heroes.items():
    if int(h.get('level', 1)) > 1:
        print(f"Hero {hid}: lv={h.get('level')}, q={h.get('quality')}, isAwake={h.get('isAwake')}")
        if h.get('masterySkill'):
            print(f"  masterySkill: {h.get('masterySkill')}")
        if h.get('powerSkill'):
            # only non-zero buffValue
            non_zero = {k: v for k, v in h.get('powerSkill', {}).items() if v.get('buffValue', 0) > 0}
            if non_zero:
                print(f"  powerSkill: {non_zero}")
        if h.get('advancedSkill'):
            print(f"  advancedSkill: {h.get('advancedSkill')}")
