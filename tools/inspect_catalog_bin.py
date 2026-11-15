import zipfile
import re

with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
    cat = z.read('assets/aa/catalog.bin')
    idx = 0
    while True:
        idx = cat.find(b'questGuideNode', idx)
        if idx == -1: break
        print("Match at", idx)
        print("Context:", cat[max(0, idx-50):min(len(cat), idx+100)])
        idx += 14
