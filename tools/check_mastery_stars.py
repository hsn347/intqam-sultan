import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

def check_mastery_and_stars():
    for root, dirs, files in os.walk(BASE_DIR):
        for f in files:
            fl = f.lower()
            if ('specialization' in fl or 'mastery' in fl or 'build_star' in fl or 'building_star' in fl) and fl.endswith('.lua'):
                p = os.path.join(root, f)
                with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                    text = fp.read()
                m96 = re.findall(r'\b96\b', text)
                m19 = re.findall(r'\b19\b', text)
                print(f"{f}: len={len(text)} | 96={len(m96)} | 19={len(m19)}")

check_mastery_and_stars()
