import zipfile
import io
import struct
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

def extract_and_crop(plist_match, png_match, target_sprite, save_path):
    with zipfile.ZipFile(apk_path, 'r') as z:
        pb = [n for n in z.namelist() if plist_match in n and 'plist' in n][0]
        tb = [n for n in z.namelist() if png_match in n and 'png' in n][0]
        
        env_png = UnityPy.load(io.BytesIO(z.read(tb)))
        tex = None
        for obj in env_png.objects:
            if obj.type.name == 'Texture2D':
                tex = obj.read().image
                break
                
        env_plist = UnityPy.load(io.BytesIO(z.read(pb)))
        plist_data = None
        for obj in env_plist.objects:
            if obj.type.name == 'TextAsset':
                data = obj.read()
                s = getattr(data, 'm_Script', getattr(data, 'script', ''))
                plist_data = s.encode('utf-8', 'surrogateescape') if isinstance(s, str) else bytes(s)
                break
                
        idx = plist_data.find(target_sprite.encode('ascii'))
        if idx == -1:
            print(f"{target_sprite} not found in {pb}")
            return
            
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
            print(f"{target_sprite}: x={x}, y={y}, w={w}, h={h}, orig=({orig_w}, {orig_h})")
            crop = tex.crop((x, y, x+w, y+h))
            crop.save(save_path)
            print(f"Saved {save_path}")

extract_and_crop('guideui_0', 'guideui_0', 'icon_guide_quest.png', 'scratch/icon_guide_quest.png')
extract_and_crop('combtnui2_0', 'combtnui2_0', 'btn_quest.png', 'scratch/btn_quest.png')
extract_and_crop('comiconui2_0', 'comiconui2_0', 'icon_chapterTask.png', 'scratch/icon_chapterTask.png')
extract_and_crop('mainuiused_0', 'mainuiused_0', 'bg_main_task02.png', 'scratch/bg_main_task02.png')
extract_and_crop('mainuiused_0', 'mainuiused_0', 'bg_main_task04.png', 'scratch/bg_main_task04.png')
