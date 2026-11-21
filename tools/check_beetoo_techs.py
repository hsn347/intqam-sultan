import os
import sys

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def check_beetoo_techs():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    techs = init_data.get("technologyCtrl", {})
    print(f"Total researched technologies in beetoo1: {len(techs)}")
    
    target_techs = [
        "24016", "24032", "24048", "110027", "25030",
        "170012", "170013", "170054", "170055", "170092",
        "170104", "170140", "170148", "304071", "404071", "414071"
    ]
    
    for tid in target_techs:
        if tid in techs:
            print(f"Tech {tid} is researched: {techs[tid]}")
            
    print("\nAll techs in beetoo1:")
    for k, v in sorted(techs.items()):
        print(f"  {k}: {v}")

if __name__ == "__main__":
    check_beetoo_techs()
