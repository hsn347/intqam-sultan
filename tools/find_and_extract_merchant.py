import zipfile
import re

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    names = [n for n in z.namelist() if n.endswith('.bundle')]
    print(f"Total bundles: {len(names)}")
    found = []
    for i, name in enumerate(names):
        data = z.read(name)
        if b'merchant' in data.lower() or b'alliance_merchant' in data:
            print(f"Found match in: {name}")
            found.append(name)
        if b'icon_alliance_' in data:
            matches = set(re.findall(rb'icon_alliance_[a-zA-Z0-9_]+\.png', data))
            if matches:
                print(f"Found alliance icons in {name}: {matches}")

print(f"Total matching bundles: {len(found)}")
