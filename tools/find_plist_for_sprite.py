with open('tools/plistconfig_dump.bin', 'rb') as f:
    data = f.read()

# plistconfig has records: [plist_name, sprite_names...]
# Let's search backward from 18112 for .plist
idx = 18112
import re
plists = [(m.start(), m.group(0).decode('latin1')) for m in re.finditer(rb'[a-zA-Z0-9_\-]+\.plist', data)]
for pidx, pname in plists:
    if pidx < idx:
        last_plist = (pidx, pname)
    else:
        break

print("Found containing plist:", last_plist)
