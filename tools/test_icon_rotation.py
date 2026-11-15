import zipfile
import io
import struct
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def parse_plist_and_texture(apk_z, png_bundle_name, plist_bundle_name):
    env_png = UnityPy.load(io.BytesIO(apk_z.read(png_bundle_name)))
    tex = None
    for obj in env_png.objects:
        if obj.type.name == 'Texture2D':
            tex = obj.read().image
            break
            
    env_plist = UnityPy.load(io.BytesIO(apk_z.read(plist_bundle_name)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break
    return tex, plist_data

with zipfile.ZipFile(apk_path, 'r') as z:
    icon_png = [n for n in z.namelist() if 'armyicon_0.png' in n][0]
    icon_plist = [n for n in z.namelist() if 'armyicon_0.plist.bytes' in n][0]
    tex_icon, plist_icon = parse_plist_and_texture(z, icon_png, icon_plist)

# In armyicon_s_401: x=108, y=1243, w=99, h=101
crop_raw = tex_icon.crop((108, 1243, 108 + 101, 1243 + 99))
r_cw = crop_raw.transpose(Image.ROTATE_270)
r_cw.save('scratch/soldiers/icon_401_cw.png')
print("Saved icon_401_cw.png", r_cw.size)
