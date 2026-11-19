import re

def search_hero_buildings():
    try:
        with open('game_file/src/app/localtb/config_server/building.lua', 'r', encoding='utf-8', errors='ignore') as f:
            text = f.read()
    except Exception as e:
        print("Error reading building.lua:", e)
        return

    pattern = re.compile(r'id\s*=\s*(\d+).*?name\s*=\s*"([^"]+)"', re.DOTALL)
    for m in pattern.finditer(text):
        if 'hero' in m.group(2).lower():
            print(f"Building ID: {m.group(1)} NameKey: {m.group(2)}")

if __name__ == '__main__':
    search_hero_buildings()










