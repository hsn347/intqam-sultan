import glob
import re

def check_pets():
    files = glob.glob('game_file/**/pet_rank*.lua', recursive=True) + glob.glob('game_file/**/pet_level*.lua', recursive=True)
    print("Pet files:", files)
    
    for fn in files:
        with open(fn, 'r', encoding='utf-8', errors='ignore') as f:
            t = f.read()
        for pid in ['1251', '1257', '1253']:
            pos = t.find(pid)
            if pos != -1:
                print(f"Found {pid} in {fn}: {t[pos:pos+150]}")

if __name__ == '__main__':
    check_pets()
