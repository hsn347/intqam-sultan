import zipfile
import io
import struct
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

plist_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/iconbuilding_0.plist.bytes_7d50261890cd20b93061c2c83e3bd2e7.bundle'
tex_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/iconbuilding_0.png_4ac4a8d8be699c0f25110b65d808475c.bundle'

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

target = b'icon_building_training_finish.png'
idx = raw.find(target)
if idx != -1:
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
            
    name = target.decode('ascii')
    print(f"\n--- {name} ---")
    print("Ints:", ints)
    print("Bools:", bools)
    
    rotated = bools[0] if bools else False
    w, h = ints[0], ints[1]
    x, y = ints[4], ints[5]
    print(f"x={x}, y={y}, w={w}, h={h}, rotated={rotated}")
    
    if rotated:
        crop = atlas.crop((x, y, x + h, y + w))
        crop_cw = crop.rotate(270, expand=True) # 90 CW
        crop_ccw = crop.rotate(90, expand=True) # 90 CCW
        crop_cw.save(f"tools/{name}")
        crop_cw.save(f"{art_dir}/{name}")
        crop_ccw.save(f"tools/{name.replace('.png', '_ccw.png')}")
        clean_img = crop_cw
    else:
        crop = atlas.crop((x, y, x + w, y + h))
        crop.save(f"tools/{name}")
        crop.save(f"{art_dir}/{name}")
        clean_img = crop
        
    print(f"Saved clean {name}: {clean_img.size}")
    
    # Now composite on frame_main_receive.png
    frame = Image.open(f'{art_dir}/frame_main_receive.png').convert('RGBA')
    fw, fh = frame.size
    comp = frame.copy()
    
    iw, ih = int(fw * 0.78), int(fw * 0.78)
    icon_resized = clean_img.resize((iw, ih), Image.Resampling.LANCZOS)
    pos_x = (fw - iw) // 2 + 1
    pos_y = int(fh * 0.44) - (ih // 2)
    comp.paste(icon_resized, (pos_x, pos_y), icon_resized)
    
    comp.save(f"{art_dir}/training_finish_bubble.png")
    
    # Deploy to dashboard
    import os
    os.makedirs('dashboard/public/images/soldiers', exist_ok=True)
    clean_img.save('dashboard/public/images/soldiers/icon_building_training_finish.png')
    clean_img.save('dashboard/public/images/soldiers/training_finish.png')
    comp.save('dashboard/public/images/soldiers/training_finish_bubble.png')
    print("Deployed all training finish variants to frontend & artifact folder!")
