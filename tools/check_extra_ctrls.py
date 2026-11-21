import re

def check_methods():
    files = [
        (r"e:\intqam-sultan\game_file\src\app\module\city\cityCtrl.lua", ["getMasteryBuffEffect", "getStarBuffEffect"]),
        (r"e:\intqam-sultan\game_file\src\app\module\alliance\allianceScience.lua", ["getProsperityBuffEffect"]),
        (r"e:\intqam-sultan\game_file\src\app\module\alliance\allianceStrontholdCtrl.lua", ["getBuffByType", "getBuffEffect"]),
        (r"e:\intqam-sultan\game_file\src\app\module\necklace\necklaceTecCtrl.lua", ["getBuffEffect", "getBuff"]),
        (r"e:\intqam-sultan\game_file\src\app\module\warHorn\warHornCtrl.lua", ["getBuffEffect", "getBuff"])
    ]
    
    for path, method_names in files:
        try:
            with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                text = f.read()
            print(f"=== File: {path.split('/')[-1].split('\\')[-1]} ===")
            for mn in method_names:
                pos = text.find(mn)
                if pos != -1:
                    print(f"Found {mn}:")
                    print(text[pos:pos+500])
                    print('-'*40)
                else:
                    print(f"Method {mn} NOT found")
        except Exception as e:
            print(f"Error {path}: {e}")

check_methods()
