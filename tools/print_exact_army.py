import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

army = data.get("armyCtrl", {})
total = 0
for aid, count in army.get("totalArmy", {}).items():
    c = int(count) if isinstance(count, (int, str)) else int(count.get("count", 0))
    total += c
    print(f"Soldier {aid}: {c}")

print(f"Total troops in castle = {total}")

w_total = 0
for aid, count in army.get("woundedArmy", {}).items():
    c = int(count) if isinstance(count, (int, str)) else int(count.get("count", 0))
    w_total += c
    print(f"Wounded {aid}: {c}")
print(f"Total wounded = {w_total}")
