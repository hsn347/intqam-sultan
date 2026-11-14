import zipfile
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = '2020.3.0f1'

apk_path = r'e:\intqam-sultan\game_file\apk_packages\split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if 'commandhall' in name.lower():
            try:
                bundle_bytes = z.read(name)
                env = UnityPy.load(bundle_bytes)
                for obj in env.objects:
                    if obj.type.name in ('Texture2D', 'Sprite', 'TextAsset'):
                        data = obj.read()
                        obj_name = getattr(data, 'name', 'unnamed')
                        print(f'{name} -> {obj.type.name}: {obj_name}')
                        if obj.type.name == 'TextAsset':
                            text = getattr(data, 'text', '')
                            if 'img_commandhall_entrance' in text:
                                print('  --> FOUND img_commandhall_entrance in plist!')
                        if obj.type.name == 'Texture2D':
                            print(f'  Texture size: {data.image.size}')
            except Exception as e:
                print('Error reading', name, ':', e)
