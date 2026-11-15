import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

keywords = [
    b'fdj', b'sousuo', b'juanzhou', b'renwu', b'task', b'quest',
    b'magnif', b'search', b'scroll', b'chaxun'
]

results = set()

with zipfile.ZipFile(apk_path, 'r') as z:
    plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plists: {len(plists)}")
    
    for p in plists:
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    
                    for kw in keywords:
                        if kw in raw.lower():
                            matches = re.findall(rb'[a-zA-Z0-9_\-]*' + kw + rb'[a-zA-Z0-9_\-]*\.png', raw, re.IGNORECASE)
                            for m in matches:
                                results.add((p, m.decode('ascii', errors='ignore')))
        except Exception:
            pass

print(f"Total unique sprite matches: {len(results)}")
for p, s in sorted(results, key=lambda x: x[1]):
    print(f"  {s}  <--  {p.split('/')[-1]}")
