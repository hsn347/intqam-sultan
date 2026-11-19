import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print(f"Total top-level keys: {len(data)}")
for k in sorted(data.keys()):
    v = data[k]
    if isinstance(v, dict):
        print(f"  {k} (dict, {len(v)} keys)")
    elif isinstance(v, list):
        print(f"  {k} (list, {len(v)} items)")
    else:
        print(f"  {k} ({type(v).__name__}: {v})")
