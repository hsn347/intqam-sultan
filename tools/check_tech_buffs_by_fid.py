import json
import re

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tech_ctrl = data.get("technologyCtrl", {})
researched = {}
for k, v in tech_ctrl.items():
    if isinstance(v, list) and len(v) >= 2:
        researched[int(v[0])] = int(v[1])

print(f"Researched techs count: {len(researched)}")

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

# Match entries by technologyID
entries = re.findall(r'technologyID\s*=\s*(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+).*?buffNumType\s*=\s*(\d+)', content, re.DOTALL)
print(f"Found {len(entries)} tech entries by ID")

tech_by_id = {}
for fid_str, bt_str, pw_str, bnt_str in entries:
    tech_by_id[int(fid_str)] = (int(bt_str), int(pw_str), int(bnt_str))

buff_sums = {}
march_techs = []
for tid, tlv in researched.items():
    # In ROS: technologyID = tid * 100 + tlv (or similar)
    fid = tid * 100 + tlv
    entry = tech_by_id.get(fid)
    if entry:
        bt, pw, bnt = entry
        cardinal = 1 if bnt == 2 else 1000
        val = pw / cardinal
        buff_sums[bt] = buff_sums.get(bt, 0) + val
        if bt == 43:
            march_techs.append((tid, tlv, pw, val))
            print(f"March Tech 43: tid={tid}, lv={tlv}, pw={pw}, val={val}")
        elif val == 4500 or pw == 4500:
            print(f"FOUND 4500: tid={tid}, lv={tlv}, bt={bt}, val={val}")
    else:
        print(f"Missing fid: {fid} (tid={tid}, tlv={tlv})")

print("\n--- Summary of Buff Types ---")
for bt, s in sorted(buff_sums.items()):
    print(f"  Buff Type {bt}: {s}")

print(f"\nTotal Tech 43 (March Strength): {buff_sums.get(43, 0)}")
