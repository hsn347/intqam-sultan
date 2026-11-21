with open('game_file/src/app/localtb/config_server/achievement_config.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

current_aid = None
current_mid = None
b14_achieves = []

for i, l in enumerate(lines):
    if 'achievementID' in l and '=' in l:
        parts = l.split('=')
        try:
            current_aid = int(parts[-1].strip())
        except:
            pass
    elif 'medalID' in l and '=' in l:
        parts = l.split('=')
        try:
            current_mid = int(parts[-1].strip().split(',')[-1].strip())
        except:
            pass
    elif 'medalBuff' in l and ', 14' in l and lines[i+1]:
        # next line might have value
        next_l = lines[i+1]
        try:
            val = int(next_l.split(',')[-1].strip())
            b14_achieves.append((current_aid, current_mid, val))
        except:
            pass

print(f"Total buff 14 achievements: {len(b14_achieves)}")
for a in b14_achieves:
    print(a)
