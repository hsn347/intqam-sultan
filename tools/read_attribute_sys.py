with open(r"E:\intqam-sultan\game_file\src\app\module\newBuff\attributeDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    print("=== attributeDef.lua ===")
    print(f.read())

with open(r"E:\intqam-sultan\game_file\src\app\module\newBuff\attributeSystem.lua", "r", encoding="utf-8", errors="ignore") as f:
    print("\n=== attributeSystem.lua (head 100 lines) ===")
    lines = f.readlines()
    print("".join(lines[:100]))
