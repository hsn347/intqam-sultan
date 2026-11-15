import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    all_plists = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
    print(f"Total plist bundles: {len(all_plists)}")
    
    for i, p in enumerate(all_plists):
        # Read raw bundle bytes to see if 'icon_build_pet' is present
        data = z.read(p)
        if b'icon_build_pet' in data:
            print(f"Raw match icon_build_pet in {p}")
        if b'quest_type_pet' in data:
            print(f"Raw match quest_type_pet in {p}")

print("Raw scan complete.")
