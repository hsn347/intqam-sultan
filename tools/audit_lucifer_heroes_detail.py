import json
import sys
import os
sys.path.insert(0, os.path.abspath("."))

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

hlist = data.get("heroSysCtrl", {}).get("heroList", {})
print(f"Total heroes owned by Lucifer: {len(hlist)}")

from tasks.march_capacity import HERO_RARITY_CATALOG, HERO_RARE_LEVEL_MARCH_ADD, get_hero_battle_skill_march_add, HERO_ARABIC_NAMES

hero_details = []
for hid_str, h in hlist.items():
    hid = int(hid_str)
    lv = int(h.get("level", 1))
    state = int(h.get("state", 1))
    rar = HERO_RARITY_CATALOG.get(hid, 1)
    base_add = HERO_RARE_LEVEL_MARCH_ADD.get(rar, {}).get(lv, 0)
    
    # check skills
    skill_add = 0
    skills = h.get("skillList", {})
    for sk_id_str, sk in skills.items():
        sk_id = int(sk_id_str)
        # check if it's battle skill that adds march capacity
        qly = int(sk.get("quality", 1)) if isinstance(sk, dict) else 1
        s_add = get_hero_battle_skill_march_add(sk_id, qly)
        if s_add > 0:
            skill_add += s_add
            
    total_hero_add = base_add + skill_add
    name = HERO_ARABIC_NAMES.get(hid, str(hid))
    hero_details.append({
        "id": hid,
        "name": name,
        "level": lv,
        "state": state,
        "rarity": rar,
        "base_add": base_add,
        "skill_add": skill_add,
        "total": total_hero_add
    })

hero_details.sort(key=lambda x: x["total"], reverse=True)

print("\nTop 10 Heroes by potential capacity:")
for h in hero_details[:10]:
    state_str = "NORMAL (in castle)" if h["state"] == 1 else f"BUSY (state={h['state']})"
    print(f"  {h['name']} ({h['id']}): Lv.{h['level']} rar={h['rarity']} -> base={h['base_add']} + skill={h['skill_add']} = {h['total']} [{state_str}]")

# Top 5 overall:
top5_overall = hero_details[:5]
sum_top5_overall = sum(h["total"] for h in top5_overall)
print(f"\nSum top 5 overall: {sum_top5_overall}")

# Top 5 in castle (state == 1):
in_castle = [h for h in hero_details if h["state"] == 1]
top5_castle = in_castle[:5]
sum_top5_castle = sum(h["total"] for h in top5_castle)
print(f"Sum top 5 in castle: {sum_top5_castle}")
print("Top 5 in castle:")
for h in top5_castle:
    print(f"  {h['name']} ({h['id']}): Lv.{h['level']} rar={h['rarity']} = {h['total']}")
