import sys, os, json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_km():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    km = init_data.get("kingdomMapCtrl", {})
    print("=== KINGDOM MAP CTRL ===")
    print(json.dumps(km, ensure_ascii=False, indent=2))
    
    # check if any kingdomLevel in lordInfoCtrl
    lic = init_data.get("lordInfoCtrl", {})
    for k, v in lic.items():
        if "kingdom" in k.lower():
            print(f"lordInfoCtrl.{k}: {v}")
            
if __name__ == "__main__":
    inspect_km()
