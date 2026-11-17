import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = '2022.3.62f2'

targets = {
    'lord': 'lordskill_0.plist.bytes',
    'hero': 'skillicon_0.plist.bytes',
    'stun': 'stunskillicon_0.plist.bytes',
    'beast': 'divinebeast_0.plist.bytes'
}

with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
    for category, pattern in targets.items():
        bundle_names = [n for n in z.namelist() if pattern in n]
        if not bundle_names:
            print(f'Missing {category}')
            continue
        data = z.read(bundle_names[0])
        env = UnityPy.load(io.BytesIO(data))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                s = getattr(obj.read(), 'm_Script', getattr(obj.read(), 'script', ''))
                text = s if isinstance(s, str) else bytes(s).decode('latin1', errors='ignore')
                pngs = re.findall(r'[\w\-]+\.png', text)
                # Filter out the atlas texture itself (e.g. lordSkill_0.png)
                sprites = [p for p in pngs if not p.lower().endswith('_0.png')]
                print(f'=== Category: {category} ({len(sprites)} sprites in {pattern}) ===')
                print(sprites[:15])
