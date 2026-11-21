import os
import re

def search_enter_game():
    mod_dir = r"e:\intqam-sultan\game_file\src\app\module"
    print("Searching for EnterGame network requests in modules...")
    
    results = []
    for root, dirs, files in os.walk(mod_dir):
        for f in files:
            if not f.endswith(".lua"):
                continue
            path = os.path.join(root, f)
            with open(path, "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
            
            # find EnterGame function
            pos = content.find("EnterGame")
            if pos != -1:
                # find body of EnterGame up to end
                snippet = content[pos:pos+1500]
                end_pos = snippet.find("end\n")
                if end_pos != -1:
                    snippet = snippet[:end_pos+4]
                # check for Request
                requests = re.findall(r"serverproxy:Request\s*\(\s*([^,\)]+)\s*,\s*([^,\)]+)", snippet)
                if requests:
                    results.append((f, requests))
                    
    print(f"\nFound {len(results)} modules with EnterGame requests:")
    for f, reqs in sorted(results):
        print(f"  • {f}: {reqs}")

if __name__ == "__main__":
    search_enter_game()
