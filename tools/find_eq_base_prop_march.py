import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            with open(os.path.join(root, f), "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
                if "MARCH_VALUE_LIMIT_BOOST" in content and "gEquipmentBaseProperty" in content:
                    print(os.path.join(root, f))
                    for line in content.splitlines():
                        if "MARCH_VALUE_LIMIT_BOOST" in line:
                            print("  ", line.strip()[:100])
