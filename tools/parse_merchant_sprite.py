import zipfile
import io
import struct
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
plist_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/allianceui_0.plist.bytes_cb596a0f807dd52a725363bcacf93d8c.bundle'
texture_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/allianceui_0.png_f770eca352c920c3b7945cfeb1ddb2af.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            s = getattr(d, 'm_Script', getattr(d, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break
            
    env_tex = UnityPy.load(io.BytesIO(z.read(texture_bundle)))
    for obj in env_tex.objects:
        if obj.type.name == 'Texture2D':
            atlas_img = obj.read().image
            break

target = b'icon_alliance_merchant.png'
idx = raw.find(target)
if idx != -1:
    sub = raw[idx + len(target): idx + len(target) + 120]
    print("Raw chunk after target:", repr(sub))
    
    # decode ints with \x06
    pos = 0
    ints = []
    bools = []
    while pos < len(sub):
        b = sub[pos]
        if b == 0x06 and pos + 5 <= len(sub):
            val = struct.unpack('<i', sub[pos+1:pos+5])[0]
            ints.append((pos, val))
            pos += 5
        elif b == 0x0b and pos + 2 <= len(sub):
            val = bool(sub[pos+1])
            bools.append((pos, val))
            pos += 2
        else:
            pos += 1
            
    print("Ints found:", ints)
    print("Bools found:", bools)
    
    # In this binary plist format:
    # Notice: ints are typically:
    # [orig_w, orig_h, w, h, x, y, frame_w, frame_h] or [w, h, orig_w, orig_h, x, y, ...]
    # Let's inspect the values!
    vals = [val for _, val in ints]
    print("Values:", vals)
    
    # Check if rotated is in bools
    rotated = bools[0][1] if bools else False
    print("Rotated:", rotated)
    
    # Let's check x, y, w, h from vals:
    # 0x7f 0x07 = 1919 ? Let's check hex:
    # 0x5c = 92
    # 0x6d = 109
    # 0x077f = 1919
    # 0x03b4 = 948
    for i, v in enumerate(vals):
        print(f"val[{i}] = {v}")
        
    x = vals[4]
    y = vals[5]
    w = vals[0]
    h = vals[1]
    print(f"Candidate: x={x}, y={y}, w={w}, h={h}, rotated={rotated}")
    
    # If rotated is True: in TexturePacker atlas, w and h are swapped (width=h, height=w)
    if rotated:
        # Atlas width is h, height is w
        box = (x, y, x + h, y + w)
        crop_raw = atlas_img.crop(box)
        crop_raw.save('tools/merchant_box_raw.png')
        # In Cocos2d TexturePacker:
        # rotated = true means CCW 90 in atlas, so clockwise 90 (or 270) to restore
        # Let's save both 270 and 90
        c_cw = crop_raw.rotate(270, expand=True) # 90 deg clockwise
        c_ccw = crop_raw.rotate(90, expand=True) # 90 deg counter-clockwise
        c_cw.save('tools/merchant_cw.png')
        c_ccw.save('tools/merchant_ccw.png')
        print(f"Saved crops! Sizes: raw={crop_raw.size}, cw={c_cw.size}, ccw={c_ccw.size}")
    else:
        box = (x, y, x + w, y + h)
        crop_raw = atlas_img.crop(box)
        crop_raw.save('tools/merchant_unrotated.png')
        print(f"Saved unrotated crop: {crop_raw.size}")

