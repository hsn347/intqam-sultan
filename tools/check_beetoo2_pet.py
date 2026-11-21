import json

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

pet = d2.get("petCtrl", {})
print("beetoo2 petCtrl:", json.dumps(pet, indent=2)[:400])
