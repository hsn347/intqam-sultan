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
    ui1_png = [n for n in z.namelist() if 'soldiersui1_0.png' in n][0]
    ui1_plist = [n for n in z.namelist() if 'soldiersui1_0.plist.bytes' in n][0]
    tex_ui1, plist_ui1 = parse_plist_and_texture(z, ui1_png, ui1_plist)

# In 401: ints was:
# w=252, h=469, orig_w=520, orig_h=550, x=475, y=399
# If rotated in atlas, on the atlas texture it occupies width=h (469) and height=w (252)!
# Let's crop (475, 399, 475 + 469, 399 + 252)
crop_raw = tex_ui1.crop((475, 399, 475 + 469, 399 + 252))
crop_raw.save('scratch/soldiers/401_raw_swap.png')

# Now let's try rotations:
# TexturePacker rotated sprites are usually rotated 90 degrees CCW (or CW).
# If we rotate 90 degrees counter-clockwise (or clockwise):
r_cw = crop_raw.transpose(Image.ROTATE_270) # 90 deg clockwise
r_ccw = crop_raw.transpose(Image.ROTATE_90) # 90 deg counter-clockwise

r_cw.save('scratch/soldiers/401_cw.png')
r_ccw.save('scratch/soldiers/401_ccw.png')
print("Saved raw swap, cw, ccw")
