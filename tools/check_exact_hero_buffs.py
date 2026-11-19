# -*- coding: utf-8 -*-
with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

skills_to_check = [
    # (Hero, Quality, [skillIDs])
    (1712, 5, [17120105, 17120205, 17120305, 17120405]),
    (1711, 4, [17110104, 17110204, 17110304, 17110404]),
    (1717, 5, [17170105, 17170205, 17170305, 17170405]),
    (1707, 3, [17070103, 17070203, 17070303, 17070403]),
    (1708, 3, [17080103, 17080203, 17080303, 17080403]),
]

for hid, q, sids in skills_to_check:
    print(f"\n=== Hero {hid} (quality {q}) ===")
    for sid in sids:
        # find in lines
        for i, l in enumerate(lines):
            if f"skillID = {sid}" in l or f".skillID = {sid}" in l:
                # print next 10 lines
                block = "".join(lines[i:min(len(lines), i+10)])
                print(f"  Skill {sid}:\n    " + "\n    ".join(l.strip() for l in lines[i:i+8]))
                break

# Also check ANY skill with buffType = 96 or buffType = 19
print("\n=== All skills with buffType = 96 or 19 in hero_skill_conf.lua ===")
for i, l in enumerate(lines):
    if ".buffType = 96" in l or ".buffType = 19" in l:
        print("".join(lines[max(0, i-6):min(len(lines), i+4)]))
