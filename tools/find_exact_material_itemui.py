import zipfile

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if 'textures_assets_textures/itemui/' in name:
            fname = name.split('/')[-1]
            for num in range(2001, 2007):
                if fname.startswith(f"{num}.png"):
                    print(f"FOUND: {num} -> {name}")
