from test_parse import parse_lua_build_file
import os
import re

dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]

buildings_with_tools = {}
buildings_with_wes = {}

for fname in sorted(files):
    path = os.path.join(dir_path, fname)
    bid, lvs = parse_lua_build_file(path)
    for lv, d in lvs.items():
        if d.get("costTools"):
            buildings_with_tools.setdefault(bid, []).append((lv, d["costTools"]))
        if d.get("costWEs"):
            buildings_with_wes.setdefault(bid, []).append((lv, d["costWEs"]))

print("Buildings with costTools:")
for bid, items in buildings_with_tools.items():
    print(f"  BID {bid}: {len(items)} levels with tools. Sample: Lv {items[0][0]}: {items[0][1]}")

print("\nBuildings with costWEs:")
for bid, items in buildings_with_wes.items():
    print(f"  BID {bid}: {len(items)} levels with WEs. Sample: Lv {items[0][0]}: {items[0][1]}")
