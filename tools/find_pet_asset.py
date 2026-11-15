import zipfile
import glob
import os

apks = glob.glob('game_file/apk_packages/*.apk')
print("Found APKs:", apks)

for apk in apks:
    print(f"\nSearching in {apk}...")
    with zipfile.ZipFile(apk, 'r') as z:
        names = z.namelist()
        for n in names:
            if 'pet' in n.lower() or 'build' in n.lower():
                # Let's check if it's a bundle or file
                pass
        
        # Search inside bundle files or names for icon_build_pet
        pet_bundles = [n for n in names if 'pet' in n.lower()]
        if pet_bundles:
            print(f"Bundles with 'pet' in filename ({len(pet_bundles)}):")
            for pb in pet_bundles[:10]:
                print("  ", pb)
                
# Also search inside plist bundles in split_UnityDataAssetPack.apk
apk_unity = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
if os.path.exists(apk_unity):
    with zipfile.ZipFile(apk_unity, 'r') as z:
        plist_bundles = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
        print(f"\nSearching {len(plist_bundles)} plist bundles for icon_build_pet.png...")
        for pb in plist_bundles:
            data = z.read(pb)
            if b'icon_build_pet' in data:
                print(f"FOUND icon_build_pet in plist bundle: {pb}")
            if b'pet' in data.lower():
                # check exact matches
                pass
