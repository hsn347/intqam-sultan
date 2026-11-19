import zipfile, io, re, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    full_plist = [n for n in z.namelist() if 'buildicon_0.plist.bytes' in n][0]
    env_plist = UnityPy.load(io.BytesIO(z.read(full_plist)))
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            s = getattr(d, 'm_Script', getattr(d, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            sprites = [x.decode() for x in re.findall(rb'[\w\-_]+\.png', raw)]
            print(f"Total sprites in buildicon_0: {len(sprites)}")
            print(sprites[:30])
