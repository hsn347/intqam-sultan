import zipfile, io, os, struct, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
output_dir = 'scratch/dev_icons'
os.makedirs(output_dir, exist_ok=True)

def extract_from_atlas(plist_name_substr, png_name_substr, targets):
    with zipfile.ZipFile(apk_path, 'r') as z:
        full_plist = [n for n in z.namelist() if plist_name_substr in n][0]
        full_png = [n for n in z.namelist() if png_name_substr in n][0]
        
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
                
    extracted = {}
    for target_name in targets:
        target = target_name.encode('ascii')
        idx = plist_data.find(target)
        if idx == -1:
            print(f"Not found: {target_name} in {plist_name_substr}")
            continue
        sub = plist_data[idx:idx+200]
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
            crop = tex.crop((x, y, x+w, y+h))
            
            canvas = Image.new('RGBA', (orig_w, orig_h), (0, 0, 0, 0))
            offset_x = (orig_w - w) // 2
            offset_y = (orig_h - h) // 2
            canvas.paste(crop, (offset_x, offset_y), crop)
            
            out_p = os.path.join(output_dir, target_name)
            canvas.save(out_p)
            print(f"Extracted {target_name}: rect=({x}, {y}, {w}, {h}) -> canvas=({orig_w}, {orig_h})")
            extracted[target_name] = canvas
    return extracted

# 1. MainUIUsed
extract_from_atlas('mainuiused_0.plist.bytes', 'mainuiused_0.png', [
    'icon_building_levelup.png',
    'btn_dailyreward.png',
    'btn_main_pandect_01.png',
    'icon_main_build_01.png',
    'icon_building_gold_speedup.png',
    'icon_building_details.png'
])

# 2. PandectIcon
extract_from_atlas('pandecticon_0.plist.bytes', 'pandecticon_0.png', [
    'icon_pandect_queue.png',
    'icon_pandect_silve_hammer.png',
    'icon_pandect_technology.png',
    'icon_pandect_pet_skill.png',
    'icon_pandect_alchemy.png'
])
