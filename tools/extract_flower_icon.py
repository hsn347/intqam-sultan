import zipfile
import io
import struct
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
plist_part = 'combtnui2_0.plist.bytes'
png_part = 'combtnui2_0.png'

print("Opening APK and loading assets...")
with zipfile.ZipFile(apk_path, 'r') as z:
    plist_bundle = [n for n in z.namelist() if plist_part in n][0]
    png_bundle = [n for n in z.namelist() if png_part in n][0]
    print(f"Plist bundle: {plist_bundle}")
    print(f"PNG bundle: {png_bundle}")

    env_png = UnityPy.load(io.BytesIO(z.read(png_bundle)))
    texture_img = None
    for obj in env_png.objects:
        if obj.type.name == 'Texture2D':
            texture_img = obj.read().image
            break

    env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break

print(f"Texture loaded: {texture_img.size if texture_img else None}")
print(f"Plist size: {len(plist_data) if plist_data else None}")

# Find btn_flower_enter.png in plist
target_name = b'btn_flower_enter.png'
idx = plist_data.find(target_name)
print(f"Index of {target_name.decode('ascii')}: {idx}")

if idx != -1:
    sub = plist_data[idx:idx+200]
    print("Raw bytes:", sub[:100])
    
    # Parse ints
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
    
    # Check if rotated (byte 0x0b 0x01 or similar)
    # In Cocos/TexturePacker binary plist, boolean rotated is often encoded
    has_rot_true = b'\x0b\x01' in sub[:60]
    has_rot_false = b'\x0b\x00' in sub[:60]
    print(f"Rotated flag check: True={has_rot_true}, False={has_rot_false}")
    
    # Typical TexturePacker structure:
    # ints: [w, h, orig_w, orig_h, x, y, ...] or similar
    # Let's inspect ints carefully
    if len(ints) >= 6:
        w, h, orig_w, orig_h, x, y = ints[0], ints[1], ints[2], ints[3], ints[4], ints[5]
        print(f"Extracted: x={x}, y={y}, w={w}, h={h}, orig=({orig_w}, {orig_h})")
        
        crop = texture_img.crop((x, y, x+w, y+h))
        crop.save('scratch/flower_crop_raw.png')
        print("Saved scratch/flower_crop_raw.png")
        
        # Rotations
        crop.save('scratch/flower_rot_0.png')
        crop.transpose(Image.ROTATE_270).save('scratch/flower_rot_90_cw.png')
        crop.transpose(Image.ROTATE_90).save('scratch/flower_rot_90_ccw.png')
        crop.transpose(Image.ROTATE_180).save('scratch/flower_rot_180.png')
        print("Saved rotation variants to scratch/")
