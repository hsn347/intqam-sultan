import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

army = data.get("armyCtrl", {})
total_soldiers = 0
for aid, count in army.items():
    if isinstance(count, dict):
        c = count.get("free", 0) or count.get("count", 0)
    else:
        c = count
    try:
        total_soldiers += int(c)
        print(f"Army {aid}: {c}")
    except:
        pass

print(f"\n===> TOTAL SOLDIERS IN CASTLE: {total_soldiers:,}")
