import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
    for target_name in ['buildicon_0.plist.bytes', 'iconbuilding_0.plist.bytes']:
        bundle_names = [n for n in z.namelist() if target_name in n]
        if not bundle_names:
            continue
        bname = bundle_names[0]
        env = UnityPy.load(io.BytesIO(z.read(bname)))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                text = s if isinstance(s, str) else bytes(s).decode('latin1', errors='ignore')
                print(f'=== {target_name} ({len(text)} chars) ===')
                import re
                pngs = re.findall(r'[\w\-]+\.png', text)
                matches_121 = [p for p in pngs if '121' in p or 'drill' in p or 'jiaochang' in p]
                print(f'Matching 121 in {target_name}:', matches_121)
                print(f'Sample PNGs in {target_name}:', pngs[:10])
