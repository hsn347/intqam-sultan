import zipfile, io, os, struct, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with zipfile.ZipFile(apk_path, 'r') as z:
    full_plist = [n for n in z.namelist() if 'mainuiused_0.plist.bytes' in n][0]
    full_png = [n for n in z.namelist() if 'mainuiused_0.png' in n][0]
    
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

def extract_one(target_name):
    target = target_name.encode('ascii')
    idx = plist_data.find(target)
    if idx == -1: return None
    sub = plist_data[idx:idx+200]
    ints = []
    pos = 0
    while pos < len(sub) - 5:
        if sub[pos] == 0x06:
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append(val)
            pos += 5
        else: pos += 1
    if len(ints) >= 6:
        w, h, orig_w, orig_h, x, y = ints[0], ints[1], ints[2], ints[3], ints[4], ints[5]
        crop = tex.crop((x, y, x+w, y+h))
        crop.save(f'scratch/dev_icons/{target_name}')
        print(f"Extracted {target_name}: {w}x{h}")
        return crop
    return None

extract_one('frame_main_build_03.png')
extract_one('frame_main_building2.png')
extract_one('frame_main_building_green.png')
extract_one('icon_building_star_06.png')
extract_one('icon_building_gold_speedup.png')
extract_one('icon_building_levelup.png')
