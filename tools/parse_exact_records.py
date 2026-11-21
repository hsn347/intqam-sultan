import os, re, json

BASE_DIR = r"e:\intqam-sultan\game_file"

# --- 1. Kingdom Level ---
path_kl = os.path.join(BASE_DIR, r"src\app\localtb\config_server\kingdom_lv_config.lua")
with open(path_kl, 'r', encoding='utf-8', errors='ignore') as f:
    lines_kl = f.readlines()

kl_records = []
cur_kl = None
for i, l in enumerate(lines_kl):
    m = re.search(r'kingdomLv\s*=\s*(\d+)', l)
    if m:
        cur_kl = int(m.group(1))
    m2 = re.search(r'\(nil\)\.index\s*=\s*(\d+)', l)
    if m2 and cur_kl is None:
        cur_kl = int(m2.group(1))
    
    # Check for buff pair where type is 96
    # Pattern: [X] = ..., 96 followed by [X+1] = ..., value
    m_buff = re.search(r'buff,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*nil,\s*96\b', l)
    if m_buff:
        idx = int(m_buff.group(1))
        # value is in line i+1
        if i + 1 < len(lines_kl):
            next_l = lines_kl[i+1]
            m_val = re.search(r'buff,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*nil,\s*(\d+)', next_l)
            if m_val and int(m_val.group(1)) == idx + 1:
                val = int(m_val.group(2))
                kl_records.append({
                    "kingdomLevel": cur_kl,
                    "buffType": 96,
                    "march_troops_boost": val
                })

# Deduplicate
seen_kl = set()
unique_kl = []
for r in kl_records:
    if r["kingdomLevel"] not in seen_kl:
        seen_kl.add(r["kingdomLevel"])
        unique_kl.append(r)
unique_kl.sort(key=lambda x: x["kingdomLevel"])
print(f"Parsed Kingdom Levels: {len(unique_kl)}")
for r in unique_kl[:5]:
    print(" ", r)
if len(unique_kl) > 5:
    print("  ... and", unique_kl[-1])

# --- 2. Nebula Tower ---
path_nt = os.path.join(BASE_DIR, r"src\app\localtb\config_client\tower_lv_privilege.lua")
with open(path_nt, 'r', encoding='utf-8', errors='ignore') as f:
    lines_nt = f.readlines()

nt_records = []
cur_idx = None
cur_season = None
cur_kl = None
for i, l in enumerate(lines_nt):
    m_idx = re.search(r'\.index\s*=\s*(\d+)', l)
    if m_idx:
        cur_idx = int(m_idx.group(1))
    m_s = re.search(r'\.season\s*=\s*(\d+)', l)
    if m_s:
        cur_season = int(m_s.group(1))
    m_k = re.search(r'\.kingdomLv\s*=\s*nil,\s*(\d+)', l)
    if m_k:
        cur_kl = int(m_k.group(1))
    
    # Check for buff where [1] = 96, [2] = 2, [3] = val
    if re.search(r'\.buff,\s*\(nil\)\[1\]\s*=\s*nil,\s*nil,\s*96\b', l):
        if i + 2 < len(lines_nt):
            l3 = lines_nt[i+2]
            m_val = re.search(r'\.buff,\s*\(nil\)\[3\]\s*=\s*nil,\s*nil,\s*(\d+)', l3)
            if m_val:
                val = int(m_val.group(1))
                nt_records.append({
                    "privilegeIndex": cur_idx,
                    "season": cur_season,
                    "kingdomLv": cur_kl,
                    "buffType": 96,
                    "march_troops_boost": val
                })

seen_nt = set()
unique_nt = []
for r in nt_records:
    if r["privilegeIndex"] not in seen_nt:
        seen_nt.add(r["privilegeIndex"])
        unique_nt.append(r)
print(f"Parsed Nebula Tower records: {len(unique_nt)}")
for r in unique_nt[:5]:
    print(" ", r)

# --- 3. Hero Biography ---
path_hbio = os.path.join(BASE_DIR, r"src\app\localtb\config_server\hero_biography_skill.lua")
with open(path_hbio, 'r', encoding='utf-8', errors='ignore') as f:
    lines_hbio = f.readlines()

hbio_records = []
cur_gid = None
cur_type = None
cur_skill = None
for i, l in enumerate(lines_hbio):
    m_s = re.search(r'\.skillID\s*=\s*(\d+)', l)
    if m_s:
        cur_skill = int(m_s.group(1))
    m_g = re.search(r'\.GroupID\s*=\s*(\d+)', l)
    if m_g:
        cur_gid = int(m_g.group(1))
    m_t = re.search(r'\.type\s*=\s*(\d+)', l)
    if m_t:
        cur_type = int(m_t.group(1))
    
    # Check for buffType == 96 (exact match, not 496)
    if re.search(r'\.buffType.*?[,=\s]96\b', l) and not re.search(r'496', l):
        # find buffNum
        for j in range(i, min(i+10, len(lines_hbio))):
            m_bn = re.search(r'\.buffNum.*?(\d+)\s*$', lines_hbio[j].strip())
            if m_bn:
                val = int(m_bn.group(1))
                hbio_records.append({
                    "skillID": cur_skill,
                    "groupID": cur_gid,
                    "type": cur_type,
                    "buffType": 96,
                    "march_troops_boost": val
                })
                break

seen_hbio = set()
unique_hbio = []
for r in hbio_records:
    key = (r["groupID"], r["type"], r["march_troops_boost"])
    if key not in seen_hbio:
        seen_hbio.add(key)
        unique_hbio.append(r)
print(f"Parsed Hero Biography records: {len(unique_hbio)}")
for r in unique_hbio:
    print(" ", r)

# --- 4. Hero Mastery ---
path_hm = os.path.join(BASE_DIR, r"src\app\localtb\config_server\hero_masteryskill_config.lua")
with open(path_hm, 'r', encoding='utf-8', errors='ignore') as f:
    lines_hm = f.readlines()

hm_records = []
cur_sid = None
cur_lv = None
for i, l in enumerate(lines_hm):
    m_s = re.search(r'\.skillID\s*=\s*(\d+)', l)
    if m_s:
        cur_sid = int(m_s.group(1))
    m_lv = re.search(r'\.lv\s*=\s*(?:nil,\s*)?(\d+)', l)
    if m_lv:
        cur_lv = int(m_lv.group(1))
    
    # Check for buffType 96
    if re.search(r'\.buffType.*?[,=\s]96\b', l):
        # look for buffValue
        for j in range(i, min(i+8, len(lines_hm))):
            m_bv = re.search(r'\.buffValue.*?([0-9]+)\s*$', lines_hm[j].strip())
            if m_bv:
                val = int(m_bv.group(1))
                hm_records.append({
                    "skillID": cur_sid,
                    "level": cur_lv,
                    "buffType": 96,
                    "march_troops_boost": val
                })
                break

seen_hm = set()
unique_hm = []
for r in hm_records:
    if r["skillID"] not in seen_hm:
        seen_hm.add(r["skillID"])
        unique_hm.append(r)
print(f"Parsed Hero Mastery records: {len(unique_hm)}")
for r in unique_hm:
    print(" ", r)
