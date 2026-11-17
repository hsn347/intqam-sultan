with open('tools/plistconfig_dump.bin', 'rb') as f:
    data = f.read()

for target in [b'zhucheng.png', b'icon_map_mycastle.png', b'icon_cbzb_castle.png']:
    idx = data.find(target)
    print(f"Target: {target.decode()}, idx={idx}")
    if idx != -1:
        print("  Snippet:", data[max(0, idx-60):idx+80])
