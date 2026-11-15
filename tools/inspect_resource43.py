import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    b = [n for n in z.namelist() if 'resource43_fui.bytes' in n][0]
    env = UnityPy.load(io.BytesIO(z.read(b)))
    for obj in env.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            print("Resource43 len:", len(raw))
            # Let's search for gsi57 in raw
            idx = raw.find(b'gsi57')
            print("Index of gsi57:", idx)
            if idx != -1:
                print("Context of gsi57:", raw[max(0, idx-50):min(len(raw), idx+150)])
            # Search for any .png or sprite names in raw
            import re
            pngs = re.findall(rb'[a-zA-Z0-9_\-]+\.png', raw)
            print("PNGs found in Resource43:", set(pngs))
            # Search for sprite atlas references
            atlas_refs = re.findall(rb'atlas[a-zA-Z0-9_\-]*', raw)
            print("Atlas refs:", set(atlas_refs))
