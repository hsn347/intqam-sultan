import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

# 1. Kingdom Level
path_kl = os.path.join(BASE_DIR, r"src\app\localtb\config_server\kingdom_lv_config.lua")
with open(path_kl, 'r', encoding='utf-8', errors='ignore') as f:
    lines_kl = f.readlines()

print("=== Testing Kingdom Level ===")
kl_hits = []
cur_kl = None
for i, l in enumerate(lines_kl):
    m_kl = re.search(r'kingdomLv\s*=\s*(\d+)', l)
    if m_kl:
        cur_kl = int(m_kl.group(1))
    # look for buff[19] = 96 or similar
    if '96' in l and 'buff' in l:
        # print surrounding
        print(f"Around line {i+1} (cur_kl={cur_kl}):")
        for j in range(max(0, i-2), min(len(lines_kl), i+3)):
            print(f"  {j+1}: {lines_kl[j].strip()}")
        break

# 2. Nebula Tower
path_nt = os.path.join(BASE_DIR, r"src\app\localtb\config_client\tower_lv_privilege.lua")
with open(path_nt, 'r', encoding='utf-8', errors='ignore') as f:
    lines_nt = f.readlines()

print("\n=== Testing Nebula Tower ===")
for i, l in enumerate(lines_nt[:30]):
    print(f"  {i+1}: {l.strip()}")

# 3. Hero Biography
path_hbio = os.path.join(BASE_DIR, r"src\app\localtb\config_server\hero_biography_skill.lua")
with open(path_hbio, 'r', encoding='utf-8', errors='ignore') as f:
    lines_hbio = f.readlines()

print("\n=== Testing Hero Biography ===")
for i, l in enumerate(lines_hbio):
    if 'buffType' in l and '96' in l:
        print(f"Around line {i+1}:")
        for j in range(max(0, i-5), min(len(lines_hbio), i+6)):
            print(f"  {j+1}: {lines_hbio[j].strip()}")
        break

# 4. Hero Mastery
path_hm = os.path.join(BASE_DIR, r"src\app\localtb\config_server\hero_masteryskill_config.lua")
with open(path_hm, 'r', encoding='utf-8', errors='ignore') as f:
    lines_hm = f.readlines()

print("\n=== Testing Hero Mastery ===")
for i, l in enumerate(lines_hm):
    if 'buffType' in l and '96' in l:
        print(f"Around line {i+1}:")
        for j in range(max(0, i-5), min(len(lines_hm), i+6)):
            print(f"  {j+1}: {lines_hm[j].strip()}")
        break
