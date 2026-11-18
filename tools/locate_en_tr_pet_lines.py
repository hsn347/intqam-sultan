for lang in ['en', 'tr']:
    with open(f'dashboard/src/locales/{lang}.json', 'r', encoding='utf-8') as f:
        lines = f.readlines()
    for i, l in enumerate(lines):
        if 'petRunner' in l:
            print(f"=== {lang} ===")
            for j in range(max(0, i-2), min(len(lines), i+5)):
                print(f"  {j+1}: {lines[j].rstrip()}")
