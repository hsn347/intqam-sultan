import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

def check_buff_in_file(relpath, codes=[96, 19]):
    p = os.path.join(BASE_DIR, relpath)
    if not os.path.exists(p):
        return
    with open(p, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    hits = {}
    for c in codes:
        m = re.findall(rf'\b{c}\b', text)
        if m:
            hits[c] = len(m)
    if hits:
        print(f"[+] {relpath}: {hits}")

ctrls = [
    r"src\app\module\legendLordWarCtrl\legendLordCtrl.lua",
    r"src\app\module\hegemon\hegemonCtrl.lua",
    r"src\app\module\alliance\allianceCtrl.lua",
    r"src\app\module\alliance\alliancePetCtrl.lua",
    r"src\app\module\atlantisWar\atlantisPrivilegeCtrl.lua",
    r"src\app\module\nebulaWar\nebulaPrivilegeCtrl.lua",
    r"src\app\module\warOrder\warOrderCtrl.lua",
    r"src\app\localtb\config_server\legend_lord_title.lua",
    r"src\app\localtb\config_server\hegemon_title.lua",
    r"src\app\localtb\config_server\alliance_official.lua",
    r"src\app\localtb\config_server\atlantis_privilege.lua",
    r"src\app\localtb\config_server\nebula_privilege.lua",
    r"src\app\localtb\config_server\war_order_privilege.lua"
]

for c in ctrls:
    check_buff_in_file(c)
