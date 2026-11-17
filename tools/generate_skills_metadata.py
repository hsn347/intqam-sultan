import json
import re
import os

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_arab = json.load(f)

def t(key, default=""):
    return local_arab.get(key, default if default else key)

# 1. Lord Skills
with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    lord_text = f.read()

# Check active skills from skill.lua
with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8', errors='ignore') as f:
    skill_text = f.read()

active_skill_ids = set()
for m in re.finditer(r'skillID\s*=\s*(\d+).*?isAcitve\s*=\s*1\b', skill_text, re.DOTALL):
    full_id = m.group(1)
    base_id = full_id[:5]
    active_skill_ids.add(base_id)

lord_pattern = re.compile(r'id\s*=\s*(\d+)\s*;\(nil\)\.name\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]+)"\s*_ENV.*?icon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
lord_matches = lord_pattern.findall(lord_text)

lord_skills = []
seen_lord_icons = set()
for sid, sname_k, sdes_k, icon in lord_matches:
    category = "battle" if icon.startswith("Battle") else ("develop" if icon.startswith("Develop") else "assist")
    is_active = (sid in active_skill_ids) or ("Battle_15" in icon or "Battle_30" in icon or "Develop_15" in icon or "Develop_30" in icon or "Assist_15" in icon or "Assist_30" in icon)
    
    entry = {
        "id": int(sid),
        "name": t(sname_k, sname_k),
        "description": t(sdes_k, sdes_k),
        "icon": icon,
        "category": category,
        "is_active": is_active,
        "relative_path": f"skills/lord/{icon}"
    }
    lord_skills.append(entry)
    seen_lord_icons.add(icon)

# 2. Hero Skills
with open('game_file/src/app/localtb/config_client/hero_skill_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    hero_text = f.read()

hero_pattern = re.compile(r'skillID\s*=\s*(\d+)\s*;\(nil\)\.herName\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]*)"\s*_ENV.*?herIcon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
hero_matches = hero_pattern.findall(hero_text)

hero_skills = []
seen_hero_icons = set()
for sid, sname_k, sdes_k, icon in hero_matches:
    entry = {
        "id": int(sid),
        "name": t(sname_k, sname_k),
        "description": t(sdes_k, sdes_k),
        "icon": icon,
        "relative_path": f"skills/hero/{icon}"
    }
    hero_skills.append(entry)
    seen_hero_icons.add(icon)

# 3. Stun Skills
with open('game_file/src/app/localtb/config_client/hero_stuntskill_view.lua', 'r', encoding='utf-8', errors='ignore') as f:
    stun_text = f.read()

stun_pattern = re.compile(r'skillID\s*=\s*(\d+)\s*;\(nil\)\.name\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]+)"\s*_ENV.*?icon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
stun_matches = stun_pattern.findall(stun_text)

stun_skills = []
seen_stun_icons = set()
for sid, sname_k, sdes_k, icon in stun_matches:
    entry = {
        "id": int(sid),
        "name": t(sname_k, sname_k),
        "description": t(sdes_k, sdes_k),
        "icon": icon,
        "relative_path": f"skills/stun/{icon}"
    }
    stun_skills.append(entry)
    seen_stun_icons.add(icon)

# 4. Divine Beast Skills
with open('game_file/src/app/localtb/config_server/divine_beast_skill_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    beast_text = f.read()

beast_pattern = re.compile(r'skillID\s*=\s*(\d+).*?isActive\s*=\s*(\d+).*?skillName\s*=\s*nil,\s*"([^"]+)".*?skillDes.*?\[1\]\s*=\s*nil,\s*"([^"]+)".*?skillIcon\s*=\s*nil,\s*nil,\s*"([^"]+)"', re.DOTALL)
beast_matches = beast_pattern.findall(beast_text)

beast_skills = []
seen_beast_icons = set()
for sid, is_act, sname_k, sdes_k, icon in beast_matches:
    entry = {
        "id": int(sid),
        "name": t(sname_k, sname_k),
        "description": t(sdes_k, sdes_k),
        "icon": icon,
        "is_active": (is_act == "1"),
        "relative_path": f"skills/beast/{icon}"
    }
    beast_skills.append(entry)
    seen_beast_icons.add(icon)

# Complete metadata package
metadata = {
    "summary": {
        "total_skills_mapped": len(lord_skills) + len(hero_skills) + len(stun_skills) + len(beast_skills),
        "lord_skills_count": len(lord_skills),
        "hero_skills_count": len(hero_skills),
        "stun_skills_count": len(stun_skills),
        "beast_skills_count": len(beast_skills)
    },
    "categories": {
        "lord": {
            "title_ar": "مهارات الحاكم / اللورد (شجرة المواهب)",
            "total": len(lord_skills),
            "skills": lord_skills
        },
        "hero": {
            "title_ar": "مهارات الأبطال (Hero Skills)",
            "total": len(hero_skills),
            "skills": hero_skills
        },
        "stun": {
            "title_ar": "مهارات الصعق والقتال الخاصة (Stun Skills)",
            "total": len(stun_skills),
            "skills": stun_skills
        },
        "beast": {
            "title_ar": "مهارات الوحوش والحيوانات الأليفة (Divine Beast Skills)",
            "total": len(beast_skills),
            "skills": beast_skills
        }
    }
}

target_paths = [
    'dashboard/public/images/skills/skills_data.json',
    'dashboard/dist/images/skills/skills_data.json',
    'tools/skills_data.json'
]

for p in target_paths:
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, ensure_ascii=False, indent=2)
    print(f"Saved metadata to {p}")

print("\nSummary:")
for k, v in metadata['summary'].items():
    print(f"  {k}: {v}")
