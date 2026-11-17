import zipfile, io, os
import UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
bundle = 'assets/aa/textures_assets_textures/itemui/3004.png_2ca305cf8ff81a779a5347a0c6b8223a.bundle'
art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

with zipfile.ZipFile(apk_path, 'r') as z:
    env = UnityPy.load(io.BytesIO(z.read(bundle)))
    for obj in env.objects:
        if obj.type.name == 'Texture2D':
            img = obj.read().image.convert('RGBA')
            print(f"Extracted Texture2D: size={img.size}")
            img.save(os.path.join(art_dir, 'stamina_potion_clean.png'))
            img.save('tools/stamina_potion_clean.png')
            print("Saved stamina_potion_clean.png")
