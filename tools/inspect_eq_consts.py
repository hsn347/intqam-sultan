from parse_lua53_proto import parse_lua53

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "rb") as f:
    data = f.read()

proto = parse_lua53(data)
consts = proto['consts']

# Let's search for 4500 or eids in consts
print("Checking consts for 4500:")
for i, c in enumerate(consts):
    if c == 4500:
        print(f"  consts[{i}] == 4500")

# Check Beetoo2's eids
eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]
print("Checking for Beetoo2 eids in consts:")
for eid in eids:
    if eid in consts:
        print(f"  Found {eid} at index {consts.index(eid)}")
    else:
        print(f"  NOT found: {eid}")
