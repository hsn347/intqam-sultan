with open('game_file/src/app/localtb/config_client/local_arab.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()
import re
m = re.search(r'\["buildDes_name_121"\]\s*=\s*"([^"]+)"', text)
if m:
    print('buildDes_name_121:', m.group(1))

# Also search for "ساحة المعسكر" or "المعسكر" in local_arab
for line in text.splitlines():
    if 'ساحة' in line or 'معسكر' in line:
        if any(k in line for k in ['121', 'ساحة المعسكر', 'ساحة التدريب', 'أرض المعسكر']):
            print(line)
