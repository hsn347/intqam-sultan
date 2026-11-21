import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

for name, d in [('beetoo1', d1), ('beetoo2', d2)]:
    print(f"\n=== {name} ===")
    for k in d:
        if 'beast' in k.lower() or 'divine' in k.lower():
            print(f"  {k}: {d[k]}")
