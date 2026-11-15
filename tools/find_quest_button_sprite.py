import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = '2022.3.62f2'

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
found = set()

with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if not name.endswith('.bundle') or 'plist' not in name:
            continue
        try:
            env = UnityPy.load(io.BytesIO(z.read(name)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    m = re.findall(rb'[a-zA-Z0-9_\-]*(?:task|quest)[a-zA-Z0-9_\-]*\.png', raw, re.I)
                    for x in set(m):
                        sx = x.decode('ascii', 'ignore')
                        if any(w in sx.lower() for w in ['btn', 'icon', 'main', 'guide', 'button', 'entry', 'enter', 'board']):
                            found.add((sx, name.split('/')[-1]))
        except Exception:
            pass

for sx, bname in sorted(found):
    print(f"{sx}  in  {bname}")
