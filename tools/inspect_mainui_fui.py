import zipfile
import io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def inspect_fui_bundle(bundle_name):
    with zipfile.ZipFile(apk_path, 'r') as z:
        matches = [n for n in z.namelist() if bundle_name in n]
        if not matches:
            print("Not found:", bundle_name)
            return
        b = matches[0]
        env = UnityPy.load(io.BytesIO(z.read(b)))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                print(f"\n--- {bundle_name} (len={len(raw)}) ---")
                
                # Check for Button_quest or questGuideNode
                for term in [b'Button_quest', b'questGuideNode', b'Button_npc', b'quest']:
                    idx = 0
                    while True:
                        idx = raw.find(term, idx)
                        if idx == -1: break
                        print(f"Found {term.decode('ascii')} at {idx}:")
                        snippet = raw[max(0, idx-100):min(len(raw), idx+150)]
                        print("  ", snippet)
                        idx += len(term)

inspect_fui_bundle('mainui_fui.bytes_e15955db2c13733d88082e6f5aa942b6.bundle')
inspect_fui_bundle('ccsfiles_mainui_fui.bytes_83ed2ab4394031226f881eec41d8ce2b.bundle')
