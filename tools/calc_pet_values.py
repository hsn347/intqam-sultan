import re

# Beetoo2 pets:
# 1254: rank 2, level 48
# 1251: rank 2, level 30
# 1259: rank 1, level 1
# 1255: rank 1, level 2

pets = [
    {"petid": 1254, "rank": 2, "level": 48},
    {"petid": 1251, "rank": 2, "level": 30},
    {"petid": 1259, "rank": 1, "level": 1},
    {"petid": 1255, "rank": 1, "level": 2},
]

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\pet_level_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    level_content = f.read()

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\pet_rank_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    rank_content = f.read()

print("Files loaded!")

# Let's see how pet_level_conf entries look like:
for p in pets:
    pid = p['petid']
    lv = p['level']
    rk = p['rank']
    print(f"\n--- Checking Pet {pid} (Rank {rk}, Level {lv}) ---")
    
    # search level_conf for petid and lv
    # key is usually: [pid_lv] or [pid][lv]
    # Let's search pattern
    pos = level_content.find(f"petid = {pid}")
    # or find in chunks
    print(f"Checking level conf...")
    # Let's regex search: talent_skill around petid == pid and lv == lv
    m = re.findall(rf'petid\s*=\s*{pid}.*?lv\s*=\s*{lv}.*?talent_skill.*?(?=\n\s*(?:_ENV|;|\{{))', level_content, re.DOTALL)
    if not m:
        # maybe lv comes before petid
        m = re.findall(rf'lv\s*=\s*{lv}.*?petid\s*=\s*{pid}.*?talent_skill.*?(?=\n\s*(?:_ENV|;|\{{))', level_content, re.DOTALL)
    print("Level matches found:", len(m))
    for match in m[:2]:
        print("Match snippet:", match[:300])

    # Check rank conf
    print(f"Checking rank conf...")
    mr = re.findall(rf'petid\s*=\s*{pid}.*?rank\s*=\s*{rk}.*?special_skill_add.*?(?=\n\s*(?:_ENV|;|\{{))', rank_content, re.DOTALL)
    if not mr:
        mr = re.findall(rf'rank\s*=\s*{rk}.*?petid\s*=\s*{pid}.*?special_skill_add.*?(?=\n\s*(?:_ENV|;|\{{))', rank_content, re.DOTALL)
    print("Rank matches found:", len(mr))
    for match in mr[:2]:
        print("Rank snippet:", match[:300])
