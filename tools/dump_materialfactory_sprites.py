import zipfile, io, struct, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

plist_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/materialfactory_0.plist.bytes_f810ea93d25dcf8e31e7b0fa260a5c52.bundle'
tex_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/materialfactory_0.png_fd9fe6d8129da57cae2e8bd0873eed9e.bundle'

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

import re
matches = list(re.finditer(rb'([a-zA-Z0-9_\-]+\.png)', raw))
for m in matches:
    name = m.group(1).decode('ascii')
    idx = m.end()
    sub = raw[idx: idx + 120]
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
    if len(ints) >= 6:
        w, h = ints[0], ints[1]
        x, y = ints[4], ints[5]
        rotated = bools[0] if bools else False
        if rotated:
            crop = atlas.crop((x, y, x + h, y + w)).rotate(270, expand=True)
        else:
            crop = atlas.crop((x, y, x + w, y + h))
        crop.save(f"tools/{name}")
        crop.save(f"{art_dir}/{name}")
        print(f"Saved {name}: {crop.size}, rotated={rotated}")
