import re

def inspect_all_pets():
    with open('game_file/src/app/localtb/config_server/pet_level_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
        level_text = f.read()

    # Search all entries with attrType 18
    # Pattern in lua: talent_skill ... 18\d{8}
    pattern = re.compile(r'petid\s*=\s*(\d+).*?lv\s*=\s*(\d+).*?talent_skill.*?18(\d{2})(\d{6})', re.S)
    
    # Let's inspect Pet 1251, 1257, 1253 directly
    for pid in [1251, 1257, 1253]:
        print(f"\n--- ALL LEVELS OF PET {pid} ---")
        # Find all occurrences of petid = pid
        pos = 0
        while True:
            pos = level_text.find(str(pid), pos)
            if pos == -1:
                break
            snippet = level_text[pos-30:pos+350]
            m_lv = re.search(r'lv\s*=\s*(\d+)', snippet)
            if m_lv:
                lv_num = int(m_lv.group(1))
                # check if it has talent_skill with 18
                if 'talent_skill' in snippet:
                    talents = re.findall(r'(\d{10})', snippet)
                    for t in talents:
                        if t.startswith('18'):
                            print(f"Pet {pid} Lv {lv_num}: talent={t} -> attrType=18, val={int(t[4:])}")
            pos += len(str(pid))

if __name__ == '__main__':
    inspect_all_pets()
