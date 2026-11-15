import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    for n in z.namelist():
        if 'mainui' in n.lower() and 'fui' in n.lower():
            env = UnityPy.load(io.BytesIO(z.read(n)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    if b'gsi57' in raw:
                        print(f"Found gsi57 in {n}")
                        idx = raw.find(b'gsi57')
                        print(raw[max(0, idx-100):min(len(raw), idx+100)])
