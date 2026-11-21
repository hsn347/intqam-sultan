import re

def parse_pet_configs():
    with open('game_file/src/app/localtb/config_server/pet_level_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
        level_text = f.read()

    with open('game_file/src/app/localtb/config_server/pet_rank_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
        rank_text = f.read()

    pets = [
        {'id': 1251, 'lv': 30, 'rank': 2},
        {'id': 1257, 'lv': 26, 'rank': 1},
        {'id': 1253, 'lv': 30, 'rank': 2},
    ]

    for p in pets:
        pid = p['id']
        lv = p['lv']
        rank = p['rank']
        print(f"\n=== Pet {pid} (Lv {lv}, Rank {rank}) ===")
        
        # Search level config for this pet and lv
        # pattern: petid = pid ... lv = lv
        # In lua: ;(xxx).petid = pid ... ;(xxx).lv = lv ... talent_skill
        pos = 0
        found_lv = False
        while True:
            pos = level_text.find(str(pid), pos)
            if pos == -1:
                break
            snippet = level_text[pos-50:pos+400]
            if f'lv = {lv}' in snippet or f'lv, ({lv})' in snippet or f'lv = {lv}\n' in snippet:
                print(f"Level snippet: {snippet[:200]}")
                # extract talent_skill
                talents = re.findall(r'talent_skill.*?=\s*\d+,\s*(\d+)', snippet)
                print(f"Talents: {talents}")
                for t in talents:
                    atype = int(t[:2])
                    val = int(t[4:])
                    print(f"  talent: attrType={atype}, val={val}")
                found_lv = True
                break
            pos += len(str(pid))

        # Search rank config for this pet and rank
        pos = 0
        while True:
            pos = rank_text.find(str(pid), pos)
            if pos == -1:
                break
            snippet = rank_text[pos-50:pos+400]
            if f'rank = {rank}' in snippet or f'rank, ({rank})' in snippet:
                print(f"Rank snippet: {snippet[:200]}")
                skills = re.findall(r'special_skill_add.*?=\s*nil,\s*nil,\s*(\d+)', snippet)
                print(f"Rank skills: {skills}")
                for s in skills:
                    atype = int(s[:2])
                    val = int(s[4:])
                    print(f"  rank skill: attrType={atype}, val={val}")
                break
            pos += len(str(pid))

if __name__ == '__main__':
    parse_pet_configs()
