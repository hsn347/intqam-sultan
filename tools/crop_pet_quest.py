import zipfile
import io
import struct
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    plist_b = [n for n in z.namelist() if 'questicon_0.plist.bytes' in n][0]
    png_b = [n for n in z.namelist() if 'questicon_0.png' in n][0]
    
    env_png = UnityPy.load(io.BytesIO(z.read(png_b)))
    tex = None
    for obj in env_png.objects:
        if obj.type.name == 'Texture2D':
            tex = obj.read().image
            break
            
    env_plist = UnityPy.load(io.BytesIO(z.read(plist_b)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break

target_name = b'quest_type_pet_01.png'
idx = plist_data.find(target_name)
print(f"Index of {target_name}: {idx}")

if idx != -1:
    sub = plist_data[idx:idx+200]
    print("Raw bytes:", sub[:100])
    
    ints = []
    pos = 0
    while pos < len(sub) - 5:
        if sub[pos] == 0x06:
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        else:
            pos += 1
    print("Parsed ints:", ints)
    
    has_rot_true = b'\x0b\x01' in sub[:60]
    has_rot_false = b'\x0b\x00' in sub[:60]
    print(f"Rotated flag check: True={has_rot_true}, False={has_rot_false}")
    
    if len(ints) >= 6:
        w, h, orig_w, orig_h, x, y = ints[0], ints[1], ints[2], ints[3], ints[4], ints[5]
        print(f"Crop coords: x={x}, y={y}, w={w}, h={h}, orig=({orig_w}, {orig_h})")
        crop = tex.crop((x, y, x+w, y+h))
        crop.save('scratch/crop_quest_type_pet_01.png')
        print("Saved scratch/crop_quest_type_pet_01.png")
