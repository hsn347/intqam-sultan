import json

for path, name in [('tools/beetoo1_full_init_data.json', 'beetoo1'), ('tools/beetoo2_full_init_data.json', 'beetoo2')]:
    with open(path, encoding='utf-8') as f:
        d = json.load(f)
    print(f"=== {name} Medals ===")
    # Search anywhere in d for 'medal' or 'medals'
    achieve = d.get('lordInfoCtrl', {}).get('achieveInfo', {})
    print(f"  achieveInfo: {achieve}")
    
    # search for any dict with 'medalID'
    def find_medals(obj):
        res = []
        if isinstance(obj, dict):
            if 'medalID' in obj:
                res.append(obj)
            for v in obj.values():
                res.extend(find_medals(v))
        elif isinstance(obj, list):
            for item in obj:
                res.extend(find_medals(item))
        return res
    
    medals = find_medals(d)
    print(f"  Total medals found: {len(medals)}")
    for m in medals:
        print(f"    Medal: {m}")
