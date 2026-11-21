import re

def check_dress():
    # 1. Parse dress_type_config.lua for ownAttribute / useAttribute == 5
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

        # ownAttribute
        own_pos = b.find('.ownAttribute')
        if own_pos != -1:
            own_sec = b[own_pos:own_pos+800]
            pairs = re.findall(r'ownAttribute.*?=\s*(?:nil,\s*)*(\d+)', own_sec)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        subtype_own[subtype] = nums[i+1]

        # useAttribute
        use_pos = b.find('.useAttribute')
        if use_pos != -1:
            use_sec = b[use_pos:use_pos+800]
            pairs = re.findall(r'useAttribute.*?=\s*(?:nil,\s*)*(\d+)', use_sec)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        subtype_use[subtype] = nums[i+1]

    # 2. Parse dress_config.lua to map dressID -> subType
    with open('game_file/src/app/localtb/config_server/dress_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        dc = f.read()

    d_blocks = dc.split('.dressID = ')
    dress_to_sub = {}
    for db in d_blocks[1:]:
        did_str = db.split('\n')[0].strip()
        if not did_str.isdigit():
            continue
        did = int(did_str)
        m_sub = re.search(r'\.subType\s*=\s*(?:nil,\s*)*(\d+)', db)
        if m_sub:
            dress_to_sub[did] = int(m_sub.group(1))

    # Build dress_own_attr5 and dress_use_attr5
    dress_own = {}
    dress_use = {}
    for did, st in dress_to_sub.items():
        if st in subtype_own:
            dress_own[did] = subtype_own[st]
        if st in subtype_use:
            dress_use[did] = subtype_use[st]

    print(f"Total dressIDs with ownAttribute 5: {len(dress_own)}")
    print(f"Total dressIDs with useAttribute 5: {len(dress_use)}")
    print("Sample own:", list(dress_own.items())[:5])
    print("Sample use:", list(dress_use.items())[:5])

if __name__ == '__main__':
    check_dress()
