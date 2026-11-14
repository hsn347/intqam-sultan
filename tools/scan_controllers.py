# -*- coding: utf-8 -*-
import os
import re

controllers = set()
ctrl_direct = set()

# Regexes to capture controller accesses
pattern_get_ctrl = re.compile(r'get_ctrl\(\s*[\"\']([a-zA-Z0-9_]+)[\"\']\s*\)')
pattern_init_data = re.compile(r'init_data(?:\.get)?\[?\s*[\"\']([a-zA-Z0-9_]+)[\"\']')
pattern_conn_init = re.compile(r'conn\.init_data(?:\.get)?\[?\s*[\"\']([a-zA-Z0-9_]+)[\"\']')
pattern_general_ctrl = re.compile(r'[\"\']([a-zA-Z0-9_]+(?:Ctrl|Mgr|Data|Task))[\"\']')

# Specific task keys we know exist (e.g., commandHall)
special_names = {"commandHall", "armyGroupTaskData", "local_queues", "queues", "queue", "army", "lord", "bagCtrl"}

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

for root, dirs, files in os.walk(root_dir):
    # Skip non-project folders
    if any(skip in root for skip in ('node_modules', '.git', 'game_file', 'decompiled_java', 'apk_packages')):
        continue
    for f in files:
        if f.endswith('.py'):
            p = os.path.join(root, f)
            try:
                with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                    content = fp.read()
                    for m in pattern_get_ctrl.finditer(content):
                        ctrl_direct.add(m.group(1))
                    for m in pattern_init_data.finditer(content):
                        ctrl_direct.add(m.group(1))
                    for m in pattern_conn_init.finditer(content):
                        ctrl_direct.add(m.group(1))
                    for m in pattern_general_ctrl.finditer(content):
                        controllers.add(m.group(1))
            except Exception:
                pass

print("=== DIRECTLY ACCESSED CONTROLLERS VIA get_ctrl / init_data ===")
for c in sorted(ctrl_direct):
    print(f"  - {c}")

print("\n=== ALL CONTROLLER-LIKE STRINGS IN PYTHON CODE ===")
for c in sorted(controllers):
    if c in ctrl_direct:
        continue
    print(f"  - {c}")
