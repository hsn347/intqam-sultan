import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

targets = [
    b'armyicon_b_401.png',
    b'armyicon_b_501.png',
    b'armyicon_b_601.png',
    b'armyicon_b_701.png',
    b'armyicon_s_401.png',
    b'armyicon_s_501.png',
    b'armyicon_s_601.png',
    b'armyicon_s_701.png',
]

with zipfile.ZipFile(apk_path, 'r') as z:
    plist_files = [n for n in z.namelist() if n.endswith('.plist.bytes') or '.plist.bytes_' in n]
    print(f"Found {len(plist_files)} plist files.")
    
    for pf in plist_files:
        try:
            env = UnityPy.load(io.BytesIO(z.read(pf)))
            for obj in env.objects:
                if obj.type.name == 'TextAsset':
                    data = obj.read()
                    s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                    b = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                    for t in targets:
                        if t in b:
                            print(f"{t.decode('ascii')} found in {pf}")
        except Exception as e:
            pass
