import re

with open(r"E:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# find all entries with buffType = 43
# Let's find blocks
matches = re.findall(r'technologyID\s*=\s*(\d+).*?technologyLevel\s*=\s*\d+,\s*(\d+).*?buffType\s*=\s*43\b.*?powerNum\s*=\s*(\d+)', text, re.DOTALL)
print(f"Total matching (techID, level, powerNum): {len(matches)}")

tech_powers = {}
for tech_id, lv, pwr in matches:
    t_id = tech_id[:-2] if len(tech_id) > 2 else tech_id
    if t_id not in tech_powers:
        tech_powers[t_id] = []
    tech_powers[t_id].append((int(lv), int(pwr)))

for t_id, levels in sorted(tech_powers.items()):
    print(f"Tech {t_id}: levels {levels}")
