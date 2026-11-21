import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_pet():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    pet_ctrl = init_data.get("petCtrl", {})
    print("=== PET CTRL KEYS ===")
    print(list(pet_ctrl.keys()))
    
    # Check pet list
    pet_list = pet_ctrl.get("petList", {})
    print(f"\nPet list count: {len(pet_list)}")
    for pid, pdata in pet_list.items():
        print(f"Pet ID {pid}:")
        if isinstance(pdata, dict):
            for pk, pv in pdata.items():
                print(f"   {pk}: {pv}")
                
    # Check pet talent data
    pet_talent = pet_ctrl.get("petTalentData", {})
    print(f"\nPet talent count: {len(pet_talent)}")
    print(json.dumps(pet_talent, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    inspect_pet()
