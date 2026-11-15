import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plist bundles to check: {len(all_plists)}")
    
    found = []
    for i, p in enumerate(all_plists):
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    if b'icon_alliance_merchant' in raw:
                        print(f"\n>>> FOUND icon_alliance_merchant in {p} (TextAsset: {data.m_Name})!")
                        found.append((p, 'icon_alliance_merchant', data.m_Name))
                    if b'icon_alliance_reinforce' in raw:
                        print(f"\n>>> FOUND icon_alliance_reinforce in {p} (TextAsset: {data.m_Name})!")
                        found.append((p, 'icon_alliance_reinforce', data.m_Name))
        except Exception as e:
            pass
        if (i + 1) % 100 == 0:
            print(f"Checked {i+1}/{len(all_plists)}...")

print(f"\nSearch complete. Total matches: {len(found)}")
for m in found:
    print(m)
