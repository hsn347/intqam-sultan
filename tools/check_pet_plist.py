import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def check_plist(bundle_name):
    with zipfile.ZipFile(apk_path, 'r') as z:
        matches = [n for n in z.namelist() if bundle_name in n]
        if not matches:
            print(f"Bundle not found: {bundle_name}")
            return
        b = matches[0]
        env = UnityPy.load(io.BytesIO(z.read(b)))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                print(f"\n--- {bundle_name} ---")
                if b'icon_build_pet' in raw:
                    print(f"FOUND icon_build_pet in {b}!")
                    idx = raw.find(b'icon_build_pet')
                    print("Context:", raw[max(0, idx-20):min(len(raw), idx+120)])
                if b'pet' in raw.lower():
                    # find all occurrences of pet
                    import re
                    pets = re.findall(rb'[a-zA-Z0-9_\-]*pet[a-zA-Z0-9_\-]*\.png', raw, re.IGNORECASE)
                    print(f"Pet matches in {bundle_name}:", set(pets))

check_plist('buildicon_0.plist.bytes')
check_plist('questicon_0.plist.bytes')
check_plist('peticon_0.plist.bytes')
check_plist('petcardicon_0.plist.bytes')
