import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

keywords = [b'helmet', b'shengji', b'promote', b'jinji', b'tishi', b'bubble', b'jiaochang']

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plists: {len(all_plists)}")
    
    matches = set()
    for p in all_plists:
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    d = obj.read()
                    s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    for kw in keywords:
                        if kw in raw.lower():
                            # find all .png around kw
                            found_pngs = re.findall(rb'[a-zA-Z0-9_\-]*' + kw + rb'[a-zA-Z0-9_\-]*\.png', raw, re.IGNORECASE)
                            for fp in found_pngs:
                                matches.add((fp.decode('ascii', errors='ignore'), p))
        except Exception:
            pass

print(f"Total matching PNGs found: {len(matches)}")
for png, bundle in sorted(matches):
    print(f"{png} in {bundle}")
