import re

def parse_ext_lua(filepath):
    kv = {}
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    # Patterns in the delta patch tables:
    # often format: value  key  value  key or key value
    # Let's inspect tokens
    tokens = re.findall(r'([^\t\r\n\x00-\x1f]+)', content)
    # also regex for key-value
    # keys are typically alphanumeric with underscores like divineskill_name_1001, item_name_235601
    pattern = re.compile(r'([\w\.\-]+)\s+([\u0600-\u06FF\w\s%\{\}\:\(\)\.\,\!\-\_\'\"]+?)(?=\s+[\w\.\-]+\s+|$)', re.UNICODE)
    # alternatively: value followed by key
    # In delta tables, Onemt Cocos table compiler writes: string bytes then key
    return content

print("Checking local_arab_ext...")
raw = parse_ext_lua('game_file/localtb/delta_patch_tables/local_arab_ext.lua')
for k in ['divineskill_name_1001', 'divineskill_name_1002', 'divineskill_name_2001', 'divineskill_des_1001', 'divineskill_des_2002']:
    idx = raw.find(k)
    print(k, '->', raw[max(0, idx-80):idx+80].replace('\n', ' '))
