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
                    if b'fx837mxi' in raw:
                        print(f"Found fx837mxi in {n.split('/')[-1]}")
                        idx = raw.find(b'fx837mxi')
                        print(raw[max(0, idx-50):min(len(raw), idx+100)])
