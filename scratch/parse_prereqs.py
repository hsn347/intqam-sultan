import re
import os
import json
import glob

def parse_decompiled_build(content):
    levels = {}
    blocks = re.split(r';\(nil\)\.index\s*=\s*\d+', content)
    for b in blocks[1:]:
        blv_m = re.search(r'(?:blv\s*=\s*(?:nil,\s*)*|;\(nil\)\.blv\s*=\s*)(\d+)', b)
        if not blv_m:
            continue
        blv = int(blv_m.group(1))
        
        # preCond
        pre_cond = {}
        pre_pairs = re.findall(r'(?:_UPVALUE\d+_,\s*)?\(nil\)\.preCond,\s*\(nil\)\[(\d+)\]\s*=\s*(?:nil,\s*)*(\d+)', b)
        pairs_dict = {int(k): int(v) for k, v in pre_pairs}
        sorted_keys = sorted(pairs_dict.keys())
        for i in range(0, len(sorted_keys), 2):
            if i + 1 < len(sorted_keys):
                k = sorted_keys[i]
                v = sorted_keys[i+1]
                pre_cond[str(pairs_dict[k])] = pairs_dict[v]
                
        # costRes
        cost_res = {}
        res_pairs = re.findall(r';\(nil\)\.costRes,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*(\d+)', b)
        res_dict = {int(k): int(v) for k, v in res_pairs}
        s_keys = sorted(res_dict.keys())
        for i in range(0, len(s_keys), 2):
            if i + 1 < len(s_keys):
                k = s_keys[i]
                v = s_keys[i+1]
                rid = res_dict[k]
                amt = res_dict[v]
                if amt > 0:
                    cost_res[str(rid)] = amt
                    
        # costTime
        time_m = re.search(r';\(nil\)\.costTime\s*=\s*(\d+)', b)
        cost_time = int(time_m.group(1)) if time_m else 0
        
        # costTools
        cost_tools = {}
        tools_pairs = re.findall(r';\(nil\)\.costTools,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*(\d+)', b)
        tools_dict = {int(k): int(v) for k, v in tools_pairs}
        t_keys = sorted(tools_dict.keys())
        for i in range(0, len(t_keys), 2):
            if i + 1 < len(t_keys):
                k = t_keys[i]
                v = t_keys[i+1]
                tid = tools_dict[k]
                amt = tools_dict[v]
                if amt > 0:
                    cost_tools[str(tid)] = amt

        # costWEs
        cost_wes = {}
        wes_pairs = re.findall(r';\(nil\)\.costWEs,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*(\d+)', b)
        wes_dict = {int(k): int(v) for k, v in wes_pairs}
        w_keys = sorted(wes_dict.keys())
        for i in range(0, len(w_keys), 2):
            if i + 1 < len(w_keys):
                k = w_keys[i]
                v = w_keys[i+1]
                wid = wes_dict[k]
                amt = wes_dict[v]
                if amt > 0:
                    cost_wes[str(wid)] = amt

        levels[blv] = {
            'preCond': pre_cond,
            'costRes': cost_res,
            'costTools': cost_tools,
            'costWEs': cost_wes,
            'costTime': cost_time
        }
    return levels

def main():
    src_dir = r'e:\intqam-sultan\game_file\src\app\localtb\config_server'
    output_path = r'e:\intqam-sultan\core\buildings_prereqs.json'
    
    all_buildings = {}
    pattern = os.path.join(src_dir, 'build*.lua')
    for filepath in glob.glob(pattern):
        fname = os.path.basename(filepath)
        # Match build<bid>.lua, skip buildstar or other variants
        m = re.match(r'^build(\d+)\.lua$', fname)
        if not m:
            continue
        bid = m.group(1)
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        b_levels = parse_decompiled_build(content)
        if b_levels:
            all_buildings[bid] = b_levels
            print(f"Parsed bid {bid} ({len(b_levels)} levels)")

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(all_buildings, f, indent=2, ensure_ascii=False)
    print(f"\nGenerated {output_path} with {len(all_buildings)} buildings!")

if __name__ == '__main__':
    main()
