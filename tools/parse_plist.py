import struct

with open('scratch/questIcon_0.plist.raw', 'rb') as f:
    data = f.read()

# Let's find all occurrences of .png filenames
import re
matches = list(re.finditer(rb'([a-zA-Z0-9_]+\.png)', data))
print(f'Total png files found: {len(matches)}')

for i, m in enumerate(matches):
    name = m.group(1).decode('ascii')
    start = m.end()
    # next match or +100 bytes
    end = matches[i+1].start() if i+1 < len(matches) else start + 100
    sub = data[start:end]
    
    # Extract all 06 followed by 4 bytes (int)
    # and all 0f or similar floats
    ints = []
    pos = 0
    while pos < len(sub) - 5:
        if sub[pos] == 0x06:
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        elif sub[pos] == 0x07: # maybe float?
            val = struct.unpack('<f', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        else:
            pos += 1
            
    if '121' in name or i < 5:
        print(f'{name}: ints/vals = {ints}')
