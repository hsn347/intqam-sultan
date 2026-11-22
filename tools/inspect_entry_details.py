with open("game_file/src/app/localtb/config_client/tower_lv_privilege.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

entries = text.split(";(nil).index = ")
for e in entries:
    if "kingdomLv" in e and "season" in e:
        import re
        m_lv = re.search(r"kingdomLv\s*=\s*(?:nil,\s*)?(\d+)", e)
        m_type = re.search(r"type\s*=\s*(?:nil,\s*)?(?:nil,\s*)?(\d+)", e)
        m_season = re.search(r"season\s*=\s*(?:nil,\s*)?(\d+)", e)
        if m_lv and m_type and m_season and m_season.group(1) == "1" and m_type.group(1) == "1":
            lv = int(m_lv.group(1))
            if lv in (4, 5, 10, 31, 32, 62, 63):
                print(f"=== FULL ENTRY FOR LV {lv} ===")
                print(e[:500])
