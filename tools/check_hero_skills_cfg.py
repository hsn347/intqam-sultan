import os
import re

# Find hero skill config
cfg_path = ""
for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if "hero_skill" in f.lower() and f.endswith(".lua"):
            cfg_path = os.path.join(root, f)
            print("Found:", cfg_path)

skills_to_check = [
    171201, 171202, 171203, 171204,
    171101, 171102, 171103, 171104,
    171701, 171702, 171703, 171704,
    170701, 170702, 170703, 170704,
    170801, 170802, 170803, 170804,
    170001, 170002, 170003, 170004
]

with open(cfg_path, "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for sk in skills_to_check:
    idx = content.find(str(sk))
    if idx != -1:
        snippet = content[idx:idx+300]
        # Look for buffType, powerNum, effect, etc.
        print(f"Skill {sk}:")
        for line in snippet.splitlines()[:10]:
            print("  ", line.strip())
