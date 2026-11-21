import re

def parse_kl_100():
    path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\kingdom_lv_config.lua"
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()

    # Split by kingdomLv =
    blocks = re.split(r'kingdomLv\s*=\s*', text)
    print(f"Total blocks: {len(blocks)}")
    
    for b in blocks[1:]:
        klv_m = re.match(r'(\d+)', b)
        if not klv_m:
            continue
        klv = int(klv_m.group(1))
        
        # find in b: [19] = ..., 96 and [20] = ..., val
        # or any pair with 96
        # Let's search all buff lines in block b
        buff_lines = [l.strip() for l in b.splitlines() if "buff" in l]
        # parse indices and values
        buff_items = {}
        for l in buff_lines:
            m = re.search(r'\[(\d+)\]\s*=\s*.*?,?\s*(\d+)$', l)
            if m:
                buff_items[int(m.group(1))] = int(m.group(2))
        
        # find where 96 is
        for idx, val in buff_items.items():
            if val == 96:
                # the next index is the value
                next_val = buff_items.get(idx + 1)
                print(f"Kingdom Level {klv:3d}: Buff 96 value = {next_val}")

if __name__ == "__main__":
    parse_kl_100()
