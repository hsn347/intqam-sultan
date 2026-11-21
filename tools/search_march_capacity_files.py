import os
import re
import sys

GAME_DIR = r"e:\intqam-sultan\game_file"

TERMS = [
    "getExpArmyCount",
    "getArenaExpArmyCount",
    "DEFAULT_EXP_ARMY_COUNT",
    "SINGLE_TROOP_STRENGTH",
    "CONQUEST_WAR_SINGLE_TROOP_STRENGTH",
    "PYRAMID_SINGLE_TROOP_STRENGTH",
    "LEGEND_SINGLE_TROOP_STRENGTH",
    "MARCH_LIMIT_BOOST",
    "MARCH_VALUE_LIMIT_BOOST",
    "MASS_MARCH_LIMIT_BOOST",
    "MASS_MARCH_VALUE_LIMIT_BOOST",
    "DISPATCH_TROOP_COUNT_NUM",
    "ASSEMBLY_TROOP_COUNT_NUM",
    "getHerosMarchCapacity",
    "getHallofwarCapacity",
    "armyDivineBeastCount",
    "armRuneCount",
    "heroRare2LevelInfo",
    "DRILL_GROUDS",
    "DRILL_GROUNDS",
    "build121",
    "buildstar121",
    "build111",
    "buildstar111",
    "7219",
]

regex_str = r"(" + "|".join(re.escape(t) for t in TERMS) + r")"
combined_re = re.compile(regex_str, re.IGNORECASE)

def main():
    results = {}
    total_scanned = 0

    # Folders to check
    scan_roots = [
        os.path.join(GAME_DIR, "src"),
        os.path.join(GAME_DIR, "localtb"),
        os.path.join(GAME_DIR, "il2cpp_dump"),
    ]

    for root_dir in scan_roots:
        for root, dirs, files in os.walk(root_dir):
            if "src_bytecode" in root:
                continue
            for file in files:
                # Skip giant json maps
                if file in ["script.json", "il2cpp.h"]:
                    continue
                ext = os.path.splitext(file)[1].lower()
                if ext not in [".lua", ".cs", ".json"]:
                    continue

                filepath = os.path.join(root, file)
                total_scanned += 1
                try:
                    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                        text = f.read()
                except Exception:
                    continue

                found = combined_re.findall(text)
                if found:
                    relpath = os.path.relpath(filepath, GAME_DIR)
                    # Count occurrences of each found keyword (normalize case)
                    counts = {}
                    for item in found:
                        item_lower = item.lower()
                        counts[item_lower] = counts.get(item_lower, 0) + 1
                    results[relpath] = counts

    print(f"Scanned: {total_scanned} files. Found matches in {len(results)} files.\n")
    for path in sorted(results.keys()):
        counts_str = ", ".join(f"{k}:{v}" for k, v in sorted(results[path].items()))
        print(f"FILE: {path} => {counts_str}")

if __name__ == "__main__":
    main()
