import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# find skills for hero 1717 (المزيونة) and 1711 (الانيق) and 1700 (امير الصحراء)
for hid in [1711, 1717, 1724, 1733, 1700, 1705]:
    m = re.findall(rf'heroID = {hid}.*?skillID = (\d+).*?buffType = (\d+)', text, re.DOTALL)
    print(f"Hero {hid} skills (first 5 matches): {m[:5]}")
