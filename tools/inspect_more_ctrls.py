import os
import sys

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_ctrls():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    for k in init_data:
        if any(w in k.lower() for w in ["pavilion", "atlantis", "lamp", "beast", "horn", "order", "guard", "miraculous", "cenotaph", "appoint"]):
            print(f"Key {k}: {init_data[k]}")

if __name__ == "__main__":
    inspect_ctrls()
