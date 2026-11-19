# -*- coding: utf-8 -*-
import glob
import os
import re

def main():
    cmds = set()
    patterns = [
        re.compile(r'safe_query\(\s*["\']([^"\']+)["\'](?:\s*,\s*["\']([^"\']+)["\'])?'),
        re.compile(r'conn\.query\(\s*["\']([^"\']+)["\'](?:\s*,\s*["\']([^"\']+)["\'])?'),
        re.compile(r'query\(\s*["\']([^"\']+)["\'](?:\s*,\s*["\']([^"\']+)["\'])?'),
        re.compile(r'CMD_\w+\s*=\s*["\']([^"\']+)["\']'),
        re.compile(r'REQ_\w+\s*=\s*["\']([^"\']+)["\']'),
    ]

    files = glob.glob('tasks/*.py') + ['core/game_client.py']
    for fpath in files:
        with open(fpath, 'r', encoding='utf-8', errors='ignore') as fp:
            lines = fp.readlines()
        for i, line in enumerate(lines):
            for pat in patterns:
                for match in pat.finditer(line):
                    groups = match.groups()
                    cmds.add((os.path.basename(fpath), i + 1, groups))

    for item in sorted(cmds, key=lambda x: (x[0], x[1])):
        print(f"{item[0]}:{item[1]} -> {item[2]}")

if __name__ == '__main__':
    main()
