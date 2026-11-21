import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

def check_files():
    patterns = [
        r'\battrID\s*=\s*3\b',
        r'\battrType\s*=\s*5\b',
        r'attributeSystem(?:\.add|\.query|\.get)\w*\([^\)]*\b5\b',
        r'attributeSystem(?:\.add|\.query|\.get)\w*\([^\)]*\b3\b'
    ]
    
    matches = []
    for root, dirs, files in os.walk(BASE_DIR):
        for f in files:
            if not f.endswith('.lua'):
                continue
            path = os.path.join(root, f)
            try:
                with open(path, 'r', encoding='utf-8', errors='ignore') as fp:
                    content = fp.read()
            except Exception:
                continue
            
            for p in patterns:
                found = re.findall(p, content)
                if found:
                    rel = os.path.relpath(path, BASE_DIR)
                    matches.append((rel, p, len(found)))
    
    print(f"Total matching files for Attribute 5 / attrID 3: {len(matches)}")
    for rel, pat, cnt in matches:
        print(f"  {rel} | pattern: {pat} | count: {cnt}")

check_files()
