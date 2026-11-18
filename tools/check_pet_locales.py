import json

for lang in ['ar', 'en', 'tr']:
    with open(f'dashboard/src/locales/{lang}.json', 'r', encoding='utf-8') as f:
        d = json.load(f)
    print(f"=== {lang} ===")
    tasks = d.get('tasks', {})
    pet_keys = {k: v for k, v in tasks.items() if 'pet' in k.lower()}
    print("pet keys in tasks:", pet_keys)
