with open(r"e:\intqam-sultan\tools\parse_lua53_proto.py", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines[30:80]):
    print(f"{i+31}: {l}", end="")
