import zipfile, io, re, UnityPy

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

# Search in plists for frames like frame_daily, frame_task, frame_d, frame_rc, or medallion
with zipfile.ZipFile(apk_path, 'r') as z:
    for name in z.namelist():
        if 'daily' in name.lower() or 'task' in name.lower() or 'quest' in name.lower():
            if name.endswith('.plist.bytes_*.bundle') or 'plist.bytes' in name:
                print("Plist:", name)
