from test_parse import parse_lua_build_file
import os

dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
_, lvs = parse_lua_build_file(os.path.join(dir_path, "build103.lua"))
print("Lv 1:", lvs.get("1"))
print("Lv 2:", lvs.get("2"))
print("Lv 30:", lvs.get("30"))
print("Lv 31:", lvs.get("31"))
