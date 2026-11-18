import zipfile, io, re, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def inspect_bundle(name):
    with zipfile.ZipFile(apk_path, 'r') as z:
        match = [n for n in z.namelist() if name in n and n.endswith('.bundle') and 'plist' in n]
        if not match:
            print("No match for", name)
            return
        b = z.read(match[0])
        env = UnityPy.load(io.BytesIO(b))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                d = obj.read()
                s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                sprites = re.findall(rb'[\w\-_]+\.png', raw)
                print(f"=== {name} sprites ({len(sprites)} total) ===")
                for sp in sorted(set(sprites)):
                    print("  -", sp.decode('latin1'))

inspect_bundle('peticon_0')
inspect_bundle('petcardicon_0')
