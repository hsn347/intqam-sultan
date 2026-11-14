import json
import re
import sys

# Ensure UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8') as f:
    text = f.read()

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    ar = json.load(f)

heroes = []
blocks = text.split('heroID =')
for b in blocks[1:]:
    m_id = re.search(r'^\s*(\d+)', b)
    m_type = re.search(r'heroType[^\n]*?=\s*[^,\n]+,\s*(\d+)', b)
    m_name = re.search(r'herName\s*=\s*"([^"]+)"', b)
    if m_id and m_type:
        hid = int(m_id.group(1))
        htype = int(m_type.group(1))
        hname_key = m_name.group(1) if m_name else ''
        name_ar = ar.get(hname_key, 'Unknown')
        heroes.append((hid, htype, hname_key, name_ar))

print("=== Type 1 Heroes (Support / Gathering / Auxiliary - أبطال الدعم / الجمع) ===")
for hid, htype, hkey, hname in heroes:
    if htype == 1:
        print(f"ID={hid}, Type={htype}, Key={hkey}, ArabicName={hname}")

print("\n=== Combat Heroes (Types 2-5 - أبطال القتال والحروب) ===")
for hid, htype, hkey, hname in heroes:
    if htype != 1:
        type_names = {2: "Chariot/عربة", 3: "Cavalry/فرسان", 4: "Archer/رماة", 5: "Infantry/مشاة"}
        tname = type_names.get(htype, str(htype))
        print(f"ID={hid}, Type={htype} ({tname}), Key={hkey}, ArabicName={hname}")
