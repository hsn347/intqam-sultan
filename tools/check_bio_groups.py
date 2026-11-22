import re

with open("game_file/src/app/localtb/config_client/hero_biography_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

print("hero_biography_config.lua:")
for line in text.split("\n"):
    if any(k in line for k in ("GroupID", "heroGroupID")):
        print(line.strip())
