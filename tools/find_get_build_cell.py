import os

for root, dirs, files in os.walk("game_file/src"):
    for file in files:
        if file.endswith("cityCtrl.lua"):
            path = os.path.join(root, file)
            print("Found:", path)
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                lines = f.readlines()
                for i, line in enumerate(lines):
                    if "function cityCtrl:getBuildCell" in line:
                        for j in range(i, min(len(lines), i+30)):
                            print(f"{j+1}: {lines[j]}", end="")
                        break
