import os
import re
import json

GAME_DIR = r"e:\intqam-sultan\game_file"

SEARCH_DIRS = [
    os.path.join(GAME_DIR, "src", "app", "localtb", "config_server"),
    os.path.join(GAME_DIR, "src", "app", "localtb", "config_client"),
    os.path.join(GAME_DIR, "src", "app", "localtb", "config_read"),
    os.path.join(GAME_DIR, "localtb", "delta_patch_tables"),
    os.path.join(GAME_DIR, "src", "app", "constdef"),
]

# Patterns to detect 96, 19, 78, 18, 5 in property / buff / effect fields
# We must be careful not to match random numbers like year 1996 or coordinates (x=19, y=96).
BUFF_PATTERNS = [
    # Explicit named
    re.compile(r"MARCH_VALUE_LIMIT_BOOST", re.IGNORECASE),
    re.compile(r"MARCH_LIMIT_BOOST", re.IGNORECASE),
    re.compile(r"DISPATCH_TROOP_COUNT_NUM", re.IGNORECASE),
    
    # buffType = 96 or 19
    re.compile(r"\b(buffType|buff_type|buffID|buff_id|effectType|effect_type|effectId|effect_id|propertyID|prop|propertyType|attrID|attr_id|attrType|attr_type)\s*[=:]\s*(96|19)\b"),
    
    # equipment prop 78
    re.compile(r"\b(propertyType|propertyID|prop|baseProperty|extraProperty)\s*[=:]\s*78\b"),
    
    # pet attribute 18
    re.compile(r"\b(attributeType|attrType|attrID|propertyType)\s*[=:]\s*18\b"),

    # attribute system attrID = 5
    re.compile(r"\b(attrID|attr_id|attrType|attr_type)\s*[=:]\s*5\b"),
]

def scan_tables():
    findings = {}

    for d in SEARCH_DIRS:
        if not os.path.exists(d):
            continue
        for file in os.listdir(d):
            if not file.endswith(".lua"):
                continue
            filepath = os.path.join(d, file)
            # Skip massive technology.lua if needed or scan it carefully
            if file == "technology.lua":
                continue

            try:
                with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                    lines = f.readlines()
            except Exception:
                continue

            matched_lines = []
            for idx, line in enumerate(lines, 1):
                for p in BUFF_PATTERNS:
                    m = p.search(line)
                    if m:
                        matched_lines.append((idx, m.group(0), line.strip()[:140]))
                        break

            if matched_lines:
                rel = os.path.relpath(filepath, GAME_DIR)
                findings[rel] = matched_lines

    print(f"Total matching tables: {len(findings)}\n")
    for path, matches in sorted(findings.items()):
        print(f"=== {path} ({len(matches)} matches) ===")
        for line_no, match_kw, line_text in matches[:8]:
            print(f"  L{line_no} [{match_kw}]: {line_text}")
        if len(matches) > 8:
            print(f"  ... and {len(matches)-8} more matches.")
        print()

if __name__ == "__main__":
    scan_tables()
