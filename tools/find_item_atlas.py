import zipfile, io, re, UnityPy
UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

# Let's inspect what atlas or bundle names exist in split_UnityDataAssetPack.apk
with zipfile.ZipFile(apk_path, 'r') as z:
    all_bundles = [n for n in z.namelist() if n.endswith('.bundle')]
    print(f"Total bundles in UnityDataAssetPack: {len(all_bundles)}")
    
    # Categorize bundles by path prefix
    prefixes = {}
    for b in all_bundles:
        parts = b.split('/')
        cat = '/'.join(parts[:3])
        prefixes[cat] = prefixes.get(cat, 0) + 1
    
    print("\nBundle categories:")
    for cat, count in sorted(prefixes.items(), key=lambda x: -x[1]):
        print(f"  {cat}: {count}")
