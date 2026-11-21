import re

with open("game_file/src/app/localtb/config_server/build121.lua", "r", encoding="utf-8") as f:
    text = f.read()

matches = re.findall(r"\(nil\)\[(\d+)\].*?capacity\s*=\s*.*?(\d+)", text)
for lv, cap in matches:
    print(f"Level {lv}: {int(cap):,}")
