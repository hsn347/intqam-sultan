import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

def search_apk(apk_path, query_bytes):
    print(f"Scanning {apk_path} for {query_bytes}...")
    found_bundles = []
    with zipfile.ZipFile(apk_path, 'r') as z:
        bundles = [n for n in z.namelist() if n.endswith('.bundle') and 'plist' in n]
        print(f"Total plist bundles in {apk_path}: {len(bundles)}")
        for b in bundles:
            try:
                env = UnityPy.load(io.BytesIO(z.read(b)))
                for obj in env.objects:
                    if obj.type.name == 'TextAsset':
                        data = obj.read()
                        s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                        raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                        if query_bytes in raw:
                            print(f"FOUND in bundle: {b}")
                            found_bundles.append((b, raw))
            except Exception as e:
                pass
    return found_bundles

search_apk('game_file/apk_packages/split_UnityDataAssetPack.apk', b'icon_build_pet')
