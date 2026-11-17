import zipfile

targets = [b'2001.png', b'2002.png', b'2003.png', b'2004.png', b'2005.png', b'2006.png']

for apk in ['game_file/apk_packages/split_UnityDataAssetPack.apk', 'game_file/apk_packages/base.apk']:
    print(f"Scanning {apk}...")
    with zipfile.ZipFile(apk, 'r') as z:
        names = z.namelist()
        print(f"Total entries: {len(names)}")
        for n in names:
            if not n.endswith('.bundle'):
                continue
            data = z.read(n)
            # check how many targets match
            matched = [t.decode('ascii') for t in targets if t in data]
            if len(matched) >= 4:  # At least 4 of the 6 materials
                print(f"Bundle {n}: matches {matched}")
            elif b'2006.png' in data and b'2001.png' in data:
                print(f"Bundle {n}: matches 2001 & 2006")
