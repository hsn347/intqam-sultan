import zipfile, io, struct, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

plist_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/equipmentui_0.plist.bytes_03638132f6d12baba4726749cf0d1285.bundle'
tex_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/equipmentui_0.png_90ef26536604903f144c4302167261b9.bundle'

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

with zipfile.ZipFile(apk_path, 'r') as z:
    env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            s = getattr(d, 'm_Script', getattr(d, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break
            
    env_tex = UnityPy.load(io.BytesIO(z.read(tex_bundle)))
    for obj in env_tex.objects:
        if obj.type.name == 'Texture2D':
            atlas = obj.read().image
            break

print(f"Atlas size: {atlas.size}")

material_map = {
    '2001.png': ('material_herb', 'عشب'),
    '2002.png': ('material_purple_wood', 'خشب بنفسجي'),
    '2003.png': ('material_bronze', 'برونز'),
    '2004.png': ('material_ruby', 'ياقوت'),
    '2005.png': ('material_fur', 'فرو'),
    '2006.png': ('material_horn', 'قرن'),
}

# Load circular base frame
tbk2 = Image.open(f'{art_dir}/frame_gfyh_tbk2.png').convert('RGBA')
fw, fh = tbk2.size

for target_file, (tag, ar_name) in material_map.items():
    target_bytes = target_file.encode('ascii')
    idx = raw.find(target_bytes)
    if idx == -1:
        print(f"Target not found: {target_file}")
        continue
    sub = raw[idx + len(target_bytes): idx + len(target_bytes) + 120]
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
            
    rotated = bools[0] if bools else False
    w, h = ints[0], ints[1]
    x, y = ints[4], ints[5]
    print(f"\n--- {target_file} ({ar_name}) ---")
    print(f"x={x}, y={y}, w={w}, h={h}, rotated={rotated}")
    
    if rotated:
        crop = atlas.crop((x, y, x + h, y + w))
        # Cocos2d CCW 90 -> restore with 90 CW (270)
        clean_img = crop.rotate(270, expand=True)
        # Also save CCW for checking
        crop.rotate(90, expand=True).save(f"{art_dir}/{tag}_ccw.png")
    else:
        clean_img = atlas.crop((x, y, x + w, y + h))
        
    # Save clean
    clean_img.save(f"{art_dir}/{tag}_clean.png")
    clean_img.save(f"tools/{target_file}")
    
    # Composite on tbk2
    comp = tbk2.copy()
    # scale clean_img to fit nicely in disc (~65% of circle)
    iw = int(fw * 0.65)
    aspect = clean_img.height / clean_img.width
    ih = int(iw * aspect)
    resized = clean_img.resize((iw, ih), Image.Resampling.LANCZOS)
    
    px = (fw - iw) // 2
    py = (fh - ih) // 2
    comp.paste(resized, (px, py), resized)
    comp.save(f"{art_dir}/{tag}_btn.png")
    
    print(f"Saved {tag}_clean.png ({clean_img.size}) and {tag}_btn.png ({comp.size})")

print("\nDone extracting all materials!")
