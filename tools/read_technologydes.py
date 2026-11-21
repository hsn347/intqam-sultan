with open("game_file/src/app/localtb/config_client/technologydes.lua", "r", encoding="utf-8") as f:
    for i, line in enumerate(f):
        if "25030" in line or "2503" in line:
            print(f"Line {i+1}: {line.strip()}")
