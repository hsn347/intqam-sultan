import zipfile

with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
    for n in z.namelist():
        data = z.read(n)
        if b'questGuideNode' in data:
            print("Found in bundle:", n)
            # Check length and type
            print("Bundle size:", len(data))
