import struct

path = r'e:\intqam-sultan\game_file\localtb\delta_patch_tables\local_arab_ext.lua'
with open(path, 'rb') as f:
    buf = f.read()

def read_lua_string(buf, pos):
    if pos >= len(buf):
        return None, pos
    tag = buf[pos]
    if tag == 0x04: # short string
        sz = buf[pos+1]
        if sz == 0:
            return '', pos+2
        s = buf[pos+2 : pos+2+sz-1]
        try:
            return s.decode('utf-8'), pos+2+sz-1
        except Exception:
            return None, pos
    elif tag == 0x14: # long string (size_t is 4 bytes)
        if pos + 5 > len(buf):
            return None, pos
        sz = struct.unpack('<I', buf[pos+1 : pos+1+4])[0]
        if sz == 0:
            return '', pos+5
        s = buf[pos+5 : pos+5+sz-1]
        try:
            return s.decode('utf-8'), pos+5+sz-1
        except Exception:
            return None, pos
    return None, pos

strings = []
pos = 30
while pos < len(buf):
    tag = buf[pos]
    if tag in (0x04, 0x14):
        s, new_pos = read_lua_string(buf, pos)
        if s is not None and new_pos > pos:
            strings.append((pos, s))
            pos = new_pos
            continue
    pos += 1

print(f'Total strings parsed: {len(strings)}')
commandhall_map = {}
for i in range(len(strings)):
    pos_i, s = strings[i]
    if s.startswith('commandhall_'):
        if i + 1 < len(strings):
            commandhall_map[s] = strings[i+1][1]

print(f'Total commandhall keys found: {len(commandhall_map)}')
with open(r'e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_1\commandhall_strings_decoded.txt', 'w', encoding='utf-8') as f_out:
    for k in sorted(commandhall_map.keys()):
        f_out.write(f'{k} = {commandhall_map[k]}\n')

print('Saved to commandhall_strings_decoded.txt')
