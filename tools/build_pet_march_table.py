import json
import re

def build_table():
    with open('game_file/src/app/localtb/config_server/pet_level_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()

    pet_march = {}
    current_pet = None
    current_lv = None

    for line in lines:
        m_pet = re.search(r'\.petid\s*=\s*(\d+)', line)
        if m_pet:
            current_pet = int(m_pet.group(1))

        m_lv = re.search(r'\.lv\s*=\s*(\d+)', line)
        if m_lv:
            current_lv = int(m_lv.group(1))

        if 'talent_skill' in line and current_pet and current_lv:
            m_talent = re.search(r'18(\d{2})(\d{6})', line)
            if m_talent:
                val = int(m_talent.group(2))
                if current_pet not in pet_march:
                    pet_march[current_pet] = {}
                pet_march[current_pet][current_lv] = val

    print(f"Found {len(pet_march)} pets with march buff:")
    for pid, lvs in pet_march.items():
        print(f"Pet {pid}: min_lv={min(lvs.keys())}, max_lv={max(lvs.keys())}, max_val={lvs[max(lvs.keys())]}, levels={len(lvs)}")
        print(f"  sample: lv 30 = {lvs.get(30)}")

    with open('tasks/data/pet_march_buffs.json', 'w', encoding='utf-8') as out:
        json.dump(pet_march, out, indent=2)
    print("Saved to tasks/data/pet_march_buffs.json")

if __name__ == '__main__':
    build_table()
