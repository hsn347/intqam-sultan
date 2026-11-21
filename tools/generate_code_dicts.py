import json
import re

def generate():
    # 1. Pets
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

    print("PET_MARCH_FLAT_BUFFS: Dict[int, Dict[int, int]] = {")
    for pid in sorted(pet_march.keys()):
        lvs = pet_march[pid]
        items_str = ", ".join(f"{k}: {v}" for k, v in sorted(lvs.items()))
        print(f"    {pid}: {{{items_str}}},")
    print("}")

    # 2. Castle Skins (Dress)
    with open('game_file/src/app/localtb/config_server/dress_type_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        c = f.read()

    blocks = c.split('.subType = ')
    subtype_own = {}
    subtype_use = {}
    for b in blocks[1:]:
        sub_str = b.split('\n')[0].strip()
        if not sub_str.isdigit():
            continue
        subtype = int(sub_str)
        own_pos = b.find('.ownAttribute')
        if own_pos != -1:
            own_sec = b[own_pos:own_pos+800]
            pairs = re.findall(r'ownAttribute.*?=\s*(?:nil,\s*)*(\d+)', own_sec)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        subtype_own[subtype] = nums[i+1]
        use_pos = b.find('.useAttribute')
        if use_pos != -1:
            use_sec = b[use_pos:use_pos+800]
            pairs = re.findall(r'useAttribute.*?=\s*(?:nil,\s*)*(\d+)', use_sec)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        subtype_use[subtype] = nums[i+1]

    with open('game_file/src/app/localtb/config_server/dress_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        dc = f.read()

    d_blocks = dc.split('.dressID = ')
    dress_to_sub = {}
    for db_item in d_blocks[1:]:
        did_str = db_item.split('\n')[0].strip()
        if not did_str.isdigit():
            continue
        did = int(did_str)
        m_sub = re.search(r'\.subType\s*=\s*(?:nil,\s*)*(\d+)', db_item)
        if m_sub:
            dress_to_sub[did] = int(m_sub.group(1))

    dress_own = {did: subtype_own[st] for did, st in dress_to_sub.items() if st in subtype_own}
    dress_use = {did: subtype_use[st] for did, st in dress_to_sub.items() if st in subtype_use}

    print("\nCASTLE_DRESS_MARCH_OWN_BUFFS: Dict[int, int] = {")
    items_own = [f"{k}: {v}" for k, v in sorted(dress_own.items())]
    for i in range(0, len(items_own), 6):
        print("    " + ", ".join(items_own[i:i+6]) + ",")
    print("}")

    print("\nCASTLE_DRESS_MARCH_USE_BUFFS: Dict[int, int] = {")
    items_use = [f"{k}: {v}" for k, v in sorted(dress_use.items())]
    for i in range(0, len(items_use), 6):
        print("    " + ", ".join(items_use[i:i+6]) + ",")
    print("}")

if __name__ == '__main__':
    generate()
