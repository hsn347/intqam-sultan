with open(r"e:\intqam-sultan\tasks\base_task.py", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "def get_max_march_capacity" in l:
        for j in range(i, min(len(lines), i + 150)):
            print(f"{j+1}: {lines[j]}", end="")
        break
