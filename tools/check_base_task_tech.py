with open("tasks/base_task.py", "r", encoding="utf-8") as f:
    for i, line in enumerate(f):
        if "25030" in line:
            print(f"Line {i+1}: {line.strip()}")
