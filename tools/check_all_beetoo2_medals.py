import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

ach_list = data.get("achievementctrl", {}).get("list", {})
print(f"Total achievement entries: {len(ach_list)}")
for k, v in sorted(ach_list.items(), key=lambda x: int(x[0])):
    max_done = v.get("maxDoneID", 0)
    has_buff = v.get("hasBuff", 0)
    medal_id = v.get("medalID", 0)
    star = v.get("star", 0)
    if max_done > 0 or has_buff > 0 or star > 0:
        print(f"  Entry {k}: medalID={medal_id}, maxDoneID={max_done}, star={star}, hasBuff={has_buff}")
