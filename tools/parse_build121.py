import re

with open("game_file/src/app/localtb/config_server/build121.lua", "r", encoding="utf-8") as f:
    text = f.read()

# Let's find blv and capacity pairs
# Pattern: (nil).blv = nil, (\d+)... (nil).capacity = ... (\d+)
matches = re.findall(r"blv\s*=\s*[^,]+,\s*(\d+).*?capacity\s*=\s*[^,]+,\s*(\d+)", text, re.DOTALL)
for lv, cap in matches:
    print(f"Level {lv}: capacity = {cap}")
