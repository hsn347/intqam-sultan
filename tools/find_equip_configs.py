import os
import re

cfg_dir = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]

for fname in os.listdir(cfg_dir):
    if "equipment" in fname and fname.endswith(".lua"):
        fpath = os.path.join(cfg_dir, fname)
        with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
        for eid in eids:
            if str(eid) in content:
                print(f"Found {eid} in {fname}")

