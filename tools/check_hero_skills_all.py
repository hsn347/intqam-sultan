import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

heroes = data.get("heroSysCtrl", {}).get("heroList", {})
print(f"Total heroes: {len(heroes)}")
for hid, hdata in heroes.items():
    skills = hdata.get("skillList", {})
    active_skills = [s for s in skills.values() if isinstance(s, dict) and s.get("isActive")]
    if active_skills:
        print(f"Hero {hid} (lv={hdata.get('level')}, rarity={hdata.get('rarity')}):")
        for s in active_skills:
            print("  ", s)
