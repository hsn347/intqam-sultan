import zipfile, io
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

bundle_names = [
    'assets/aa/fgui_assets_fgui/buildmaterialworkshop_fui.bytes_9e9b2d79197d9cabd6a62816b14f4b2d.bundle',
    'assets/aa/fgui_assets_fgui/ccsfiles_buildview_materialfactoryview_fui.bytes_012214e511ef6dfbf4b6ad7dd3661779.bundle',
    'assets/aa/fgui_assets_fgui/increasematerial_fui.bytes_7ce27dae446097a9c1e0d8e2e7ada558.bundle'
]

with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
    for bname in bundle_names:
        print("="*50)
        print("Checking:", bname)
        data = z.read(bname)
        env = UnityPy.load(io.BytesIO(data))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                d = obj.read()
                raw = getattr(d, 'raw_data', None)
                if raw is None: raw = getattr(d, 'bytes', None)
                if raw is None: raw = bytes(d.m_Script, 'raw_unicode_escape')
                name = getattr(d, 'name', getattr(d, 'm_Name', 'unknown'))
                print(f"TextAsset: {name}, size={len(raw)}")
                
                # Check for FairyGUI package header or strings
                import re
                words = re.findall(rb'[a-zA-Z0-9_\-\./\\]+\.(?:png|jpg|xml|fui)', raw)
                print(f"Found {len(words)} assets referenced:")
                for w in set(words):
                    print("  ", w.decode('latin1', errors='ignore'))
