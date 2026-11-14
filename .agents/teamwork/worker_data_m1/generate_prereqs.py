import os
import re
import json
import sys

def parse_lua_build_file(filepath: str):
    """
    Parses a single decompiled Lua building configuration file (e.g., build101.lua)
    and returns (bid, levels_dict).
    Handles decompiled Lua quirks:
      1. Register reuse in index markers: ;(nil).index = N or ;(13700).index = N
      2. Multi-variable assignment: _UPVALUE2_, (nil).blv = 420000, 29 (takes last token)
      3. Index shifting in preCond, costRes, costWEs, costTools:
         e.g., _UPVALUE8_, (nil).preCond, (34)[1] = 34, 34, 101
    """
    m_bid = re.search(r'build(\d+)', os.path.basename(filepath))
    if not m_bid:
        raise ValueError(f"Could not extract building ID from filename: {filepath}")
    bid = int(m_bid.group(1))

    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    # Split into level blocks by .index = <num>
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

        # Extract costTime (last comma-separated token)
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


def generate_all_prereqs(config_dir: str, output_file: str):
    """
    Parses all 30 building files in config_dir and writes sorted JSON to output_file.
    """
    files = [f for f in os.listdir(config_dir) if re.match(r'^build\d+\.lua$', f)]
    files.sort(key=lambda x: int(re.search(r'\d+', x).group(0)))

    print(f"[*] Found {len(files)} building files in {config_dir}")

    full_data = {}
    total_levels = 0

    for fname in files:
        fpath = os.path.join(config_dir, fname)
        bid, levels_dict = parse_lua_build_file(fpath)
        
        # Sort levels numerically
        sorted_levels = {}
        for lv in sorted(levels_dict.keys(), key=lambda x: int(x)):
            sorted_levels[lv] = levels_dict[lv]

        bid_str = str(bid)
        full_data[bid_str] = sorted_levels
        count = len(sorted_levels)
        total_levels += count
        min_lv = min(int(k) for k in sorted_levels.keys()) if count else 0
        max_lv = max(int(k) for k in sorted_levels.keys()) if count else 0
        print(f"  [+] BID {bid_str:>3s} ({fname:<13s}): {count:>3d} levels (range {min_lv}-{max_lv})")

    print(f"[*] Total Buildings: {len(full_data)}")
    print(f"[*] Total Levels: {total_levels}")

    # Ensure output directory exists
    os.makedirs(os.path.dirname(os.path.abspath(output_file)), exist_ok=True)

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(full_data, f, indent=2, ensure_ascii=False)

    file_size = os.path.getsize(output_file)
    print(f"[SUCCESS] Wrote pristine prereqs to {output_file} ({file_size} bytes)")
    return full_data


if __name__ == "__main__":
    workspace_root = r"e:\intqam-sultan"
    config_dir = os.path.join(workspace_root, "game_file", "src", "app", "localtb", "config_server")
    output_file = os.path.join(workspace_root, "core", "buildings_prereqs.json")

    generate_all_prereqs(config_dir, output_file)
