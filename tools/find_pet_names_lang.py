import os
import zipfile
import re

print("Searching for Dear_pet_name_ in APKs...")
for apk in ['split_UnityDataAssetPack.apk', 'base.apk']:
    apk_path = os.path.join('game_file', 'apk_packages', apk)
    if not os.path.exists(apk_path):
        continue
    with zipfile.ZipFile(apk_path, 'r') as z:
        for name in z.namelist():
            if name.endswith(('.lua', '.txt', '.bytes', '.json', '.csv')):
                try:
                    data = z.read(name)
                    if b'Dear_pet_name_01' in data:
                        print(f"Found in {apk}: {name}")
                except:
                    pass

print("Searching in localtb...")
for root, dirs, files in os.walk('game_file/src/app/localtb'):
    for f in files:
        if f.endswith('.lua'):
            p = os.path.join(root, f)
            with open(p, 'rb') as fp:
                data = fp.read()
                if b'Dear_pet_name_01' in data:
                    print(f"Found in localtb: {p}")
