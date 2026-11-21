import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_alliance():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    alli_ctrl = init_data.get("allianceCtrl", {})
    print("=== ALLIANCE CTRL KEYS ===")
    print(list(alli_ctrl.keys()))
    for k, v in alli_ctrl.items():
        if isinstance(v, dict):
            print(f"Key {k} (dict with {len(v)} items):")
            for sub_k in list(v.keys())[:15]:
                print(f"   • {sub_k}")
        elif isinstance(v, list):
            print(f"Key {k} (list with {len(v)} items)")
        else:
            print(f"Key {k}: {v}")

if __name__ == "__main__":
    inspect_alliance()
