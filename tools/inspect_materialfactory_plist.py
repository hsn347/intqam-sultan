import zipfile, io, UnityPy, re

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
bundle_plist = 'assets/aa/atlastp_assets_atlastp/singlemodule/materialfactory_0.plist.bytes_f810ea93d25dcf8e31e7b0fa260a5c52.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    env = UnityPy.load(io.BytesIO(z.read(bundle_plist)))
    for obj in env.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            s = getattr(d, 'm_Script', getattr(d, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            pngs = re.findall(rb'([a-zA-Z0-9_\-]+\.png)', raw)
            print(f"=== {bundle_plist} ===")
            for p in sorted(set(pngs)):
                print(p.decode('ascii'))
