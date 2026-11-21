import re

with open(r'game_file\src\app\localtb\config_server\kingdom_lv_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Parse all kingdom levels and their buff for 96
levels = {}
# The file defines entries:
# ;(id).kingdomLv = X
# ...
# .buff, (...)[...] = 96
# .buff, (...)[...] = value
chunks = text.split('.kingdomLv = ')
for c in chunks[1:]:
    klv_str = c.split('\n')[0].strip().split(';')[0]
    klv = int(klv_str)
    # find buff 96
    # Look for: buff, (..)[..] = .. 96 followed by buff, (..)[..] = .. val
    m = re.search(r'\.buff[^\n]+,\s*96\b[^\n]*\n[^\n]*\.buff[^\n]+,\s*(\d+)', c)
    if m:
        levels[klv] = int(m.group(1))

print(f"Total levels with effect 96: {len(levels)}")
print("Key level thresholds:")
for lv in sorted(levels.keys()):
    if lv in [1, 5, 10, 15, 18, 20, 25, 30, 35, 36, 40, 50, 60, 70, 80, 90, 100]:
        print(f"  Kingdom Level {lv:3d}: +{levels[lv]} march capacity")
