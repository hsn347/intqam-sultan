import json

for fname, name in [('tools/beetoo1_full_init_data.json', 'beetoo1'), ('tools/beetoo2_full_init_data.json', 'beetoo2')]:
    with open(fname, encoding='utf-8') as f:
        d = json.load(f)
    tech = d.get('technologyCtrl', {})
    print(f"=== {name} Tech ===")
    for tid in ['24016', '24032', '25030', '24048', '110027', '21016']:
        print(f"  tech {tid}: {tech.get(tid)}")
