import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if not name.endswith('.bundle') or 'plist' not in name: continue
        try:
            env = UnityPy.load(io.BytesIO(z.read(name)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    if b'objective' in raw.lower():
                        matches = re.findall(rb'[a-zA-Z0-9_\-]*objective[a-zA-Z0-9_\-]*\.png', raw, re.IGNORECASE)
                        print(f"Found in {name.split('/')[-1]}: {[m.decode('ascii') for m in matches]}")
        except Exception:
            pass
