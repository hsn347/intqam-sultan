import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    lucifer = json.load(f)

hlist = lucifer.get("heroSysCtrl", {}).get("heroList", {})
print("Lucifer heroes count:", len(hlist))

hero_details = []
for hid, hdata in hlist.items():
    state = hdata.get("state")
    level = hdata.get("level")
    # let's find hero rarity
    hero_details.append({
        "id": hid,
        "level": level,
        "state": state,
    })

# sort by level descending
hero_details.sort(key=lambda x: int(x["level"] or 0), reverse=True)
for hd in hero_details:
    print(f"Hero {hd['id']}: level={hd['level']}, state={hd['state']}")
