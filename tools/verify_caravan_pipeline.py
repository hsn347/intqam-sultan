import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
c.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = c.fetchall()
print("Tables in castles.db:", tables)

for t in tables:
    tname = t[0]
    print(f"\n--- Table: {tname} ---")
    c.execute(f"PRAGMA table_info({tname});")
    cols = [col[1] for col in c.fetchall()]
    print("Columns:", cols)
    c.execute(f"SELECT * FROM {tname} LIMIT 5;")
    rows = c.fetchall()
    for r in rows:
        print(f"Row: {r[0] if len(r)>0 else ''}")
        if 'config' in cols:
            idx = cols.index('config')
            cfg = json.loads(r[idx]) if isinstance(r[idx], str) else r[idx]
            print("  caravan in config:", 'caravan' in cfg, "value:", cfg.get('caravan'))

print("\n--- bot_manager.py check ---")
with open('bot_manager.py', 'r', encoding='utf-8') as f:
    bm_text = f.read()

print("caravan in DEFAULT_BOT_CONFIG:", "'caravan'" in bm_text or '"caravan"' in bm_text)
idx_reload = bm_text.find("def reload_config_from_db")
if idx_reload != -1:
    reload_snip = bm_text[idx_reload:idx_reload+2000]
    print("caravan in reload_config_from_db:", "caravan" in reload_snip)

print("\n--- api_server.py check ---")
with open('api_server.py', 'r', encoding='utf-8') as f:
    api_text = f.read()

print("caravan in api_server.py:", "caravan" in api_text)

print("\n--- types/index.ts check ---")
with open('dashboard/src/types/index.ts', 'r', encoding='utf-8') as f:
    types_text = f.read()

print("caravan in types/index.ts:", "caravan" in types_text)

print("\n--- TaskTabs.tsx check ---")
with open('dashboard/src/components/accounts/TaskTabs.tsx', 'r', encoding='utf-8') as f:
    tabs_text = f.read()

print("caravan tab in TaskTabs.tsx:", "caravan" in tabs_text)

print("\n--- TaskTabContent.tsx check ---")
with open('dashboard/src/components/accounts/TaskTabContent.tsx', 'r', encoding='utf-8') as f:
    content_text = f.read()

print("caravan in performSave:", "caravanDraft" in content_text or "caravan:" in content_text)
print("caravan in handleSave:", "caravanConfig" in content_text or "caravan:" in content_text)
print("caravan in separate tab condition:", "tab === 'caravan'" in content_text or 'tab === "caravan"' in content_text)

print("\n--- Locales check ---")
for loc in ['ar', 'en', 'tr']:
    with open(f'dashboard/src/locales/{loc}.json', 'r', encoding='utf-8') as f:
        loc_data = json.load(f)
        print(f"{loc}: tabs.caravan =", loc_data.get('tabs', {}).get('caravan'), "| tasks.caravan =", loc_data.get('tasks', {}).get('caravan'))

print("\n--- Caravan Tab rendering in TaskTabContent.tsx ---")
idx = content_text.find("tab === 'caravan'")
if idx != -1:
    print(content_text[idx:idx+600])
else:
    print("tab === 'caravan' not found!")
