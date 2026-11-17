import zipfile, io, re, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

# Let's inspect where the original dayaniklilik came from
# The original file name in ROS (Revenge of Sultans) for this might be 'icon_dayaniklilik' or in a Turkish/Arabic localization or 'frame_*.png'

with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if 'dayaniklilik' in name.lower() or 'stamina' in name.lower() or 'vitality' in name.lower():
            print("Match:", name)
