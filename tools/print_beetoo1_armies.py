import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

army = data.get("armyCtrl", {})
total_army = army.get("totalArmy", {})
print("=== totalArmy ===")
total_free = 0
for aid, adata in total_army.items():
    print(aid, "=>", adata)
    if isinstance(adata, dict):
        total_free += int(adata.get("free", 0))

print(f"Total free soldiers in castle: {total_free:,}")

print("\n=== compileArmy (Pre-set march teams) ===")
for cid, cdata in army.get("compileArmy", {}).items():
    print(cid, "=>", cdata)
