with open('dashboard/src/components/accounts/TaskTabContent.tsx', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if 'grid-cols' in l or 'WORKSHOP_MATERIALS' in l or 'SOLDIER_TYPES' in l:
        print(f"{i+1}: {l.strip()[:100]}")
