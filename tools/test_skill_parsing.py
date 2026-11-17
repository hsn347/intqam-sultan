import json
import re

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_arab = json.load(f)

print("--- 1. Testing Lord Skills ---")
with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    lord_text = f.read()

# Pattern for lordskilldes
# ;(nil).id = 11001\n;(nil).name = "lordskill_name_11001"\n;(nil).des = "lordskill_des_11001"\n_ENV, (nil)[11001], (nil).icon = nil, nil, "Battle_1.png"
lord_pattern = re.compile(r'id\s*=\s*(\d+)\s*;\(nil\)\.name\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]+)"\s*_ENV.*?icon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
lord_matches = lord_pattern.findall(lord_text)
print(f"Lordskill matches: {len(lord_matches)}")

# Check active skills from skill.lua
with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8', errors='ignore') as f:
    skill_text = f.read()
active_skill_ids = set()
for m in re.finditer(r'skillID\s*=\s*(\d+).*?isAcitve\s*=\s*1\b', skill_text, re.DOTALL):
    full_id = m.group(1)
    base_id = full_id[:5] # e.g. 1101101 -> 11011
    active_skill_ids.add(base_id)
print(f"Active skill base IDs: {len(active_skill_ids)}")

print("\n--- 2. Testing Hero Skills ---")
with open('game_file/src/app/localtb/config_client/hero_skill_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    hero_text = f.read()
hero_pattern = re.compile(r'skillID\s*=\s*(\d+)\s*;\(nil\)\.herName\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]*)"\s*_ENV.*?herIcon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
hero_matches = hero_pattern.findall(hero_text)
print(f"Hero skill matches: {len(hero_matches)}")

print("\n--- 3. Testing Stun Skills ---")
with open('game_file/src/app/localtb/config_client/hero_stuntskill_view.lua', 'r', encoding='utf-8', errors='ignore') as f:
    stun_text = f.read()
stun_pattern = re.compile(r'skillID\s*=\s*(\d+)\s*;\(nil\)\.name\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]+)"\s*_ENV.*?icon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
stun_matches = stun_pattern.findall(stun_text)
print(f"Stun skill matches: {len(stun_matches)}")

print("\n--- 4. Testing Divine Beast Skills ---")
with open('game_file/src/app/localtb/config_server/divine_beast_skill_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    beast_text = f.read()
beast_pattern = re.compile(r'skillID\s*=\s*(\d+).*?isActive\s*=\s*(\d+).*?skillName\s*=\s*nil,\s*"([^"]+)".*?skillDes.*?\[1\]\s*=\s*nil,\s*"([^"]+)".*?skillIcon\s*=\s*nil,\s*nil,\s*"([^"]+)"', re.DOTALL)
beast_matches = beast_pattern.findall(beast_text)
print(f"Beast skill matches: {len(beast_matches)}")
