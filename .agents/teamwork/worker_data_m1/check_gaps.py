from test_parse import parse_lua_build_file
import os
import re

dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]

for fname in sorted(files):
    path = os.path.join(dir_path, fname)
    bid, lvs = parse_lua_build_file(path)
    int_lvs = sorted(int(k) for k in lvs.keys())
    expected_range = list(range(int_lvs[0], int_lvs[-1] + 1))
    if int_lvs != expected_range:
        missing = set(expected_range) - set(int_lvs)
        print(f"BID {bid} has GAPS! Missing: {sorted(missing)}")
    else:
        print(f"BID {bid:3d}: Continuous {int_lvs[0]} -> {int_lvs[-1]} ({len(int_lvs)} levels)")
