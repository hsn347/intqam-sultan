import os
import re
import json

GAME_DIR = r"e:\intqam-sultan\game_file"

def find_file(pattern, base_dir=GAME_DIR):
    regex = re.compile(pattern, re.IGNORECASE)
    matches = []
    for root, dirs, files in os.walk(base_dir):
        if "src_bytecode" in root:
            continue
        for f in files:
            if regex.search(f):
                matches.append(os.path.join(root, f))
    return matches

def scan_system(system_name, file_patterns, keywords):
    print(f"\n{'='*50}\nScanning System: {system_name}\n{'='*50}")
    all_files = []
    for p in file_patterns:
        all_files.extend(find_file(p))
    
    unique_files = sorted(set(all_files))
    print(f"Found {len(unique_files)} files for {system_name}:")
    for f in unique_files:
        rel = os.path.relpath(f, GAME_DIR)
        print(f"  - {rel}")
        
    compiled_kws = [re.compile(re.escape(k), re.IGNORECASE) for k in keywords]
    
    hits = {}
    for f in unique_files:
        try:
            with open(f, 'r', encoding='utf-8', errors='ignore') as fp:
                lines = fp.readlines()
        except Exception:
            continue
        
        file_hits = []
        for line_no, line in enumerate(lines, 1):
            for kw, reg in zip(keywords, compiled_kws):
                if reg.search(line):
                    file_hits.append((line_no, kw, line.strip()))
        if file_hits:
            hits[f] = file_hits

    print(f"\nHits found in {len(hits)} files:")
    for f, h_list in hits.items():
        rel = os.path.relpath(f, GAME_DIR)
        print(f"\n--- {rel} ({len(h_list)} occurrences) ---")
        for line_no, kw, line_text in h_list[:10]:
            print(f"  L{line_no} [{kw}]: {line_text[:120]}")
        if len(h_list) > 10:
            print(f"  ... and {len(h_list)-10} more.")

if __name__ == "__main__":
    # Test scanner on key systems
    keywords_96_19_5 = ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST", "DISPATCH_TROOP_COUNT_NUM", "96", "19", "78", "18"]
    
    scan_system("Equipment", ["equipment.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST", "78"])
    scan_system("Pet", ["pet.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST", "18"])
    scan_system("WarGem", ["wargem.*\\.lua", "warGem.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST"])
    scan_system("NebulaTower", ["nebula.*tower.*\\.lua", "nebulaActivity.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST"])
    scan_system("KingdomLevel", [".*kingdom.*level.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST"])
    scan_system("MilitaryRank", ["military.*rank.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST"])
    scan_system("HeroBiography", [".*hero.*biography.*\\.lua"], ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST"])
    scan_system("Dress_Attribute5", ["dress.*\\.lua"], ["DISPATCH_TROOP_COUNT_NUM", "attrID = 5", "attrId = 5"])
