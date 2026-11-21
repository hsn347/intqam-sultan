import os

BASE_DIR = r"e:\intqam-sultan\game_file"

keywords = [
    "magic", "weapon", "pavilion", "foreign", "exotic", "intetior", "parliament",
    "alliance", "manor", "cenotaph", "appoint", "chronicle", "resonance"
]

results = {k: [] for k in keywords}

for root, dirs, files in os.walk(BASE_DIR):
    for f in files:
        fl = f.lower()
        if fl.endswith('.lua') or fl.endswith('.json'):
            for k in keywords:
                if k in fl:
                    results[k].append(os.path.join(root, f))

for k, flist in results.items():
    print(f"=== Keyword: {k} (found {len(flist)}) ===")
    for p in flist[:8]:
        rel = os.path.relpath(p, BASE_DIR)
        print(f"  {rel}")
