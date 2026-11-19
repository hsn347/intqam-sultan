import re

pets = [
    (1254, 48, 2),
    (1251, 30, 2),
    (1259, 1, 1),
    (1255, 2, 1)
]

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\pet_level_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    lvl_content = f.read()

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\pet_rank_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    rank_content = f.read()

print("Checking pets...")
for pid, lv, rk in pets:
    print(f"\n--- Pet {pid} (lv={lv}, rank={rk}) ---")
    # Search for petid and level in lvl_content
    # e.g. petid = 1254, level = 48
    pattern_lvl = rf'petid\s*=\s*{pid}.*?level\s*=\s*{lv}\b.*?(?=petid|$)'
    m_lvl = re.search(pattern_lvl, lvl_content, re.DOTALL)
    if m_lvl:
        for line in m_lvl.group(0).splitlines():
            if "talent_skill" in line or "power" in line:
                print("  Lvl Conf:", line.strip())
    else:
        print("  Lvl match not found")

    pattern_rk = rf'petid\s*=\s*{pid}.*?rank\s*=\s*{rk}\b.*?(?=petid|$)'
    m_rk = re.search(pattern_rk, rank_content, re.DOTALL)
    if m_rk:
        for line in m_rk.group(0).splitlines():
            if "special_skill" in line or "power" in line:
                print("  Rank Conf:", line.strip())
    else:
        print("  Rank match not found")
