with open("game_file/src/app/localtb/config_client/tower_lv_privilege.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

entries = text.split(";(nil).index = ")
for i, e in enumerate(entries):
    if "kingdomLv" in e:
        # find kingdomLv
        import re
        m_lv = re.search(r"kingdomLv\s*=\s*(?:nil,\s*)?(\d+)", e)
        m_type = re.search(r"type\s*=\s*(?:nil,\s*)?(?:nil,\s*)?(\d+)", e)
        if m_lv and m_type and m_type.group(1) == "1":
            print(f"Level {m_lv.group(1)}:")
            lines = [line.strip() for line in e.split("\n") if "buff" in line]
            for l in lines[:10]:
                print(" ", l)
