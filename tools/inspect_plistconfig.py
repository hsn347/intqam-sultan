import zipfile, io, json
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
    data = z.read('assets/aa/atlastp_assets_atlastp/plistconfig.bytes_4008f8dc421614fc4ef6d0128672d6a6.bundle')

env = UnityPy.load(io.BytesIO(data))
for obj in env.objects:
    if obj.type.name == 'TextAsset':
        data = obj.read()
        script_bytes = getattr(data, 'raw_data', None)
        if script_bytes is None:
            script_bytes = getattr(data, 'bytes', None)
        if script_bytes is None:
            script_bytes = bytes(data.m_Script, 'raw_unicode_escape')
        print(f"TextAsset size: {len(script_bytes)} bytes")
        with open('tools/plistconfig_dump.bin', 'wb') as f:
            f.write(script_bytes)
        
        # Try decoding as utf-8 or json or lua table
        try:
            txt = script_bytes.decode('utf-8', errors='ignore')
            print("First 300 chars of plistconfig:")
            print(txt[:300])
            
            # Search for 2001.png .. 2006.png
            import re
            for num in range(2001, 2007):
                target = f"{num}.png"
                matches = [m.start() for m in re.finditer(re.escape(target), txt)]
                print(f"Matches for {target}: {len(matches)}")
                for idx in matches[:5]:
                    snippet = txt[max(0, idx-100):min(len(txt), idx+100)].replace('\n', ' ')
                    print(f"   [{num}] -> {snippet}")
        except Exception as e:
            print("Error decoding text:", e)
