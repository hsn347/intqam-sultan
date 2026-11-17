import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    full_plist = [n for n in z.namelist() if 'mainuiused_0.plist.bytes' in n][0]
    env_plist = UnityPy.load(io.BytesIO(z.read(full_plist)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break

matches = re.findall(rb'[\w\-_]+\.png', plist_data)
castle_matches = [m.decode('latin1') for m in matches if any(k in m.lower() for k in [b'castle', b'city', b'zhucheng', b'build'])]
print(f"Total matching sprites in mainuiused_0: {len(castle_matches)}")
for cm in sorted(castle_matches):
    print("  -", cm)
