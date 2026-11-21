import json

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

# Search for any value 365 or 370 or runes or beasts
def search_dict(d, path=""):
    if isinstance(d, dict):
        for k, v in d.items():
            search_dict(v, f"{path}.{k}")
    elif isinstance(d, list):
        for i, v in enumerate(d):
            search_dict(v, f"{path}[{i}]")
    else:
        if d in [365, 370, 138370, 137000]:
            print(f"Found {d} at {path}")

search_dict(d2)
