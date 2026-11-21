import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

print("beetoo1 achievementctrl:", d1.get("achievementctrl"))
print("beetoo2 achievementctrl:", d2.get("achievementctrl"))
