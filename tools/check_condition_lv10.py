with open("game_file/src/app/localtb/config_client/tower_lv_privilege.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

entries = text.split(";(nil).index = ")
for e in entries:
    if "kingdomLv = nil, 10" in e:
        import re
        lines = [line.strip() for line in e.split("\n") if "condition" in line]
        print("Conditions for Level 10:")
        for l in lines:
            print(" ", l)
