import re

s = open("game_file/src/app/localtb/config_server/skill.lua", encoding="utf-8").read()

# Lucifer has skills:
skills = [11021, 11012, 11033, 11011, 11008, 11002, 11019, 11028, 11001, 11029, 11014, 11026, 11005, 11007, 11039, 11016, 11017, 11036, 11015, 11023, 11013, 11004, 11034, 11003, 11035, 11010]

for sk in skills:
    pattern = rf'skillID\s*=\s*({sk}\d{{2}})[\s\S]*?skillProperty\s*=\s*"([^"]*)"'
    matches = list(re.finditer(pattern, s))
    if matches:
        last = matches[-1]
        print(f"Skill {sk}: id={last.group(1)} prop={last.group(2)}")
