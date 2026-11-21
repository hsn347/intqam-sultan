import re

def check_pet_conf():
    path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\pet_level_conf.lua"
    with open(path, "r", encoding="utf-8", errors="ignore") as fp:
        content = fp.read()
    print("Checking pet_level_conf.lua for pet 1254...")
    matches = re.findall(r"petID\s*=\s*1254.*?level\s*=\s*43\b.*?(?=petID|\Z)", content, re.DOTALL)
    if matches:
        print(matches[0][:400])
    else:
        print("Not found by regex, searching petID = 1254...")
        pos = content.find("1254")
        if pos != -1:
            print(content[pos:pos+300])

if __name__ == "__main__":
    check_pet_conf()
