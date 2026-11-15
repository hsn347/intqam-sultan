import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    for n in z.namelist():
        if 'fui' in n.lower() and n.endswith('.bundle'):
            env = UnityPy.load(io.BytesIO(z.read(n)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    if b'9jgb0h68' in raw and b'FGUI' in raw[:10]:
                        print(f"PACKAGE DEFINITION: {n}")
                        idx = raw.find(b'9jgb0h68')
                        print(raw[max(0, idx-50):min(len(raw), idx+100)])
                    if b'gsjnj' in raw:
                        print(f"FOUND gsjnj in: {n}")
                        idx = raw.find(b'gsjnj')
                        print("Context of gsjnj:", raw[max(0, idx-80):min(len(raw), idx+120)])
