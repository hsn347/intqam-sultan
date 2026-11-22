with open("game_file/src/app/module/buff/buffCtrl.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

in_func = False
func_lines = []
for i, line in enumerate(lines):
    if "function buffCtrl:getBuffEffectFromSource" in line:
        in_func = True
    if in_func:
        func_lines.append(f"{i+1}: {line}")
        if line.startswith("end") and len(func_lines) > 5:
            break

print("".join(func_lines[:120]))
