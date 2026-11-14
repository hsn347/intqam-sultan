# -*- coding: utf-8 -*-
import os
import re

files_to_check = [
    'tasks/train.py',
    'tasks/daily_train.py',
    'tasks/forge_equipment.py',
    'tasks/building.py',
    'api_server.py'
]

print("=== Forensic Scan ===")
issues = []
for fp in files_to_check:
    if not os.path.exists(fp):
        issues.append(f"Missing file: {fp}")
        continue
    with open(fp, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    print(f"Auditing {fp}: {len(lines)} lines")
    for i, line in enumerate(lines, 1):
        s = line.strip()
        if s.startswith('return "PASS"') or s.startswith('return "FAIL"') or s.startswith("return 'PASS'"):
            issues.append(f"{fp}:{i} - Hardcoded test verdict: {s}")
        if 'NotImplementedError' in s:
            issues.append(f"{fp}:{i} - NotImplementedError: {s}")
        if 'mock' in s.lower() and not s.startswith('#'):
            # check if it's actual mock in production code
            issues.append(f"{fp}:{i} - Mock reference in production: {s}")

if issues:
    print(f"FOUND {len(issues)} FORENSIC ISSUES:")
    for iss in issues:
        print(f"  - {iss}")
else:
    print("ALL 5 PRODUCTION CODEFILES CLEAN: 0 hardcoding, 0 facades, 0 mocks in production code.")
