with open(r'e:\intqam-sultan\dashboard\src\components\accounts\TaskTabContent.tsx', 'r', encoding='utf-8') as f:
    for i, line in enumerate(f):
        if 'tab ===' in line:
            print(f"Line {i+1}: {line.strip()}")
        if 'building' in line.lower() and ('comingsoon' in line.lower() or 'taskrow' in line.lower() or 'tab' in line.lower()):
            print(f"Line {i+1} [building]: {line.strip()[:100]}")

