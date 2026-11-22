import re

with open("game_file/src/app/module/city/buildLogic.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# find all functions in buildLogic that mention army, count, or march
funcs = re.findall(r'function buildLogic\.(.*?)\(.*?\).*?end', text, re.DOTALL)
for fn in funcs:
    if "Army" in fn or "Exp" in fn or "March" in fn or "Troop" in fn:
        lines = fn.split("\n")
        print(f"Function: {lines[0]}")
        for l in lines[1:25]:
            print("  ", l)
        print("-" * 40)
