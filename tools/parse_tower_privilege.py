import re

with open("game_file/src/app/localtb/config_client/tower_lv_privilege.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Let's find entries with kingdomLv = 10
# In tower_lv_privilege.lua:
# ;(nil).season = ...
# ;(nil).kingdomLv = ...
# buff = [buffType, effectType, value, ...]
# condition = [101, 1]

# Let's write a parser for tower_lv_privilege.lua
entries = text.split(";(nil).index = ")
print("Total entries:", len(entries))

for e in entries[1:]:
    # find kingdomLv
    m_lv = re.search(r"kingdomLv\s*=\s*(?:nil,\s*)?(\d+)", e)
    m_season = re.search(r"season\s*=\s*(?:nil,\s*)?(\d+)", e)
    m_type = re.search(r"type\s*=\s*(?:nil,\s*)?(?:nil,\s*)?(\d+)", e)
    if m_lv and int(m_lv.group(1)) in (0, 1, 10):
        # find buffs
        buff_matches = re.findall(r"buff,\s*\(nil\)\[(\d+)\]\s*=\s*(?:nil,\s*)*(?:nil,\s*)*(\d+)", e)
        buff_dict = {}
        for idx, val in buff_matches:
            buff_dict[int(idx)] = int(val)
        # also find direct assignments
        print(f"Index entry season={m_season.group(1) if m_season else '?'}, type={m_type.group(1) if m_type else '?'}, lv={m_lv.group(1)}:")
        # let's print all 96 buff occurrences
        for k in sorted(buff_dict.keys()):
            if buff_dict[k] == 96:
                print(f"  Buff at {k}: type={buff_dict.get(k)}, effectType={buff_dict.get(k+1)}, val={buff_dict.get(k+2)}")
