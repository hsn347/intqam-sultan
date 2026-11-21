import re

print("Searching dump.cs for March / Drill / Capacity / ExpArmy...")
with open(r"E:\intqam-sultan\game_file\il2cpp_dump\dump.cs", "r", encoding="utf-8", errors="ignore") as f:
    for i, line in enumerate(f):
        if any(k in line.lower() for k in ["exparmy", "drillgrounds", "marchcapacity", "maxmarch", "dispatchsoldier"]):
            print(f"{i+1}: {line.strip()[:140]}")
