import json

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

equip_array = d2.get('equipmentCtrl', {}).get('equipment_array', [])
print(f"Total equipment in beetoo2: {len(equip_array)}")
for eq in equip_array:
    if eq.get('wear') == 1:
        print("Equipped in beetoo2:", eq)
