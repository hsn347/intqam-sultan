import os
import re
import json

GAME_DIR = r"e:\intqam-sultan\game_file"

def find_file(name):
    for root, dirs, files in os.walk(GAME_DIR):
        if "src_bytecode" in root:
            continue
        if name in files:
            return os.path.join(root, name)
    return None

def get_file_content(path):
    if not path or not os.path.exists(path):
        return ""
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()

def main():
    print("Investigating specific systems...")

    # 1. petCtrl:getPetAttributeAdd
    pet_path = find_file("petCtrl.lua")
    if pet_path:
        txt = get_file_content(pet_path)
        m = re.search(r"function\s+petCtrl:getPetAttributeAdd\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== petCtrl:getPetAttributeAdd ===")
            print(m.group(0))

    # 2. warGemCtrl:getBuffPlus & wargem data
    wargem_path = find_file("warGemCtrl.lua")
    if wargem_path:
        txt = get_file_content(wargem_path)
        m = re.search(r"function\s+warGemCtrl:getBuffPlus\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== warGemCtrl:getBuffPlus ===")
            print(m.group(0))

    # 3. kingdomLevelBuff
    kl_path = find_file("kingdomLevelBuff.lua")
    print(f"\nkingdomLevelBuff path: {kl_path}")
    if kl_path:
        txt = get_file_content(kl_path)
        print("kingdomLevelBuff snippet:")
        print("\n".join(txt.split("\n")[:30]))

    # 4. nebulaTower
    # Search for getNebulaTowerBuffEffect across all files
    for r, d, files in os.walk(os.path.join(GAME_DIR, "src")):
        if "src_bytecode" in r:
            continue
        for f in files:
            if f.endswith(".lua"):
                p = os.path.join(r, f)
                with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                    c = fp.read()
                if "getNebulaTowerBuffEffect" in c:
                    print(f"\nFound getNebulaTowerBuffEffect in: {f}")
                    for line in c.split("\n"):
                        if "getNebulaTowerBuffEffect" in line:
                            print("  ", line.strip())

    # 5. militaryRankCtrl
    mil_path = find_file("militaryRankCtrl.lua")
    if mil_path:
        txt = get_file_content(mil_path)
        m = re.search(r"function\s+militaryRankCtrl:getTotalBuffValue\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== militaryRankCtrl:getTotalBuffValue ===")
            print(m.group(0))
        m2 = re.search(r"function\s+militaryRankCtrl:getSkillBuffValue\b.*?\nend\b", txt, re.DOTALL)
        if m2:
            print("\n=== militaryRankCtrl:getSkillBuffValue ===")
            print(m2.group(0))

    # 6. intetiorCtrl
    int_path = find_file("intetiorCtrl.lua")
    if int_path:
        txt = get_file_content(int_path)
        m = re.search(r"function\s+intetiorCtrl:getPolicyBuffPlus\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== intetiorCtrl:getPolicyBuffPlus ===")
            print(m.group(0))

    # 7. miraculousWeaponCtrl
    mw_path = find_file("miraculousWeaponCtrl.lua")
    if mw_path:
        txt = get_file_content(mw_path)
        m = re.search(r"function\s+miraculousWeaponCtrl:queryWeaponCellEffect\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== miraculousWeaponCtrl:queryWeaponCellEffect ===")
            print(m.group(0))

    # 8. exoticPavilionCtrl
    ep_path = find_file("exoticPavilionCtrl.lua")
    if ep_path:
        txt = get_file_content(ep_path)
        m = re.search(r"function\s+exoticPavilionCtrl:getBuffByType\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== exoticPavilionCtrl:getBuffByType ===")
            print(m.group(0))

    # 9. magicLampCtrl
    ml_path = find_file("magicLampCtrl.lua")
    if ml_path:
        txt = get_file_content(ml_path)
        m = re.search(r"function\s+magicLampCtrl:getBuffEffect\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== magicLampCtrl:getBuffEffect ===")
            print(m.group(0))

    # 10. manorCityCtrl
    manor_path = find_file("manorCityCtrl.lua")
    if manor_path:
        txt = get_file_content(manor_path)
        m = re.search(r"function\s+manorCityCtrl:getBuffVale\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== manorCityCtrl:getBuffVale ===")
            print(m.group(0))

    # 11. heroAppointCtrl
    ha_path = find_file("heroAppointCtrl.lua")
    if ha_path:
        txt = get_file_content(ha_path)
        m = re.search(r"function\s+heroAppointCtrl:getBuffVale\b.*?\nend\b", txt, re.DOTALL)
        if m:
            print("\n=== heroAppointCtrl:getBuffVale ===")
            print(m.group(0))

if __name__ == "__main__":
    main()
