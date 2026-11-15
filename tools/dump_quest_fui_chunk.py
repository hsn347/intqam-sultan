import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    b = [n for n in z.namelist() if 'ccsfiles_mainui_fui.bytes' in n][0]
    env = UnityPy.load(io.BytesIO(z.read(b)))
    for obj in env.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            
            # Print strings extracted from 67400 to 68600
            chunk = raw[67400:68600]
            # split by null bytes
            parts = [p.decode('utf-8', 'ignore') for p in chunk.split(b'\x00') if p]
            for p in parts:
                if any(c.isalnum() for c in p):
                    print("  ", repr(p))
