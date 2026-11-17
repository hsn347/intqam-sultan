import zipfile, io, re, UnityPy
UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/lordskill_0.plist.bytes_d8cb297020fb363b76d317327560bac1.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    env = UnityPy.load(io.BytesIO(z.read(bundle)))
    for obj in env.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            raw = getattr(d, 'raw_data', None)
            if raw is None: raw = getattr(d, 'bytes', None)
            if raw is None: raw = bytes(d.m_Script, 'raw_unicode_escape')
            matches = re.findall(rb'([a-zA-Z0-9_\-]+\.png)', raw)
            decoded = sorted(list(set([m.decode('ascii') for m in matches])))
            print(f"Total unique in lordSkill_0: {len(decoded)}")
            prefixes = {}
            for s in decoded:
                p = s.split('_')[0]
                prefixes[p] = prefixes.get(p, 0) + 1
            print("Prefixes:", prefixes)
            print("\nSample names:")
            for s in decoded:
                if not s.startswith('Assist'):
                    print("  ", s)
