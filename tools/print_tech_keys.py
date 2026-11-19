import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tech_ctrl = data.get("technologyCtrl", {})
print("Sample tech_ctrl items:")
for k, v in list(tech_ctrl.items())[:10]:
    print(k, v)
