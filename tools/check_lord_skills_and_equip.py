import os
import re

def search_skills():
    skills_file = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\skill.lua"
    if not os.path.exists(skills_file):
        skills_file = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\lord_skill.lua"
    print(f"Reading {skills_file}...")
    with open(skills_file, "r", encoding="utf-8", errors="ignore") as fp:
        content = fp.read()
    
    # Check for skills
    beetoo_skills = ['13011', '11011', '13029', '13003', '13025', '13015', '13005', '13033', '13020', '11001', '13017', '13010', '13031', '11004', '13007', '13019', '13022', '13009', '13002', '13021', '11002', '13001', '13032', '13027', '13023', '13013']
    for sk in beetoo_skills:
        # Find lines mentioning sk
        matches = re.findall(rf".*{sk}.*", content)
        for m in matches[:2]:
            if "effect" in m or "type" in m or "buff" in m or "power" in m:
                print(f"Skill {sk}: {m}")

if __name__ == "__main__":
    search_skills()
