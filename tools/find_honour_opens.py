import os

for root, dirs, files in os.walk(r"E:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            p = os.path.join(root, f)
            try:
                with open(p, "r", encoding="utf-8", errors="ignore") as fl:
                    t = fl.read()
                    if "honourWallView" in t:
                        for i, l in enumerate(t.splitlines()):
                            if "uiManager:show" in l and "honourWallView" in l:
                                print(f"{p}:{i+1} -> {l.strip()}")
            except Exception:
                pass
