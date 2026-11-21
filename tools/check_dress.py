import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

def check_dress_attributes():
    path = os.path.join(BASE_DIR, r"src\app\localtb\config_server\dress_type_config.lua")
    if not os.path.exists(path):
        # try to find dress_type_config.lua
        for root, dirs, files in os.walk(BASE_DIR):
            if "dress_type_config.lua" in files:
                path = os.path.join(root, "dress_type_config.lua")
                break
    
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    
    # In dress_type_config, entries have:
    # id = X, dressType = Y, ownAttribute = { ... }, useAttribute = { ... }
    # Or serialized lua table
    print("Found dress_type_config at:", path)
    # Check for attrID 3 or [1] = 3
    matches = re.findall(r'(\b\d+\b).{1,100}?(?:ownAttribute|useAttribute).{1,50}?(?:\[1\]\s*=\s*3|attrID\s*=\s*3)', text, re.DOTALL)
    print(f"Matches count: {len(matches)}")

check_dress_attributes()
