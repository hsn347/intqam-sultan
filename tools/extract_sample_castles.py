import zipfile, io, struct, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def extract_from_atlas(plist_name_substr, png_name_substr, sprite_names):
    with zipfile.ZipFile(apk_path, 'r') as z:
        plist_bundle = [n for n in z.namelist() if plist_name_substr in n][0]
        png_bundle = [n for n in z.namelist() if png_name_substr in n][0]
        
        env_png = UnityPy.load(io.BytesIO(z.read(png_bundle)))
        tex = None
        for obj in env_png.objects:
            if obj.type.name == 'Texture2D':
                tex = obj.read().image
                break
                
        env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
        plist_data = None
        for obj in env_plist.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                break
                
    results = {}
    for target_name in sprite_names:
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
            print(f"{target_name}: x={x}, y={y}, w={w}, h={h}, orig=({orig_w}, {orig_h})")
            crop = tex.crop((x, y, x+w, y+h))
            results[target_name] = crop
    return results

# 1. World map castles
res1 = extract_from_atlas('worldmapcastle_0.plist.bytes', 'worldmapcastle_0.png', ['Castle_lv30.png', 'Castle_WarLv5.png', 'Castle_lv10.png'])
for k, im in res1.items():
    im.save(f'scratch/{k}')
    print(f"Saved scratch/{k} size={im.size}")

# 2. MainUIUsed icon_map_mycastle
res2 = extract_from_atlas('mainuiused_0.plist.bytes', 'mainuiused_0.png', ['icon_map_mycastle.png', 'Castle_lv40.png'])
for k, im in res2.items():
    im.save(f'scratch/{k}')
    print(f"Saved scratch/{k} size={im.size}")

# 3. MainCity Inner zhucheng
res3 = extract_from_atlas('maincityinner2_0.plist.bytes', 'maincityinner2_0.png', ['zhucheng.png'])
for k, im in res3.items():
    im.save(f'scratch/{k}')
    print(f"Saved scratch/{k} size={im.size}")
