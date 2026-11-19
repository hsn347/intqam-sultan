from parse_lua53_proto import parse_lua53

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "rb") as f:
    data = f.read()

parse_lua53(data)
