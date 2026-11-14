import zipfile
import io
import struct
import re
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

def extract_bundle(apk_path, plist_part, png_part):
    with zipfile.ZipFile(apk_path, 'r') as z:
        plist_bundle = [n for n in z.namelist() if plist_part in n][0]
        png_bundle = [n for n in z.namelist() if png_part in n][0]
        
        # Texture
        env_png = UnityPy.load(io.BytesIO(z.read(png_bundle)))
        texture_img = None
        for obj in env_png.objects:
            if obj.type.name == 'Texture2D':
                texture_img = obj.read().image
                break
                
        # Plist
        env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
        plist_data = None
        for obj in env_plist.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                break
                
        return texture_img, plist_data

def parse_and_crop(texture_img, plist_data, target_name):
    target = target_name.encode('ascii')
    idx = plist_data.find(target)
    if idx == -1:
        print(f'{target_name} not found in plist')
        return None
    sub = plist_data[idx:idx+150]
    
    # parse ints
    ints = []
    pos = 0
    while pos < len(sub) - 5:
        if sub[pos] == 0x06:
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        else:
            pos += 1
    print(f'{target_name} ints:', ints)
    if len(ints) >= 8:
        w, h, orig_w, orig_h, x, y = ints[0], ints[1], ints[2], ints[3], ints[4], ints[5]
        print(f'Crop coords: x={x}, y={y}, w={w}, h={h}, orig=({orig_w}, {orig_h})')
        crop = texture_img.crop((x, y, x+w, y+h))
        return crop, (orig_w, orig_h)
    return None

# 1. buildicon_0 -> icon_build_121.png
tex_build, plist_build = extract_bundle('game_file/apk_packages/split_UnityDataAssetPack.apk', 'buildicon_0.plist.bytes', 'buildicon_0.png_')
crop_b121, orig_b121 = parse_and_crop(tex_build, plist_build, 'icon_build_121.png')
if crop_b121:
    crop_b121.save('scratch/icon_build_121.png')
    print('Saved scratch/icon_build_121.png')

# 2. iconbuilding_0 -> icon_building_arena.png
tex_ib, plist_ib = extract_bundle('game_file/apk_packages/split_UnityDataAssetPack.apk', 'iconbuilding_0.plist.bytes', 'iconbuilding_0.png_')
crop_arena, orig_arena = parse_and_crop(tex_ib, plist_ib, 'icon_building_arena.png')
if crop_arena:
    crop_arena.save('scratch/icon_building_arena.png')
    print('Saved scratch/icon_building_arena.png')
