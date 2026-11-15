import zipfile, io, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def inspect_plist(bundle_name):
    with zipfile.ZipFile(apk_path, 'r') as z:
        env = UnityPy.load(io.BytesIO(z.read(bundle_name)))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                d = obj.read()
                s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                import re
                pngs = re.findall(rb'([a-zA-Z0-9_\-]+\.png)', raw)
                print(f"=== {bundle_name} ===")
                for p in set(pngs):
                    print(p.decode('ascii'))

inspect_plist('assets/aa/atlastp_assets_atlastp/singlemodule/builddrillgroundui_0.plist.bytes_60b63abd1d147aa92afaeca5b993fe2b.bundle')
inspect_plist('assets/aa/atlastp_assets_atlastp/singlemodule/troopflagui_0.plist.bytes_b2ba5151de82f558a856743191af6a6c.bundle')
