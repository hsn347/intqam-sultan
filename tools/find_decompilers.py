import os

for root, dirs, files in os.walk(r"e:\intqam-sultan"):
    for f in files:
        if any(term in f.lower() for term in ["unluac", "decompile", "luadec", "lua"]):
            if f.endswith((".jar", ".exe", ".py")):
                print(os.path.join(root, f))
