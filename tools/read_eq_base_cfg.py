with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

eids = ["6304501", "6204501", "6404501", "6604501", "6105001", "6504501"]
print(f"Total lines: {len(lines)}")
for eid in eids:
    found = False
    for i, line in enumerate(lines):
        if f"[{eid}]" in line or f'["{eid}"]' in line:
            print(f"Found {eid} at line {i+1}:")
            for j in range(i, min(len(lines), i+20)):
                print(f"  {lines[j]}", end="")
            found = True
            break
    if not found:
        print(f"NOT found {eid}")
