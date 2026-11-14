import re
import json

def main():
    with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8') as f:
        content = f.read()

    blocks = content.split('heroID =')
    heroes = {}
    for b in blocks[1:]:
        m_id = re.search(r'^\s*(\d+)', b)
        m_type = re.search(r'heroType[^\n]*?=\s*[^,\n]+,\s*(\d+)', b)
        m_name = re.search(r'herName\s*=\s*"([^"]+)"', b)
        m_rarity = re.search(r'rarity\s*=\s*nil,\s*(\d+)', b)
        if m_id:
            hid = int(m_id.group(1))
            htype = int(m_type.group(1)) if m_type else 0
            hname = m_name.group(1) if m_name else ''
            heroes[hid] = {'type': htype, 'name': hname}

    print(f"Total heroes parsed: {len(heroes)}")
    type_1 = [hid for hid, h in heroes.items() if h['type'] == 1]
    print(f"HeroType 1 (Auxiliary/Gathering) [{len(type_1)}]: {type_1}")
    
    with open('game_file/src/app/localtb/config_server/local_arab.lua', 'r', encoding='utf-8') as f:
        arab_text = f.read()

    print("\nHero Names for Type 1 (Support/Gathering):")
    for hid in type_1:
        m = re.search(r'\["heroname_' + str(hid) + r'"\]\s*=\s*"([^"]+)"', arab_text)
        name = m.group(1) if m else "Unknown"
        print(f"  ID {hid}: {name}")

    print("\nSample Combat Heroes (Types 2-5):")
    with open('docs/sample_live_memory.json', 'r', encoding='utf-8') as f:
        mem = json.load(f)

    city = mem.get('cityCtrl', {})
    import sqlite3
    db_conn = sqlite3.connect('database/castles.db')
    cursor = db_conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = cursor.fetchall()
    print(f"\nTables in database/castles.db: {tables}")
    cursor.execute("SELECT email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"\nTotal castles in castle_states: {len(rows)}")
    for email, cfg_str in rows:
        cfg = json.loads(cfg_str) if cfg_str else {}
        ch_in_root = "command_hall" in cfg
        ch_in_tasks = "command_hall" in cfg.get("tasks", {})
        ch_cfg = cfg.get("command_hall") or cfg.get("tasks", {}).get("command_hall")
        print(f"  Castle {email}: command_hall in root={ch_in_root}, in tasks={ch_in_tasks}, cfg={ch_cfg}")
    db_conn.close()

if __name__ == '__main__':
    main()
