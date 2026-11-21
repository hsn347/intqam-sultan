import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_equipment():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    eq = init_data.get("equipmentCtrl", {})
    print("equipmentCtrl keys:", list(eq.keys()))
    print(json.dumps(eq, indent=2))

if __name__ == "__main__":
    inspect_equipment()
