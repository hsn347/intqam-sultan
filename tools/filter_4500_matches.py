import os
import re

cfg_server_dir = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"

for fname in os.listdir(cfg_server_dir):
    if fname.endswith(".lua"):
        fpath = os.path.join(cfg_server_dir, fname)
        try:
            with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
            if re.search(r'\b4500\b', content):
                # Search for 4500 near words like march, troop, buff, army, capacity
                matches = re.findall(r'(?:[^\n]+\n){0,3}[^\n]*\b4500\b[^\n]*(?:\n[^\n]+){0,3}', content)
                for m in matches:
                    if any(t in m.lower() for t in ["capacity", "buff", "march", "troop", "army", "dispatch", "limit"]):
                        print(f"=== {fname} ===")
                        print(m.strip()[:300])
                        print("-" * 40)
        except Exception:
            pass
