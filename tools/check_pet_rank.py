import re

def check_rank():
    with open('game_file/src/app/localtb/config_server/pet_rank_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
        c = f.read()
    
    m = re.findall(r'special_skill_add.*?\{([^\}]+)\}', c)
    print(f'Total special_skill_add entries: {len(m)}')
    has_18 = []
    for entry in m:
        for power in re.findall(r'"(\d+)"', entry):
            if power.startswith('18'):
                has_18.append(power)
    print('Any special_skill_add with attrType 18:', has_18)

if __name__ == '__main__':
    check_rank()
