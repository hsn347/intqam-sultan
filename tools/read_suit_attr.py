with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\suit_attribute.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for l in content.splitlines():
    if any(term in l.lower() for term in ["4500", "march", "capacity", "limit", "troop", "78"]):
        print(" ", l.strip()[:100])
