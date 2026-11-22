import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Parse all rarity+level -> march_add entries
table = {}  # {rarity: {level: march_add}}
blocks = re.split(r';\(nil\)\.ID\s*=\s*\d+\n', text)
for block in blocks:
    rar_m = re.search(r';\(nil\)\.rarity\s*=\s*(\d+)', block)
    lv_m  = re.search(r';\(nil\)\.level\s*=\s*(\d+)', block)
    ma_m  = re.search(r';\(nil\)\.march_add\s*=\s*(\d+)', block)
    if rar_m and lv_m and ma_m:
        rar = int(rar_m.group(1))
        lv  = int(lv_m.group(1))
        ma  = int(ma_m.group(1))
        table.setdefault(rar, {})[lv] = ma

# Show key levels for verification
for rar in sorted(table.keys()):
    lvs = table[rar]
    max_lv = max(lvs.keys())
    print(f"Rarity {rar}: max_level={max_lv}")
    # Show selected levels
    for lv in [1, 10, 20, 30, 40, 50, 60, 70, 80, 84, 90, 100, 109, 110, 120]:
        if lv in lvs:
            print(f"  Lv{lv}: {lvs[lv]}")

print()
# Check what HERO_RARE_LEVEL_MARCH_ADD in march_capacity.py has for high levels
import sys
sys.path.insert(0, 'e:/intqam-sultan')
import tasks.march_capacity as mc
print("=== Current code table (rarity 4 Lv 60-120) ===")
r4_code = mc.HERO_RARE_LEVEL_MARCH_ADD.get(4, {})
for lv in [60, 70, 80, 84, 90, 100, 109, 110, 120]:
    print(f"  Lv{lv}: {r4_code.get(lv, 'MISSING')}")

print()
print("=== CORRECT values from game file (rarity 4) ===")
for lv in [60, 70, 80, 84, 90, 100, 109, 110, 120]:
    print(f"  Lv{lv}: {table.get(4, {}).get(lv, 'MISSING')}")
