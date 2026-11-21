import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

print("=== BEETOO1 HEROES ===")
heroList1 = d1.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in sorted(heroList1.items(), key=lambda x: (x[1].get('level', 0), x[1].get('quality', 0)), reverse=True):
    print(f"Hero {hid}: Level={h.get('level')}, Quality={h.get('quality')}, State={h.get('state')}, Awake={h.get('isAwake')}, Skills={list(h.get('skillList', {}).keys())}, PowerSkill={h.get('powerSkill')}, Mastery={h.get('masterySkill')}")

print("\n=== BEETOO2 HEROES ===")
heroList2 = d2.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in sorted(heroList2.items(), key=lambda x: (x[1].get('level', 0), x[1].get('quality', 0)), reverse=True):
    if h.get('level', 1) > 1:
        print(f"Hero {hid}: Level={h.get('level')}, Quality={h.get('quality')}, State={h.get('state')}, Awake={h.get('isAwake')}, Skills={list(h.get('skillList', {}).keys())}")
