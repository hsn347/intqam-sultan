import os

def print_function(filepath, func_name, max_lines=40):
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return
    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
    for i, line in enumerate(lines):
        if func_name in line:
            print(f"=== {filepath} : {line.strip()} (Line {i+1}) ===")
            for j in range(i, min(i + max_lines, len(lines))):
                print(f"{j+1}: {lines[j]}", end="")
            print("\n" + "="*50)
            break

print_function(r"e:\intqam-sultan\game_file\src\app\module\legendLordWarCtrl\hegemonCtrl.lua", "function hegemonCtrl:getBuff")
print_function(r"e:\intqam-sultan\game_file\src\app\module\legendLordWarCtrl\legendLordCtrl.lua", "function legendLordCtrl:getBuff")
print_function(r"e:\intqam-sultan\game_file\src\app\module\intetior\intetiorCtrl.lua", "function intetiorCtrl:getBuffPlus")
print_function(r"e:\intqam-sultan\game_file\src\app\module\divineBeast\divineBeastCtrl.lua", "function divineBeastCtrl:getDispatchAddCount")
print_function(r"e:\intqam-sultan\game_file\src\app\module\pet\petCtrl.lua", "function petCtrl:getPetAttributeAdd")
