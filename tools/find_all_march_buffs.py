import os
import re

# Search all config files in game_file for buff 19 and buff 96
config_dir = r"e:\intqam-sultan\game_file\src\app\localtb"

found_19 = []
found_96 = []

for root, dirs, files in os.walk(config_dir):
    for f in files:
        if f.endswith('.lua'):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                content = fp.read()
                # Check for buffType or effectType or buffID with 19 or 96
                # in patterns like: buffType = 19, buff = 19, [19], etc.
                if re.search(r'buff(?:Type|Effect|Id|ID)?\s*=\s*19\b', content) or 'gBuffEffect.MARCH_LIMIT_BOOST' in content:
                    found_19.append(f)
                if re.search(r'buff(?:Type|Effect|Id|ID)?\s*=\s*96\b', content) or 'gBuffEffect.MARCH_VALUE_LIMIT_BOOST' in content:
                    found_96.append(f)

print("Files referencing Buff 19 (MARCH_LIMIT_BOOST):")
print(set(found_19))
print("\nFiles referencing Buff 96 (MARCH_VALUE_LIMIT_BOOST):")
print(set(found_96))
