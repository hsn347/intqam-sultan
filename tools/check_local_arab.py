import json

with open("game_file/localtb/local_arab.json", "r", encoding="utf-8") as f:
    d = json.load(f)

print("common_name_01:", d.get("common_name_01"))
print("common_name_02:", d.get("common_name_02"))
