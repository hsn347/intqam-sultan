import zipfile
import io
import re
import plistlib
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
plist_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/allianceui_0.plist.bytes_cb596a0f807dd52a725363bcacf93d8c.bundle'
texture_bundle = 'assets/aa/atlastp_assets_atlastp/singlemodule/allianceui_0.png_f770eca352c920c3b7945cfeb1ddb2af.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    # 1. Read plist
    env_plist = UnityPy.load(io.BytesIO(z.read(plist_bundle)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == 'TextAsset':
            data = obj.read()
            s = getattr(data, 'm_Script', getattr(data, 'script', ''))
            plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
            break
            
    print(f"Plist data size: {len(plist_data) if plist_data else 0}")
    
    # Try parsing plist
    try:
        pl = plistlib.loads(plist_data)
        frames = pl.get('frames', {})
        print(f"Total frames in plist: {len(frames)}")
    except Exception as e:
        print(f"Plistlib loads error: {e}")
        # Search raw
        pl = None

    # Let's inspect icon_alliance_merchant in frames
    for k in ['icon_alliance_merchant.png', 'icon_alliance_reinforce.png']:
        if pl and k in frames:
            print(f"Frame info for {k}:", frames[k])
        else:
            print(f"{k} not directly in frames dict keys")

    # 2. Read texture
    env_tex = UnityPy.load(io.BytesIO(z.read(texture_bundle)))
    atlas_img = None
    for obj in env_tex.objects:
        if obj.type.name == 'Texture2D':
            atlas_img = obj.read().image
            print(f"Found Texture2D: {atlas_img.size}, mode: {atlas_img.mode}")
            break

    if pl and 'icon_alliance_merchant.png' in frames and atlas_img:
        info = frames['icon_alliance_merchant.png']
        # parse frame
        # plist format can be {{x,y},{w,h}} or rect
        frame_str = info.get('frame')
        rotated = info.get('rotated', False)
        print(f"frame_str: {frame_str}, rotated: {rotated}")
        
        # parse {{x, y}, {w, h}}
        nums = [int(n) for n in re.findall(r'-?\d+', frame_str)]
        x, y, w, h = nums[0], nums[1], nums[2], nums[3]
        print(f"Parsed: x={x}, y={y}, w={w}, h={h}, rotated={rotated}")
        
        if rotated:
            # When rotated=True in Cocos/TexturePacker, w and h are swapped in the atlas!
            # The sprite is rotated 90 degrees CCW (or CW depending on convention).
            # In TexturePacker: width in atlas is h, height in atlas is w
            box = (x, y, x + h, y + w)
            cropped = atlas_img.crop(box)
            # rotate back 90 degrees clockwise or 270
            # Cocos2d convention: rotated=True means stored rotated 90 deg CCW in sheet, so rotate 270 (or 90 CW) to restore
            # Let's save both versions
            r90 = cropped.rotate(90, expand=True)
            r270 = cropped.rotate(270, expand=True)
            cropped.save('tools/merchant_raw.png')
            r90.save('tools/merchant_r90.png')
            r270.save('tools/merchant_r270.png')
            print("Saved rotated variants to tools/")
        else:
            box = (x, y, x + w, y + h)
            cropped = atlas_img.crop(box)
            cropped.save('tools/merchant_clean.png')
            print("Saved non-rotated sprite to tools/merchant_clean.png")

