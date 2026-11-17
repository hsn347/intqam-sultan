import zipfile, io, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

targets = [b'Castle_lv30.png', b'zhucheng.png', b'Castle_WarLv1.png', b'icon_map_mycastle.png', b'Castle_lv1.png']

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plists: {len(all_plists)}")
    for i, p in enumerate(all_plists):
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    for t in targets:
                        if t in raw:
                            print(f"FOUND {t.decode()} in: {p}")
        except Exception:
            pass
        if (i+1) % 150 == 0:
            print(f"Checked {i+1}/{len(all_plists)}...")

