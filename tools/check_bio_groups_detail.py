with open("game_file/src/app/localtb/config_client/hero_biography_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

entries = text.split(";(nil).GroupID = ")
for e in entries[1:]:
    gid = e.split("\n")[0].strip()
    if gid in ("3", "5", "8"):
        print(f"=== Group {gid} ===")
        print(e[:400])
