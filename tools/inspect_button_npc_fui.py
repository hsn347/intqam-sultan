import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    b = [n for n in z.namelist() if 'ccsfiles_mainui_fui.bytes' in n][0]
    env = UnityPy.load(io.BytesIO(z.read(b)))
    for obj in env.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            print("--- Snippet around Button_npc ---")
            idx = raw.find(b'Button_npc')
            print(raw[max(0, idx-200):min(len(raw), idx+300)])
