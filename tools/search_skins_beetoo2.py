import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

for k, v in data.items():
    if any(t in k.lower() for t in ["skin", "dress", "fashion", "appearance"]):
        print(f"Top key '{k}': {str(v)[:300]}")

# Also search inside all dicts for "dress" or "skin"
def search_skins(obj, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if any(t in k.lower() for t in ["skin", "dress"]):
                print(f"Match '{k}' at {path}: {str(v)[:200]}")
            search_skins(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            search_skins(v, f"{path}[{i}]")

print("\n--- Recursive search for skin/dress ---")
search_skins(data)
