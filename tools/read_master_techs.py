import json

with open("tools/master_march_tables.json", "r", encoding="utf-8") as f:
    data = json.load(f)

techs = data.get("techs", {})
print(f"Total march tech IDs: {len(techs)}")
for tid, tinfo in techs.items():
    max_lv = max(int(lv) for lv in tinfo.keys())
    max_pw = tinfo[str(max_lv)][0]
    bt = tinfo[str(max_lv)][1]
    print(f"  Tech ID {tid} (max Lv.{max_lv}): power={max_pw}, buffType={bt}")
