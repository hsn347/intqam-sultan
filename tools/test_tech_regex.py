import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

# Let's find all technologyType and powerNum
entries = re.findall(r'technologyID\s*=\s*(\d+).*?technologyType\s*=\s*(\d+).*?technologyLevel\s*(?:=\s*nil,\s*|=\s*)(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+).*?buffNumType\s*=\s*(\d+)', content, re.DOTALL)
print(f"Total regex matches: {len(entries)}")
if entries:
    print("Sample match:", entries[0])
