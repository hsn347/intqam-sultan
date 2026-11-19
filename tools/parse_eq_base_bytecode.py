from parse_lua53_proto import parse_lua53

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "rb") as f:
    data = f.read()

main_proto = parse_lua53(data)
print("Parsed successfully!")
print(f"Num protos: {len(main_proto['protos'])}")
print(f"Num consts in main: {len(main_proto['consts'])}")
print("Sample consts:", main_proto['consts'][:50])
