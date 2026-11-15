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
    os.makedirs('scratch/soldiers', exist_ok=True)
    os.makedirs('dashboard/public/images/soldiers', exist_ok=True)

    with zipfile.ZipFile(apk_path, 'r') as z:
        # 1. armyicon_0 (small circular avatar icons)
        icon_png = [n for n in z.namelist() if 'armyicon_0.png' in n][0]
        icon_plist = [n for n in z.namelist() if 'armyicon_0.plist.bytes' in n][0]
        tex_icon, plist_icon = parse_plist_and_texture(z, icon_png, icon_plist)

        for sid in ['401', '402', '403', '404', '405']:
            name = f"armyicon_s_{sid}.png"
            res = crop_sprite(tex_icon, plist_icon, name)
            if res:
                res[0].save(f'scratch/soldiers/{name}')
                res[0].save(f'dashboard/public/images/soldiers/{name}')
                print(f"Saved {name} -> size: {res[0].size}")

        # 2. soldiersui1_0 (full standing soldier illustrations)
        ui1_png = [n for n in z.namelist() if 'soldiersui1_0.png' in n][0]
        ui1_plist = [n for n in z.namelist() if 'soldiersui1_0.plist.bytes' in n][0]
        tex_ui1, plist_ui1 = parse_plist_and_texture(z, ui1_png, ui1_plist)

        for sid in ['401', '402', '403', '404', '405']:
            name = f"armyicon_b_{sid}.png"
            res = crop_sprite(tex_ui1, plist_ui1, name)
            if res:
                res[0].save(f'scratch/soldiers/{name}')
                res[0].save(f'dashboard/public/images/soldiers/{name}')
                print(f"Saved {name} -> size: {res[0].size}")

if __name__ == '__main__':
    main()
