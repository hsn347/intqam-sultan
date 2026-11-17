import zipfile

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if 'textures_assets_textures' in name:
            lower = name.lower()
            if any(num in lower for num in ['2001', '2002', '2003', '2004', '2005', '2006']):
                print("Match num in textures:", name)
            elif any(w in lower for w in ['item', 'goods', 'smith', 'material']):
                print("Match word in textures:", name)
