import zipfile, io, os
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'
dash_dir = r'e:\intqam-sultan\dashboard\public\images\materials'

os.makedirs(dash_dir, exist_ok=True)

materials = [
    {
        'id': 2001,
        'key': 'herb',
        'ar': 'عشب',
        'bundle': 'assets/aa/textures_assets_textures/itemui/2001.png_8a21a5439f3421b4cf4f9c908a508d1d.bundle'
    },
    {
        'id': 2002,
        'key': 'purple_wood',
        'ar': 'خشب بنفسجي',
        'bundle': 'assets/aa/textures_assets_textures/itemui/2002.png_3427948f604dbc9119a26e8c47b3f6de.bundle'
    },
    {
        'id': 2003,
        'key': 'bronze',
        'ar': 'برونز',
        'bundle': 'assets/aa/textures_assets_textures/itemui/2003.png_94692ba80be8248206f3d2d37019c3f7.bundle'
    },
    {
        'id': 2004,
        'key': 'ruby',
        'ar': 'ياقوت',
        'bundle': 'assets/aa/textures_assets_textures/itemui/2004.png_98182057f1efe2c5ad78de545c5fef23.bundle'
    },
    {
        'id': 2005,
        'key': 'fur',
        'ar': 'فرو',
        'bundle': 'assets/aa/textures_assets_textures/itemui/2005.png_ed24be7857d7598f3e9bea1486fce18d.bundle'
    },
    {
        'id': 2006,
        'key': 'horn',
        'ar': 'قرن',
        'bundle': 'assets/aa/textures_assets_textures/itemui/2006.png_bb38009901404bb0e650e2344c5a4445.bundle'
    }
]

# Load circular frame
frame_path = os.path.join(art_dir, 'frame_gfyh_tbk2.png')
if not os.path.exists(frame_path):
    frame_path = 'tools/frame_gfyh_tbk2.png'

frame_img = Image.open(frame_path).convert('RGBA')
print(f"Loaded circular frame: {frame_img.size}")

extracted_images = {}

with zipfile.ZipFile(apk_path, 'r') as z:
    for m in materials:
        bundle_data = z.read(m['bundle'])
        env = UnityPy.load(io.BytesIO(bundle_data))
        img = None
        for obj in env.objects:
            if obj.type.name == 'Texture2D':
                data = obj.read()
                img = data.image.convert('RGBA')
                break
        if img:
            extracted_images[m['key']] = img
            print(f"Extracted {m['id']} ({m['key']} - {m['ar']}): size={img.size}")
            
            # Save raw clean transparent png
            clean_name = f"material_{m['key']}_clean.png"
            id_name = f"{m['id']}.png"
            named_png = f"{m['key']}.png"
            
            img.save(os.path.join(art_dir, clean_name))
            img.save(os.path.join(art_dir, id_name))
            img.save(os.path.join(art_dir, named_png))
            img.save(os.path.join(dash_dir, id_name))
            img.save(os.path.join(dash_dir, named_png))
            img.save(os.path.join(dash_dir, clean_name))

            # Create circular button composite
            btn_canvas = Image.new('RGBA', frame_img.size, (0, 0, 0, 0))
            btn_canvas.paste(frame_img, (0, 0), frame_img)
            
            # Scale icon to fit inside the circular frame (frame is 106x106, icon scaled to ~72x72)
            target_size = int(frame_img.size[0] * 0.68)
            icon_scaled = img.copy()
            icon_scaled.thumbnail((target_size, target_size), Image.Resampling.LANCZOS)
            
            # Center icon in frame
            offset_x = (frame_img.size[0] - icon_scaled.size[0]) // 2
            offset_y = (frame_img.size[1] - icon_scaled.size[1]) // 2
            
            btn_canvas.paste(icon_scaled, (offset_x, offset_y), icon_scaled)
            
            btn_name = f"material_{m['key']}_btn.png"
            btn_id_name = f"material_{m['id']}_btn.png"
            
            btn_canvas.save(os.path.join(art_dir, btn_name))
            btn_canvas.save(os.path.join(art_dir, btn_id_name))
            btn_canvas.save(os.path.join(dash_dir, btn_name))
            btn_canvas.save(os.path.join(dash_dir, btn_id_name))
            print(f"  Created composite button {btn_name}")
        else:
            print(f"Failed to find Texture2D for {m['id']}")

print("\nAll materials extracted and saved successfully!")
