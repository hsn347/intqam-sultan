import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_nebula_tower():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    nt = init_data.get("nebulaTowerCtrl", {})
    print("nebulaTowerCtrl:")
    print(json.dumps(nt, indent=2))
    
    # check nebulaWarMgrCtrl
    nwm = init_data.get("nebulaWarMgrCtrl", {})
    print("\nnebulaWarMgrCtrl:")
    print(json.dumps(nwm, indent=2))

if __name__ == "__main__":
    inspect_nebula_tower()
