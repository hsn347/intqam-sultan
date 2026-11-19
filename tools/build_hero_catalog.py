import re
import json

# 1. Base Arabic translations
with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_ar = json.load(f)

# 2. Delta patch Arabic translations
with open('game_file/localtb/delta_patch_tables/local_arab_ext.lua', 'r', encoding='utf-8', errors='ignore') as f:
    ext_text = f.read()

# Load hero_view_info.lua
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    view_text = f.read()

lines = view_text.split('\n')
current_hid = None
heroes_raw = {}

for line in lines:
    m_id = re.search(r'heroID\s*=\s*(\d+)', line)
    if m_id:
        current_hid = int(m_id.group(1))
        heroes_raw[current_hid] = {'id': current_hid, 'lines': []}
    if current_hid:
        heroes_raw[current_hid]['lines'].append(line)

known_extra_names = {
    1737: "الصنديد",
    1738: "الشنفرى",
    1739: "الباشق",
    1740: "الجليلة",
    1741: "فارس الهيجاء",
    1742: "الملاك الساهرة",
    1743: "أميرة وحيد القرن",
    1744: "المدمّر",
    1745: "أُسيد",
    1746: "الماجدة",
    1747: "هدير اللهب",
    1748: "السهم الصاعق",
    1749: "سلطان عاصفة الصحراء",
    1750: "قُصي",
    1751: "زُهير",
    1752: "سليل الصوارم",
    1753: "شاهين",
    1754: "وقاص",
    1755: "ملكة الغابة",
    1756: "صياد الصحراء",
    1757: "العاصف الرعدي",
}

type_name_en_map = {
    1: "ancillary",
    2: "chariots",
    3: "cavalry",
    4: "archer",
    5: "infantry"
}
type_name_ar_map = {
    1: "مساعد",
    2: "عربات",
    3: "فرسان",
    4: "رماة",
    5: "مشاة"
}

catalog = {}
for hid, hdata in sorted(heroes_raw.items()):
    block = '\n'.join(hdata['lines'])
    m_name = re.search(r'herName\s*=\s*"([^"]+)"', block)
    m_cname = re.search(r'\bname\s*=\s*"([^"]+)"', block)
    m_rar = re.search(r'rarity\s*=\s*(\d+)', block)
    
    ht_val = None
    for l in hdata['lines']:
        if 'heroType' in l:
            nums = re.findall(r'\b(\d+)\b', l)
            if nums:
                ht_val = int(nums[-1])
            break
    
    her_name_key = m_name.group(1) if m_name else ''
    name_code = m_cname.group(1) if m_cname else ''
    
    # Official client rarity:
    rarity = int(m_rar.group(1)) if m_rar else 1
    if rarity > 10:
        rarity = 5 if hid >= 1720 else 1
    
    # Resolve Arabic Name:
    name_ar = known_extra_names.get(hid)
    if not name_ar:
        name_ar = local_ar.get(her_name_key, name_code)
    
    catalog[hid] = {
        "hero_id": hid,
        "hero_type": ht_val,
        "type_name_en": type_name_en_map.get(ht_val, "unknown"),
        "type_name_ar": type_name_ar_map.get(ht_val, "غير معروف"),
        "name_code": name_code,
        "name_ar": name_ar,
        "rarity": rarity
    }

print(f"Catalog complete with {len(catalog)} heroes.")
for hid, meta in sorted(catalog.items()):
    print(f"[{hid}] Type: {meta['hero_type']} ({meta['type_name_ar']}/{meta['type_name_en']}) | Rarity: {meta['rarity']} | Name: {meta['name_ar']}")

with open('tools/full_hero_catalog.json', 'w', encoding='utf-8') as f:
    json.dump(catalog, f, ensure_ascii=False, indent=2)
