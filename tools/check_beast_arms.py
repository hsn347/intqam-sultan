import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("Checking beast and god arms...")
for k in data.keys():
    if any(t in k.lower() for t in ["beast", "divine", "god", "arm", "rune"]):
        print(f"Key {k}: {type(data[k])}")

# Also check inside armyCtrl
army = data.get("armyCtrl", {})
print("\narmyCtrl keys with beast/arms/hero:")
for k, v in army.items():
    if any(t in k.lower() for t in ["beast", "arms", "hero", "compile"]):
        print(f"  {k}: {v}")
