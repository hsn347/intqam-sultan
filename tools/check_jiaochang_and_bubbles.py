import zipfile
import io
import struct
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

# Let's inspect maincityinner_0 for jiaochang.png
bundle_plist = 'assets/aa/atlastp_assets_atlastp/maincity/maincityinner_0.plist.bytes_3f61c29c361eea5b068b7031c6cfc9ee.bundle'
bundle_tex = 'assets/aa/atlastp_assets_atlastp/maincity/maincityinner_0.png_137aa9080359050473f03012feb25fa0.bundle'

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

with zipfile.ZipFile(apk_path, 'r') as z:
    # 1. Read plist
    env_plist = UnityPy.load(io.BytesIO(z.read(bundle_plist)))
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            d = obj.read()
            s = getattr(d, 'm_Script', getattr(d, 'script', ''))
            raw = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break
            
    # 2. Read texture
    env_tex = UnityPy.load(io.BytesIO(z.read(bundle_tex)))
    for obj in env_tex.objects:
        if obj.type.name == 'Texture2D':
            atlas_img = obj.read().image
            break

target = b'jiaochang.png'
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
            
    print("jiaochang ints:", ints)
    print("jiaochang bools:", bools)
    rotated = bools[0] if bools else False
    w, h = ints[0], ints[1]
    x, y = ints[4], ints[5]
    print(f"x={x}, y={y}, w={w}, h={h}, rotated={rotated}")
    if rotated:
        crop = atlas_img.crop((x, y, x + h, y + w))
        crop_cw = crop.rotate(270, expand=True)
        crop_cw.save(f"{art_dir}/jiaochang.png")
    else:
        crop = atlas_img.crop((x, y, x + w, y + h))
        crop.save(f"{art_dir}/jiaochang.png")
    print("Saved jiaochang.png!")
else:
    print("jiaochang.png not found in plist!")
