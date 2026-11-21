with open("game_file/src/app/localtb/config_server/build121.lua", "r", encoding="utf-8") as f:
    for i, line in enumerate(f):
        if "blv" in line or "capacity" in line:
            print(f"{i+1}: {line.strip()}")
        if i > 120:
            break
