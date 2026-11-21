import os
import re

src_dir = r"E:\intqam-sultan\game_file\src"

patterns = [
    r"function.*[Mm]ax.*[Mm]arch",
    r"function.*[Mm]arch.*[Mm]ax",
    r"function.*[Mm]ax.*[Tt]roop",
    r"function.*[Tt]roop.*[Mm]ax",
    r"function.*[Mm]ax.*[Aa]rmy",
    r"function.*[Aa]rmy.*[Mm]ax",
    r"function.*[Cc]apacity",
    r"[Gg]et[Mm]ax.*[Ss]oldier",
    r"[Gg]et[Mm]arch.*[Cc]apacity",
    r"[Gg]et[Tt]roop.*[Cc]apacity",
    r"[Gg]et[Aa]rmy.*[Cc]apacity",
    r"[Gg]et.*[Mm]ax.*[Aa]rmy",
    r"[Gg]et.*[Mm]ax.*[Tt]roop"
]

compiled = [re.compile(p) for p in patterns]

print("Scanning src directory for march capacity functions...")
found = []
for root, dirs, files in os.walk(src_dir):
    for f in files:
        if f.endswith(".lua"):
            path = os.path.join(root, f)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as fl:
                    for i, line in enumerate(fl):
                        for cp in compiled:
                            if cp.search(line):
                                found.append((path, i+1, line.strip()))
                                break
            except Exception:
                pass

print(f"Total matches found: {len(found)}")
for path, line_no, text in found[:50]:
    rel_path = os.path.relpath(path, src_dir)
    print(f"{rel_path}:{line_no} -> {text}")
