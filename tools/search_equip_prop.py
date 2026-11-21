import os

root = r"e:\intqam-sultan\game_file\src"

def search_text(txt):
    print(f"=== Searching for: {txt} ===")
    for dp, _, fns in os.walk(root):
        for f in fns:
            if f.endswith(".lua"):
                p = os.path.join(dp, f)
                with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                    for lno, line in enumerate(fp, 1):
                        if txt in line:
                            print(f"{os.path.relpath(p, root)}:{lno} -> {line.strip()[:100]}")

search_text("MARCH_VALUE_LIMIT_BOOST = 78")
