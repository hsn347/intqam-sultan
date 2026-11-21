import os

for root, dirs, files in os.walk("game_file/src/app/localtb"):
    for file in files:
        if "college" in file.lower():
            path = os.path.join(root, file)
            print("Checking:", path)
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                for i, line in enumerate(f):
                    if "25030" in line:
                        print(f"  {line.strip()}")
