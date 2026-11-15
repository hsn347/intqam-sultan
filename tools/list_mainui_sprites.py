import zipfile
import io
import re
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def list_sprites(bundle_partial):
    with zipfile.ZipFile(apk_path, 'r') as z:
        matches = [n for n in z.namelist() if bundle_partial in n and 'plist' in n]
        if not matches:
            print(f"Not found: {bundle_partial}")
            return
        b = matches[0]
        env = UnityPy.load(io.BytesIO(z.read(b)))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                names = re.findall(rb'[a-zA-Z0-9_\-]+\.png', raw)
                clean_names = sorted(set(n.decode('ascii', errors='ignore') for n in names))
                print(f"\n--- {bundle_partial} ({len(clean_names)} sprites) ---")
                for cn in clean_names:
                    if any(k in cn.lower() for k in ['quest', 'task', 'btn', 'daily', 'scroll', 'book', 'fdj', 'search', 'target']):
                        print("  *", cn)
                    else:
                        pass
                print("All sprites count:", len(clean_names))
                # Also print first 20 sprites
                print("Sample sprites:", clean_names[:15])

list_sprites('mainuiicon_0')
list_sprites('mainuiused_0')
list_sprites('commainui_0')
