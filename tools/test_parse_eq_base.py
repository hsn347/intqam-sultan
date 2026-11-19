from parse_lua53 import Lua53Reader

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "rb") as f:
    data = f.read()

reader = Lua53Reader(data)
reader.parse_header()
fn = reader.parse_function()
print("Source:", fn.get("source"))
print("Instructions count:", len(fn.get("instructions", [])))
print("Constants count:", len(fn.get("constants", [])))
print("Protos count:", len(fn.get("protos", [])))
print("First 30 constants:", fn.get("constants", [])[:30])
