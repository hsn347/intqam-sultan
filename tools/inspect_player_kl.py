import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_player_kl():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    kl = init_data.get("playerKingdomLevelCtrl", {})
    print("playerKingdomLevelCtrl:")
    print(json.dumps(kl, indent=2))
    
    # Also check any other ctrl with kingdom in name
    for k in init_data:
        if "kingdom" in k.lower():
            print(f"init_data[{k}]: {init_data[k]}")

if __name__ == "__main__":
    inspect_player_kl()
