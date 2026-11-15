import zipfile, io, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = '2022.3.62f2'
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
bundle_name = 'assets/aa/spine_assets_spine/eft_jiaochang_byzantine_skeletondata.asset_332089d803aa0af6be054b9a69fda19e.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    env = UnityPy.load(io.BytesIO(z.read(bundle_name)))
    for obj in env.objects:
        if obj.type.name == 'Texture2D':
            img = obj.read().image
            img.save('tools/eft_jiaochang_byzantine.png')
            print('Saved Texture2D size:', img.size)
        elif obj.type.name == 'TextAsset':
            d = obj.read()
            if d.m_Name == 'eft_jiaochang_byzantine.atlas':
                s = getattr(d, 'm_Script', getattr(d, 'script', ''))
                raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                with open('tools/eft_jiaochang_byzantine.atlas', 'wb') as fp:
                    fp.write(raw)
                print('Saved atlas text!')
