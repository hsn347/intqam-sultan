import sys
import re

def inspect_file(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()
    
    print(f"File: {filepath}, Size: {len(data)}")
    # Find all ASCII strings of length >= 3
    strings = re.findall(rb'[a-zA-Z_][a-zA-Z0-9_]{2,}', data)
    str_list = [s.decode('ascii', errors='ignore') for s in strings]
    
    print(f"Total tokens found: {len(str_list)}")
    # Print tokens matching hero or autoFill or dispatch or capacity
    keywords = ['autoFill', 'export', 'Hero', 'hero', 'Capacity', 'capacity', 'march', 'March', 'buff', 'Buff', 'sort', 'Sort']
    matched = [s for s in str_list if any(k.lower() in s.lower() for k in keywords)]
    print("Matched tokens:")
    print(list(dict.fromkeys(matched)))

if __name__ == '__main__':
    inspect_file(r"e:\intqam-sultan\game_file\src_bytecode\fgui\gcomponent\CommonNew\heroSelectBanner.lua")
