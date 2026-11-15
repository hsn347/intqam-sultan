import zipfile
import io
import struct
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
plist_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/iconbuilding_0.plist.bytes_7d50261890cd20b93061c2c83e3bd2e7.bundle'
texture_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/iconbuilding_0.png_4ac4a8d8be699c0f25110b65d808475c.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    # 1. Read plist
    env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            s = getattr(d, 'm_Script', getattr(d, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break
            
    # 2. Read texture
    env_tex = UnityPy.load(io.BytesIO(z.read(texture_bundle)))
    for obj in env_tex.objects:
        if obj.type.name == 'Texture2D':
            atlas_img = obj.read().image
            break

print(f"Atlas size: {atlas_img.size}")

targets = [
    'icon_building_up_food.png',
    'icon_building_up_wood.png',
    'icon_building_up_iron.png',
    'icon_building_up_silver.png',
    'icon_building_up_crystal.png'
]

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

for target in targets:
    idx = raw.find(target.encode('ascii'))
    if idx == -1:
        print(f"Target not found: {target}")
        continue
    sub = raw[idx + len(target): idx + len(target) + 120]
    
    pos = 0
    ints = []
    bools = []
    while pos < len(sub):
        b = sub[pos]
        if b == 0x06 and pos + 5 <= len(sub):
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        elif b == 0x0b and pos + 2 <= len(sub):
            val = bool(sub[pos+1])
            bools.append(val)
            pos += 2
        else:
            pos += 1
            
    print(f"\n--- {target} ---")
    print("Ints:", ints)
    print("Bools:", bools)
    
    rotated = bools[0] if bools else False
    w, h = ints[0], ints[1]
    x, y = ints[4], ints[5]
    print(f"x={x}, y={y}, w={w}, h={h}, rotated={rotated}")
    
    if rotated:
        box = (x, y, x + h, y + w)
        crop = atlas_img.crop(box)
        crop_cw = crop.rotate(270, expand=True) # 90 CW
        crop_ccw = crop.rotate(90, expand=True) # 90 CCW
        
        # Save both
        crop_cw.save(f"{art_dir}/{target.replace('.png', '_cw.png')}")
        crop_ccw.save(f"{art_dir}/{target.replace('.png', '_ccw.png')}")
        crop_cw.save(f"{art_dir}/{target}")
        crop.save(f"tools/{target.replace('.png', '_raw.png')}")
        print(f"Saved rotated crops for {target}")
    else:
        box = (x, y, x + w, y + h)
        crop = atlas_img.crop(box)
        crop.save(f"{art_dir}/{target}")
        print(f"Saved unrotated crop for {target}: size {crop.size}")

