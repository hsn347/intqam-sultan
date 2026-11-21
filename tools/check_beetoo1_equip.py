import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

equip = d1.get('equipmentCtrl', {})
print("beetoo1 equipmentCtrl keys:", list(equip.keys()))
for k, v in equip.items():
    print(f"  {k}: {type(v).__name__} = {json.dumps(v)[:100]}")
