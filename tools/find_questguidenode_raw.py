import os

matches = []
for root, dirs, files in os.walk('game_file'):
    for f in files:
        if f.endswith('.pyc'): continue
        p = os.path.join(root, f)
        try:
            with open(p, 'rb') as fp:
                data = fp.read()
                if b'Button_npc' in data or b'Sprite_npc' in data:
                    matches.append((p, 'Button_npc/Sprite_npc'))
                if b'questGuideNode' in data and not f.endswith('.lua'):
                    matches.append((p, 'questGuideNode non-lua'))
        except Exception:
            pass

for m in matches:
    print(m)
