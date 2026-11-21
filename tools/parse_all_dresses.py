import re
import json

def parse_all_dresses():
    with open('game_file/src/app/localtb/config_server/dress_type_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()

    dress_own_attr5 = {}
    dress_use_attr5 = {}
    
    current_subtype = None
    
    for line in lines:
        m_sub = re.search(r'\.subType\s*=\s*(\d+)', line)
        if m_sub:
            current_subtype = int(m_sub.group(1))

        if 'ownAttribute' in line and current_subtype:
            # check if line has 5
            # In lua: ;(nil).ownAttribute, (nil)[5] = nil, 5
            # ;(nil).ownAttribute, (nil)[6] = nil, 300
            pass

    # Better: split by entry
    with open('game_file/src/app/localtb/config_server/dress_type_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    blocks = content.split('.subType = ')
    print(f"Total blocks in dress_type_config: {len(blocks)}")
    
    own_5_map = {}
    use_5_map = {}
    
    for b in blocks[1:]:
        sub_str = b.split('\n')[0].strip()
        if not sub_str.isdigit():
            continue
        subtype = int(sub_str)
        
        # Check ownAttribute
        own_pos = b.find('.ownAttribute')
        if own_pos != -1:
            own_section = b[own_pos:own_pos+800]
            # search for pair where attrID is 5
            # pattern: ownAttribute.*?=\s*(?:nil,\s*)*5\b.*?ownAttribute.*?=\s*(?:nil,\s*)*(\d+)
            # Let's extract all numbers assigned to ownAttribute
            pairs = re.findall(r'ownAttribute.*?=\s*(?:nil,\s*)*(\d+)', own_section)
            if len(pairs) >= 2:
                # pairs is [id1, val1, id2, val2, ...]
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        own_5_map[subtype] = nums[i+1]

        # Check useAttribute
        use_pos = b.find('.useAttribute')
        if use_pos != -1:
            use_section = b[use_pos:use_pos+800]
            pairs = re.findall(r'useAttribute.*?=\s*(?:nil,\s*)*(\d+)', use_section)
            if len(pairs) >= 2:
                nums = [int(x) for x in pairs]
                for i in range(0, len(nums)-1, 2):
                    if nums[i] == 5:
                        use_5_map[subtype] = nums[i+1]

    print(f"Subtypes with ownAttribute 5: {len(own_5_map)}")
    print(f"Subtypes with useAttribute 5: {len(use_5_map)}")
    print("Sample own_5_map:", list(own_5_map.items())[:5])
    print("Sample use_5_map:", list(use_5_map.items())[:5])

if __name__ == '__main__':
    parse_all_dresses()
