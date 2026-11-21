import os

files_to_check = [
    "game_file/src/app/localtb/config_server/technologyTree.lua",
    "game_file/src/app/localtb/config_server/collegeGroup.lua",
    "game_file/src/app/localtb/config_client/collegeGroup.lua",
    "game_file/src/app/localtb/config_server/technology.lua",
]

for fpath in files_to_check:
    if os.path.exists(fpath):
        print(f"=== {fpath} ===")
        with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
            for i, line in enumerate(f):
                if "25030" in line:
                    print(f"  Line {i+1}: {line.strip()}")
