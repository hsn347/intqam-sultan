with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\talent_skill_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for sk in ["13002", "11001", "13001"]:
    idx = content.find(sk)
    if idx != -1:
        print(f"--- Skill {sk} ---")
        print(content[idx-20:idx+200])
