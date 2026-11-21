with open("tasks/base_task.py", "r", encoding="utf-8") as f:
    for i, line in enumerate(f):
        if "def get_max_march_capacity" in line or "def calculate_castle_march_capacity" in line:
            print(f"Line {i+1}: {line.strip()}")
