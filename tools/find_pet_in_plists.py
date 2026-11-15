import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    
    # Priority folders: singlemodule, normalui, commonui, maincity, resident
    priority = [p for p in all_plists if any(k in p for k in ['singlemodule', 'normalui', 'commonui', 'maincity', 'resident'])]
    print(f"Priority plists to check: {len(priority)}")
    
    found = False
    for i, p in enumerate(priority):
        try:
            env = UnityPy.load(io.BytesIO(z.read(p)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    if b'icon_build_pet' in raw:
                        print(f"\n>>> FOUND icon_build_pet in {p}!")
                        found = True
                    if b'pet_book' in raw:
                        print(f"\n>>> FOUND pet_book in {p}!")
                        found = True
        except Exception:
            pass
        if (i + 1) % 100 == 0:
            print(f"Checked {i+1}/{len(priority)}...")
        if found:
            break
