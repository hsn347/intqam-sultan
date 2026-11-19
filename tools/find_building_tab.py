with open('dashboard/src/components/accounts/TaskTabContent.tsx', 'r', encoding='utf-8') as f:
    lines = f.readlines()
for i, l in enumerate(lines):
    if "activeTab === 'building'" in l or "التطوير والمكافآت" in l or "building" in l.lower():
        if any(k in l for k in ['activeTab', 'building', 'Section', 'Header']):
            print(f"{i+1}: {l.strip()[:100]}")
