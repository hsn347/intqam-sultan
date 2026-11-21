import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def search_in_obj(obj, path=""):
    results = []
    if isinstance(obj, dict):
        for k, v in obj.items():
            results.extend(search_in_obj(v, f"{path}.{k}" if path else str(k)))
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            results.extend(search_in_obj(v, f"{path}[{i}]"))
    else:
        # Check value
        val_str = str(obj)
        if "36500" in val_str or val_str == "36500" or val_str == "49500" or val_str == "137000" or val_str == "138370":
            results.append((path, obj))
    return results

def inspect():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    res = search_in_obj(init_data)
    print(f"Direct value matches in init_data: {len(res)}")
    for p, v in res:
        print(f"  {p} = {v}")

if __name__ == "__main__":
    inspect()
