import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            with open(os.path.join(root, f), "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
                if "301" in content and "BUILDID" in content:
                    for line in content.splitlines():
                        if "301" in line and "BUILDID" in line:
                            print(line.strip())
                            break
