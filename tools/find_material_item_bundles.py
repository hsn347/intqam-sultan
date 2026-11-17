import zipfile, io, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

targets = [b'2001.png', b'2002.png', b'2003.png', b'2004.png', b'2005.png', b'2006.png']

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plists: {len(all_plists)}")
    matches = {}
    for p in all_plists:
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    d = obj.read()
                    s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    for t in targets:
                        if t in raw:
                            t_str = t.decode('ascii')
                            if t_str not in matches:
                                matches[t_str] = []
                            matches[t_str].append((p, d.m_Name))
                            print(f"Found {t_str} in {p} ({d.m_Name})")
        except Exception:
            pass

print("\n--- Summary ---")
for k, v in matches.items():
    print(k, v)
