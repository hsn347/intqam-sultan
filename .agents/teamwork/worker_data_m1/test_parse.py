import os
import re
import json

def parse_lua_build_file(filepath: str):
    bid = int(re.search(r'build(\d+)', os.path.basename(filepath)).group(1))
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    pattern = r';(?:\([^\)]*\))?\.index\s*=\s*(\d+)'
    splits = list(re.finditer(pattern, text))
    levels_data = {}

    for i in range(len(splits)):
        idx = int(splits[i].group(1))
        start_pos = splits[i].start()
        end_pos = splits[i+1].start() if i + 1 < len(splits) else len(text)
        block = text[start_pos:end_pos]

        # Extract blv (last comma-separated token)
        m_blv = re.search(r'\.blv\s*=\s*([^\n;]+)', block)
        if m_blv:
            tokens = [t.strip() for t in m_blv.group(1).split(',')]
            try:
                blv = int(tokens[-1])
            except ValueError:
                blv = idx
        else:
            blv = idx

        # Extract costTime
        m_time = re.search(r'\.costTime\s*=\s*([^\n;]+)', block)
        cost_time = 0
        if m_time:
            tokens = [t.strip() for t in m_time.group(1).split(',')]
            try:
                cost_time = int(tokens[-1])
            except ValueError:
                cost_time = 0

        # Extract preCond pairs [1]=bid, [2]=lv
        pre_cond = {}
        pre_pairs = {}
        for line in block.splitlines():
            if '.preCond' in line:
                m_idx = re.search(r'\.preCond(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        pre_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in pre_pairs and (k+1) in pre_pairs:
                pre_cond[str(pre_pairs[k])] = pre_pairs[k+1]

        # Extract costRes pairs [1]=res_id, [2]=amt
        cost_res = {}
        res_pairs = {}
        for line in block.splitlines():
            if '.costRes' in line:
                m_idx = re.search(r'\.costRes(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        res_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in res_pairs and (k+1) in res_pairs:
                res_id = str(res_pairs[k])
                res_amt = res_pairs[k+1]
                if res_amt > 0:
                    cost_res[res_id] = res_amt

        # Extract costWEs pairs [1]=item_id, [2]=count
        cost_wes = {}
        wes_pairs = {}
        for line in block.splitlines():
            if '.costWEs' in line:
                m_idx = re.search(r'\.costWEs(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        wes_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in wes_pairs and (k+1) in wes_pairs:
                cost_wes[str(wes_pairs[k])] = wes_pairs[k+1]

        # Extract costTools pairs [1]=tool_id, [2]=count
        cost_tools = {}
        tools_pairs = {}
        for line in block.splitlines():
            if '.costTools' in line:
                m_idx = re.search(r'\.costTools(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        tools_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in tools_pairs and (k+1) in tools_pairs:
                cost_tools[str(tools_pairs[k])] = tools_pairs[k+1]

        levels_data[str(blv)] = {
            "preCond": pre_cond,
            "costRes": cost_res,
            "costTools": cost_tools,
            "costWEs": cost_wes,
            "costTime": cost_time
        }
    return bid, levels_data

if __name__ == "__main__":
    dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
    files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]
    print(f"Found {len(files)} build*.lua files")
    full_dict = {}
    total_levels = 0
    corrupt_keys = []
    
    for fname in sorted(files):
        path = os.path.join(dir_path, fname)
        bid, lvs = parse_lua_build_file(path)
        full_dict[str(bid)] = lvs
        total_levels += len(lvs)
        max_lv = max(int(k) for k in lvs.keys()) if lvs else 0
        min_lv = min(int(k) for k in lvs.keys()) if lvs else 0
        for k in lvs.keys():
            if int(k) > 130 or int(k) < 1:
                corrupt_keys.append((bid, k))
        print(f"BID {bid:3d} ({fname:12s}): {len(lvs):3d} levels (range {min_lv}-{max_lv})")

    print(f"\nTotal buildings: {len(full_dict)}")
    print(f"Total levels parsed: {total_levels}")
    print(f"Corrupt keys: {corrupt_keys}")
    
    json_str = json.dumps(full_dict, indent=2)
    print(f"Formatted JSON size: {len(json_str)} characters ({len(json_str.encode('utf-8'))} bytes)")
    
    # Check Castle lv 31-40
    print("\nCastle (101) Sample check:")
    for lv in ["30", "31", "32", "33", "40", "50", "130"]:
        if lv in full_dict["101"]:
            print(f"  Castle Lv {lv}: preCond={full_dict['101'][lv]['preCond']}, costWEs={full_dict['101'][lv]['costWEs']}, time={full_dict['101'][lv]['costTime']}")
        else:
            print(f"  Castle Lv {lv} NOT FOUND")

    # Check Walls lv 30-50
    print("\nWalls (102) Sample check:")
    for lv in ["30", "34", "35", "36", "40", "50", "130"]:
        if lv in full_dict["102"]:
            print(f"  Walls Lv {lv}: preCond={full_dict['102'][lv]['preCond']}, costWEs={full_dict['102'][lv]['costWEs']}, time={full_dict['102'][lv]['costTime']}")
        else:
            print(f"  Walls Lv {lv} NOT FOUND")

    # Check Embassy lv 28-50
    print("\nEmbassy (111) Sample check:")
    for lv in ["28", "29", "30", "31", "40", "50", "130"]:
        if lv in full_dict["111"]:
            print(f"  Embassy Lv {lv}: preCond={full_dict['111'][lv]['preCond']}, costWEs={full_dict['111'][lv]['costWEs']}, time={full_dict['111'][lv]['costTime']}")
        else:
            print(f"  Embassy Lv {lv} NOT FOUND")
