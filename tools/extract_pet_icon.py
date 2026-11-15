import zipfile
import io
import struct
import re
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
plist_name = 'buffui_0.plist.bytes_b7daf42a6ab0d00c35446e7657bd2b7e.bundle'
png_name = 'buffui_0.png_01c77c138984d6c0e3e4918171d2efd3.bundle'

print("Extracting buffui_0...")
with zipfile.ZipFile(apk_path, 'r') as z:
    full_png = [n for n in z.namelist() if 'buffui_0.png' in n][0]
    full_plist = [n for n in z.namelist() if 'buffui_0.plist.bytes' in n][0]
    env_png = UnityPy.load(io.BytesIO(z.read(full_png)))
    tex = None
    for obj in env_png.objects:
        if obj.type.name == 'Texture2D':
            tex = obj.read().image
            break
            
    env_plist = UnityPy.load(io.BytesIO(z.read(full_plist)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break

print("Texture size:", tex.size)
print("Plist length:", len(plist_data))

# Find all entries with pet in plist
pet_entries = re.findall(rb'[a-zA-Z0-9_\-]*pet[a-zA-Z0-9_\-]*\.png', plist_data, re.IGNORECASE)
print("Pet entries in buffui_0:", set(pet_entries))

target = b'icon_build_pet.png'
idx = plist_data.find(target)
print(f"Index of {target}: {idx}")

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
        crop.save('scratch/icon_build_pet_raw.png')
        print("Saved scratch/icon_build_pet_raw.png")
        
        # Save rotation variants
        crop.save('scratch/icon_build_pet_rot_0.png')
        crop.transpose(Image.ROTATE_270).save('scratch/icon_build_pet_rot_90_cw.png')
        crop.transpose(Image.ROTATE_90).save('scratch/icon_build_pet_rot_90_ccw.png')
        crop.transpose(Image.ROTATE_180).save('scratch/icon_build_pet_rot_180.png')
