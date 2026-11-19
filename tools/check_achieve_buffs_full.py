with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\achievement_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

import re
done_ids = [
    5301011, 5302009, 5303018, 5304004, 5305017, 5306002, 5307006, 5308007,
    5309004, 5310006, 5311001, 5312002, 5313006, 5314003, 5315003, 5316002,
    5317003, 5318005, 5319001, 5320005, 5321004, 5322002, 5323006, 5324005
]

print("Checking achievement buffs...")
for did in done_ids:
    m = re.search(rf'id\s*=\s*{did}.*?(?=id\s*=\s*\d+|$)', content, re.DOTALL)
    if m:
        block = m.group(0)
        # find property
        props = re.findall(r'property\s*=\s*\{([^}]+)\}', block)
        if not props:
            props = re.findall(r'property\s*=\s*(\d+)', block)
        vals = re.findall(r'value\s*=\s*\{([^}]+)\}', block)
        if not vals:
            vals = re.findall(r'value\s*=\s*(\d+)', block)
        buff = re.findall(r'buff\s*=\s*\{([^}]+)\}', block)
        print(f"DoneID {did}: props={props}, vals={vals}, buff={buff}")
        for l in block.splitlines():
            if any(t in l.lower() for t in ["buff", "property", "value", "power"]):
                print("  ", l.strip()[:100])
