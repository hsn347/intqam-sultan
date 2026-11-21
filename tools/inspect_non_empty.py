import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_non_empty_ctrls():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    non_empty = {}
    for k, v in init_data.items():
        # if v is dict or list and not empty
        if v:
            if isinstance(v, (dict, list)) and len(v) > 0:
                # size
                size = len(v)
                sample = str(v)[:100]
                non_empty[k] = (type(v).__name__, size, sample)
    
    print(f"Total non-empty controllers: {len(non_empty)}")
    for k, (t, size, sample) in sorted(non_empty.items()):
        print(f"  {k:30s} | {t:6s} | len={size:4d} | {sample}")

if __name__ == "__main__":
    inspect_non_empty_ctrls()
