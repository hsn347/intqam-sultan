import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

targets = [
    b'icon_building_up_food',
    b'icon_building_up_wood',
    b'icon_building_up_iron',
    b'icon_building_up_silver',
    b'icon_building_up_crystal'
]

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plist bundles: {len(all_plists)}")
    
    matches = {}
    for p in all_plists:
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    d = obj.read()
                    s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    for t in targets:
                        if t in raw:
                            if t.decode('ascii') not in matches:
                                matches[t.decode('ascii')] = []
                            matches[t.decode('ascii')].append((p, d.m_Name))
                            print(f"Found {t.decode('ascii')} in {p} ({d.m_Name})")
        except Exception:
            pass

print("\n--- Summary of matches ---")
for k, v in matches.items():
    print(k, v)
