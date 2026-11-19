with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\skill.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for sk in ["11001", "13001", "13002"]:
    idx = content.find(sk)
    if idx != -1:
        print(f"--- Skill {sk} ---")
        print(content[idx-10:idx+250])
