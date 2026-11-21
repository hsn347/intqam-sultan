import json

p_type = r"E:\intqam-sultan\game_file\src\app\localtb\config_client\medal_type.lua"
p_buff = r"E:\intqam-sultan\game_file\src\app\localtb\config_client\medal_buff_type.lua"

print("=== medal_type.lua ===")
with open(p_type, "r", encoding="utf-8", errors="ignore") as f:
    for line in f:
        if "9003017" in line or "17" in line:
            print(line.strip())

print("\n=== medal_buff_type.lua ===")
with open(p_buff, "r", encoding="utf-8", errors="ignore") as f:
    for line in f:
        if "9003017" in line or "17" in line:
            print(line.strip())
