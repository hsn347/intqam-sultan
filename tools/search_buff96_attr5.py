import os
import re

def search_buff_and_attr():
    config_dir = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
    print(f"Scanning config_server in {config_dir} for buff 96 and attr 5...")
    
    found_buff96 = []
    found_attr5 = []
    
    for f in os.listdir(config_dir):
        if not f.endswith(".lua"):
            continue
        path = os.path.join(config_dir, f)
        with open(path, "r", encoding="utf-8", errors="ignore") as fp:
            content = fp.read()
            
        # check buffType = 96 or buff 96
        if "buffType" in content and ("= 96" in content or "96," in content):
            found_buff96.append(f)
        elif "buff" in content and "96" in content:
            # check regex
            m = re.findall(r"buff.*?96", content, re.IGNORECASE)
            if m:
                found_buff96.append(f)
                
        # check attrID = 5 or attrType = 5
        if "attrID" in content and ("= 5" in content or "5," in content):
            found_attr5.append(f)
        elif "attrType" in content and ("= 5" in content or "5," in content):
            found_attr5.append(f)
            
    print("\n--- Files with Buff 96 (MARCH_VALUE_LIMIT_BOOST) ---")
    for f in sorted(set(found_buff96)):
        print("  •", f)
        
    print("\n--- Files with Attr 5 (DISPATCH_TROOP_COUNT_NUM) ---")
    for f in sorted(set(found_attr5)):
        print("  •", f)

if __name__ == "__main__":
    search_buff_and_attr()
