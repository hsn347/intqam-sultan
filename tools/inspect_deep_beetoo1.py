import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_deep():
    acc_name, init_data = load_account_init_data("beetoo1", offline=True)
    
    # 1. VIP
    vip_data = init_data.get("lordInfoCtrl", {}).get("vip", {})
    print("=== VIP DATA ===")
    print(vip_data)
    
    # 2. Lord Skills
    print("\n=== LORD SKILLS ===")
    lord_skill_ctrl = init_data.get("lordSkillCtrl", {})
    active_set_id = lord_skill_ctrl.get("activeSetID", "1")
    active_set = lord_skill_ctrl.get("setListData", {}).get(active_set_id, {})
    skill_list = active_set.get("list", {})
    print(f"Active Set ID: {active_set_id}")
    print(f"Skills: {skill_list}")
    
    # 3. Equipment
    print("\n=== EQUIPMENT ===")
    equip_ctrl = init_data.get("equipmentCtrl", {})
    print(json.dumps(equip_ctrl, ensure_ascii=False, indent=2))
    
    # 4. Buff 5130
    print("\n=== BUFF 5130 ===")
    buff_ctrl = init_data.get("buffCtrl", [])
    print(buff_ctrl)
    
    # 5. Dress
    print("\n=== DRESS ===")
    dress_ctrl = init_data.get("dressCtrl", {})
    print(dress_ctrl)
    
    # 6. Pet
    print("\n=== PET ===")
    pet_ctrl = init_data.get("petCtrl", {})
    print(json.dumps(pet_ctrl, ensure_ascii=False, indent=2))
    
    # 7. War Gem
    print("\n=== WAR GEM ===")
    wargem_ctrl = init_data.get("warGemCtrl", {})
    print(json.dumps(wargem_ctrl, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    inspect_deep()
