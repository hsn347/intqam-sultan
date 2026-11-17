import zipfile, io, plistlib, UnityPy
from PIL import Image

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'
plist_bundle = 'assets/aa/atlastp_assets_atlastp/commonui/mainuiused_0.plist.bytes_77a2c2e8479749429e301fcd19799f98.bundle'
png_bundle = 'assets/aa/atlastp_assets_atlastp/commonui/mainuiused_0.png_dd0ec240536ce8b911a14289e6800c87.bundle'

with zipfile.ZipFile(apk_path, 'r') as z:
    plist_bytes = z.read(plist_bundle)
    png_bytes = z.read(png_bundle)

env_plist = UnityPy.load(plist_bytes)
plist_content = None
for obj in env_plist.objects:
    if obj.type.name == 'TextAsset':
        read_obj = obj.read()
        if hasattr(read_obj, 'raw_data'):
            plist_content = read_obj.raw_data
        elif hasattr(read_obj, 'm_Script'):
            plist_content = read_obj.m_Script.encode('utf-8', 'surrogateescape')
        break

if plist_content:
    print("plist_content length:", len(plist_content))
    print("plist_content prefix:", plist_content[:100])
