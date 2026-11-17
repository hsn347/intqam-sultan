import zipfile, io, UnityPy, re

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    full_plist = [n for n in z.namelist() if 'worldmapcastle_0.plist.bytes' in n][0]
    full_png = [n for n in z.namelist() if 'worldmapcastle_0.png' in n][0]
    print("Found plist bundle:", full_plist)
    print("Found png bundle:", full_png)
    
    env_plist = UnityPy.load(io.BytesIO(z.read(full_plist)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break

matches = re.findall(rb'[\w\-_]+\.png', plist_data)
print(f"Total sprites in worldmapcastle_0: {len(matches)}")
print("Sample sprites:")
for m in sorted(set(matches)):
    print("  -", m.decode('latin1'))
