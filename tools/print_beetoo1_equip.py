import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

equip_array = d1.get('equipmentCtrl', {}).get('equipment_array', [])
print(f"Total equipment in beetoo1: {len(equip_array)}")
for eq in equip_array:
    if eq.get('wear') == 1:
        print("Equipped:", eq)
