import zipfile, io, re, struct, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

targets = [
    'assets/aa/atlastp_assets_atlastp/singlemodule/skillicon_0.plist.bytes_1a13e8125edb9a10ff4d83fa709f6c0e.bundle',
    'assets/aa/atlastp_assets_atlastp/singlemodule/stunskillicon_0.plist.bytes_876ce7a9f896696abe50afa925031b23.bundle',
    'assets/aa/atlastp_assets_atlastp/singlemodule/lordskill_0.plist.bytes_d8cb297020fb363b76d317327560bac1.bundle'
]

with zipfile.ZipFile(apk_path, 'r') as z:
    for t in targets:
        print("="*60)
        print("Target:", t.split('/')[-1])
        env = UnityPy.load(io.BytesIO(z.read(t)))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                d = obj.read()
                raw = getattr(d, 'raw_data', None)
                if raw is None: raw = getattr(d, 'bytes', None)
                if raw is None: raw = bytes(d.m_Script, 'raw_unicode_escape')
                matches = re.findall(rb'([a-zA-Z0-9_\-]+\.png)', raw)
                decoded = [m.decode('ascii') for m in matches]
                print(f"Total sprites in {d.m_Name}: {len(decoded)}")
                print("First 30 sprites:")
                for s in decoded[:30]:
                    print("  ", s)
