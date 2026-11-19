import json

def find_key(obj, term, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if term in k.lower():
                print(f"Match key '{k}' at {path}: {str(v)[:100]}")
            find_key(v, term, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            find_key(v, term, f"{path}[{i}]")

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

find_key(data, "vip")
