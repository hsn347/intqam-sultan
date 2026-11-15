import zipfile, io, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
target = b'icon_building_training_finish'

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    for p in all_plists:
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    d = obj.read()
                    s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    if target in raw:
                        print('Found target in:', p, d.m_Name)
        except Exception:
            pass
