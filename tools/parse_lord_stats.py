import re
import os

def check_dress():
    print("=== CHECKING DRESS 9002202 ===")
    path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\dress_config.lua"
    with open(path, "r", encoding="utf-8", errors="ignore") as fp:
        lines = fp.readlines()
    for i, line in enumerate(lines):
        if "9002202" in line:
            for j in range(max(0, i-5), min(len(lines), i+25)):
                print(lines[j].strip())
            break

def check_equipment():
    print("\n=== CHECKING EQUIPMENT BASE / EXTRA ===")
    # beetoo1 equipped:
    # 6104501, 6204501, 6304001, 6404001, 6504001, 6604001
    eids = [6104501, 6204501, 6304001, 6404001, 6504001, 6604001]
    path_base = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua"
    with open(path_base, "r", encoding="utf-8", errors="ignore") as fp:
        content = fp.read()
    for eid in eids:
        pos = content.find(str(eid))
        if pos != -1:
            snippet = content[max(0, pos-100):min(len(content), pos+400)]
            print(f"EID {eid} snippet:\n{snippet}\n---")

def check_skills():
    print("\n=== CHECKING LORD SKILLS ===")
    # Skills in set:
    skills = ['13011', '11011', '13029', '13003', '13025', '13015', '13005', '13033', '13020', '11001', '13017', '13010', '13031', '11004', '13007', '13019', '13022', '13009', '13002', '13021', '11002', '13001', '13032', '13027', '13023', '13013']
    path_skill = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\skill.lua"
    with open(path_skill, "r", encoding="utf-8", errors="ignore") as fp:
        content = fp.read()
    for sk in skills:
        pos = content.find(sk)
        if pos != -1:
            snippet = content[max(0, pos-50):min(len(content), pos+300)]
            # check if buffType or effect is related to capacity (march, troop, capacity, etc.)
            print(f"Skill {sk}:\n{snippet}\n---")

if __name__ == "__main__":
    check_dress()
    check_equipment()
    check_skills()
