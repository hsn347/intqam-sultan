with open(r"e:\intqam-sultan\tasks\base_task.py", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(6025, min(len(lines), 6140)):
    print(f"{i+1}: {lines[i]}", end="")
