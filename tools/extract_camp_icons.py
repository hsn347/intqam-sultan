import zipfile
import io
import struct
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

plist_bundle = 'assets/aa/atlastp_assets_atlastp/commonui/mainuiused_0.plist.bytes_77a2c2e8479749429e301fcd19799f98.bundle'
tex_bundle = 'assets/aa/atlastp_assets_atlastp/commonui/mainuiused_0.png_dd0ec240536ce8b911a14289e6800c87.bundle'

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

targets = [b'icon_bzjs.png', b'frame_main_receive.png']

for target in targets:
    idx = raw.find(target)
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
    else:
        crop = atlas.crop((x, y, x + w, y + h))
        crop.save(f"tools/{name}")
        crop.save(f"{art_dir}/{name}")
        
    print(f"Saved {name}!")

