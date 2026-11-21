import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

print("All keys in beetoo1 init_data:")
for k, v in d1.items():
    if isinstance(v, dict):
        print(f"  {k} (dict with {len(v)} keys: {list(v.keys())[:10]})")
    elif isinstance(v, list):
        print(f"  {k} (list with {len(v)} items)")
    else:
        print(f"  {k}: {v}")
