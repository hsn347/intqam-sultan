import json
import os

candidates = [
    "tools/beetoo2_full_init_data.json",
    "docs/beetoo2_live_memory.json",
    "docs/LUCIFER@g4.coom_live_memory.json"
]

for p in candidates:
    if os.path.exists(p):
        with open(p, "r", encoding="utf-8") as f:
            d = json.load(f)
        print(f"\n=================== {p} ===================")
        bctrl = d.get("buffCtrl")
        print("Type of buffCtrl:", type(bctrl))
        if isinstance(bctrl, dict):
            print("buffCtrl keys:", list(bctrl.keys())[:20])
            print("buffCtrl sample:", json.dumps(bctrl, indent=2, ensure_ascii=False)[:500])
        elif isinstance(bctrl, list):
            print("buffCtrl list length:", len(bctrl))
            print("buffCtrl sample items:", bctrl[:5])
        
        # Check lordSkillCtrl
        lskill = d.get("lordSkillCtrl")
        print("Type of lordSkillCtrl:", type(lskill))
        if lskill:
            print("lordSkillCtrl sample:", json.dumps(lskill, indent=2, ensure_ascii=False)[:300])

        # Check equipmentCtrl
        eq = d.get("equipmentCtrl")
        print("Type of equipmentCtrl:", type(eq))
        if eq:
            print("equipmentCtrl sample:", json.dumps(eq, indent=2, ensure_ascii=False)[:300])

        # Check petCtrl
        pet = d.get("petCtrl")
        print("Type of petCtrl:", type(pet))
        if pet:
            print("petCtrl sample:", json.dumps(pet, indent=2, ensure_ascii=False)[:300])
