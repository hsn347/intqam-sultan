import zipfile
import io
import struct
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    full_plist = [n for n in z.namelist() if 'soldiersui1_0.plist.bytes' in n][0]
    env_plist = UnityPy.load(io.BytesIO(z.read(full_plist)))
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            b = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            idx = b.find(b'armyicon_b_401.png')
            print('RAW CHUNK 401:', b[idx:idx+250])
            break

# Also check the image sizes and bounds of saved scratch/soldiers images
import os
for f in os.listdir('scratch/soldiers'):
    im = Image.open(f'scratch/soldiers/{f}')
    print(f, im.size, im.mode)
