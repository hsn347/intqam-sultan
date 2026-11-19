import re

def extract_hero_names(file_path):
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    matches = re.findall(r'(hero_name_\w+)\s*\t\s*([^\t\r\n]+)', text)
    res = {}
    for k, v in matches:
        res[k] = v.strip()
    return res

ext_names = extract_hero_names('game_file/localtb/delta_patch_tables/local_arab_ext.lua')
print("ext_names:", len(ext_names))
for k, v in sorted(ext_names.items()):
    if 'hero_name_' in k:
        print(f"  {k}: {v}")
