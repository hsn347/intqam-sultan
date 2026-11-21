path121 = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\build121.lua"
path_star121 = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\buildstar121.lua"

with open(path121, "r", encoding="utf-8", errors="ignore") as f:
    text121 = f.read()

print("=== build121.lua sample (levels 1..10 and 30..35) ===")
for line in text121.splitlines()[:40]:
    print(line)

with open(path_star121, "r", encoding="utf-8", errors="ignore") as f:
    text_star = f.read()

print("=== buildstar121.lua sample ===")
for line in text_star.splitlines()[:40]:
    print(line)
