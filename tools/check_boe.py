import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

print("beetoo1 boeAttributeCtrl:", d1.get("boeAttributeCtrl"))
print("beetoo2 boeAttributeCtrl:", d2.get("boeAttributeCtrl"))
