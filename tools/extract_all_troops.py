import zipfile
import io
import struct
import os
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

def crop_sprite(tex, plist_data, target_name):
    target = target_name.encode('ascii')
    idx = plist_data.find(target)
    if idx == -1:
        print(f"Not found: {target_name}")
        return None
    sub = plist_data[idx:idx+250]
    
    # Check rotated flag
    b_idx = sub.find(b'\x0b')
    rotated = False
    if b_idx != -1 and b_idx + 1 < len(sub):
        rotated = (sub[b_idx + 1] == 1)
        
    ints = []
    pos = 0
    while pos < len(sub) - 5:
        if sub[pos] == 0x06:
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        else:
            pos += 1
            
    if len(ints) >= 6:
        w, h, orig_w, orig_h, x, y = ints[0], ints[1], ints[2], ints[3], ints[4], ints[5]
        print(f"{target_name}: x={x}, y={y}, w={w}, h={h}, orig=({orig_w}, {orig_h}), rotated={rotated}")
        
        if rotated:
            crop = tex.crop((x, y, x + h, y + w))
            crop = crop.transpose(Image.ROTATE_270)
        else:
            crop = tex.crop((x, y, x + w, y + h))
            
        return crop, (w, h, orig_w, orig_h, x, y, rotated)
        
    print(f"Insufficient ints for {target_name}: {ints}")
    return None

def main():
    target_dir = 'dashboard/public/images/soldiers'
    scratch_dir = 'scratch/soldiers'
    os.makedirs(target_dir, exist_ok=True)
    os.makedirs(scratch_dir, exist_ok=True)

    with zipfile.ZipFile(apk_path, 'r') as z:
        # 1. armyicon_0 (small icons for 401, 501, 601, 701)
        icon_png = [n for n in z.namelist() if 'armyicon_0.png' in n][0]
        icon_plist = [n for n in z.namelist() if 'armyicon_0.plist.bytes' in n][0]
        tex_icon, plist_icon = parse_plist_and_texture(z, icon_png, icon_plist)

        for sid in ['401', '501', '601', '701']:
            name = f"armyicon_s_{sid}.png"
            res = crop_sprite(tex_icon, plist_icon, name)
            if res:
                res[0].save(os.path.join(scratch_dir, name))
                res[0].save(os.path.join(target_dir, name))
                print(f"Saved {name} -> size: {res[0].size}")

        # 2. soldiersui1..4 for large body illustrations
        bundle_map = {
            '401': ('soldiersui1_0.png', 'soldiersui1_0.plist.bytes'),
            '501': ('soldiersui2_0.png', 'soldiersui2_0.plist.bytes'),
            '601': ('soldiersui3_0.png', 'soldiersui3_0.plist.bytes'),
            '701': ('soldiersui4_0.png', 'soldiersui4_0.plist.bytes'),
        }

        for sid, (png_pat, plist_pat) in bundle_map.items():
            png_bundle = [n for n in z.namelist() if png_pat in n][0]
            plist_bundle = [n for n in z.namelist() if plist_pat in n][0]
            tex, plist_data = parse_plist_and_texture(z, png_bundle, plist_bundle)
            name = f"armyicon_b_{sid}.png"
            res = crop_sprite(tex, plist_data, name)
            if res:
                res[0].save(os.path.join(scratch_dir, name))
                res[0].save(os.path.join(target_dir, name))
                print(f"Saved {name} -> size: {res[0].size}")

if __name__ == '__main__':
    main()
