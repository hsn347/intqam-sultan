with open(r"E:\intqam-sultan\game_file\src\app\module\city\buildLogic.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()
    for idx, line in enumerate(lines[1855:1930], 1856):
        print(f"{idx}: {line}", end="")
