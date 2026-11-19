import json

def find_num(obj, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            find_num(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            find_num(v, f"{path}[{i}]")
    elif isinstance(obj, (int, float)):
        if obj == 4500 or obj == 4500000:
            print(f"Exact match {obj} at {path}")
        elif 4400 <= obj <= 4600:
            print(f"Close match {obj} at {path}")
    elif isinstance(obj, str):
        if obj == "4500":
            print(f"Exact str match 4500 at {path}")

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("Searching for 4500 in beetoo2 init_data...")
find_num(data)
