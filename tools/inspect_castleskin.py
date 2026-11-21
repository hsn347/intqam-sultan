import re

def inspect():
    with open('game_file/src/app/localtb/config_client/castleskin.lua', 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    print("Searching for 9002202 and 9002301 in castleskin.lua...")
    for dress_id in ['9002202', '9002301']:
        pos = content.find(str(dress_id))
        if pos != -1:
            print(f"Found {dress_id}: {content[pos:pos+200]}")
        else:
            print(f"{dress_id} not found in castleskin.lua")

    with open('game_file/src/app/localtb/config_client/castleskin_des.lua', 'r', encoding='utf-8', errors='ignore') as f:
        des_content = f.read()

    print("Searching for 90022 and 90023 in castleskin_des.lua...")
    for sub in ['90022', '90023']:
        pos = des_content.find(sub)
        if pos != -1:
            print(f"Found {sub}: {des_content[pos:pos+300]}")

if __name__ == '__main__':
    inspect()
