import zipfile, io, re, UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"
apk_path = 'game_file/apk_packages/split_UnityDataAssetPack.apk'

with open('tools/plistconfig_clean.bin', 'rb') as f:
    data = f.read()

# Let's search for hammer, gongjiang, jianzhu
for kw in [b'hammer', b'gongjiang', b'jianzhu', b'queue', b'pandect_01']:
    m = re.findall(rb'[\w\-_]*' + kw + rb'[\w\-_]*\.png', data)
    print(kw.decode(), len(m), set([x.decode() for x in m[:10]]))
