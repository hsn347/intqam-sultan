import os

path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\achievement_medal.lua"
if not os.path.exists(path):
    path = r"E:\intqam-sultan\game_file\src\app\localtb\config_client\achievement_medal.lua"

print("Checking:", path)
if os.path.exists(path):
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()
    print("Found medal file, length:", len(text))
    for line in text.splitlines()[:50]:
        print(line)
else:
    print("File not found, searching for medal config...")
    for root, dirs, files in os.walk(r"E:\intqam-sultan\game_file"):
        for f in files:
            if "medal" in f.lower():
                print(os.path.join(root, f))
