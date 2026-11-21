import json

def inspect_castle(path, name):
    print(f"=== {name} ===")
    with open(path, 'r', encoding='utf-8') as f:
        d = json.load(f)
    heros = d.get('heroSysCtrl', {}).get('heroList', {})
    for hid in sorted(heros.keys(), key=lambda x: int(x)):
        h = heros[hid]
        st = h.get('state')
        lv = h.get('level')
        q = h.get('quality')
        dress = h.get('dress', {})
        print(f"Hero {hid}: state={st}, lv={lv}, quality={q}, dress={dress}")

inspect_castle('tools/beetoo1_full_init_data.json', 'BEETOO1')
inspect_castle('tools/beetoo2_full_init_data.json', 'BEETOO2')
