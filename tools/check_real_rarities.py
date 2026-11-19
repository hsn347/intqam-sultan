import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_client\hero_view_info.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

heroes_to_check = [1712, 1711, 1717, 1707, 1708, 1700, 1703, 1709, 1706, 1713, 1718, 1714, 1710, 1704, 1705, 1702, 1701]

for hid in heroes_to_check:
    # find [hid] = { ... }
    m = re.search(rf'\[{hid}\]\s*=\s*\{{([^}}]+)\}}', content)
    if m:
        body = m.group(1)
        rarity = re.search(r'rarity\s*=\s*(\d+)', body)
        name = re.search(r'name\s*=\s*"([^"]+)"', body)
        print(f"Hero {hid}: name={name.group(1) if name else '?'}, rarity={rarity.group(1) if rarity else '?'}")
    else:
        # maybe formatted differently
        idx = content.find(str(hid))
        if idx != -1:
            print(f"Hero {hid} snippet:")
            for l in content[idx:idx+200].splitlines()[:5]:
                print("  ", l.strip())
        else:
            print(f"Hero {hid} not found")
