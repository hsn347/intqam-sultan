import zipfile
import io
import re
import json
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = '2022.3.62f2'

def get_plist_sprites(bundle_partial):
    with zipfile.ZipFile('game_file/apk_packages/split_UnityDataAssetPack.apk', 'r') as z:
        bname = [n for n in z.namelist() if bundle_partial in n][0]
        data = z.read(bname)
        env = UnityPy.load(io.BytesIO(data))
        for obj in env.objects:
            if obj.type.name == 'TextAsset':
                s = getattr(obj.read(), 'm_Script', getattr(obj.read(), 'script', ''))
                text = s if isinstance(s, str) else bytes(s).decode('latin1', errors='ignore')
                pngs = [p for p in re.findall(r'[\w\-]+\.png', text) if not p.lower().endswith('_0.png')]
                return set(pngs)
    return set()

lord_sprites = get_plist_sprites('lordskill_0.plist.bytes')
hero_sprites = get_plist_sprites('skillicon_0.plist.bytes')
stun_sprites = get_plist_sprites('stunskillicon_0.plist.bytes')
beast_sprites = get_plist_sprites('divinebeast_0.plist.bytes')

print(f"Plist sprite counts:")
print(f"  lord: {len(lord_sprites)}")
print(f"  hero: {len(hero_sprites)}")
print(f"  stun: {len(stun_sprites)}")
print(f"  beast: {len(beast_sprites)}")

# Check lord icons
with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    lord_text = f.read()
lord_pattern = re.compile(r'id\s*=\s*(\d+)\s*;\(nil\)\.name\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]+)"\s*_ENV.*?icon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
lord_icons = {m[3] for m in lord_pattern.findall(lord_text)}
print(f"Lord icons in lua: {len(lord_icons)} | In plist: {len(lord_icons.intersection(lord_sprites))}")

# Check hero icons
with open('game_file/src/app/localtb/config_client/hero_skill_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    hero_text = f.read()
hero_pattern = re.compile(r'skillID\s*=\s*(\d+)\s*;\(nil\)\.herName\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]*)"\s*_ENV.*?herIcon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
hero_icons = {m[3] for m in hero_pattern.findall(hero_text)}
print(f"Hero icons in lua: {len(hero_icons)} | In plist: {len(hero_icons.intersection(hero_sprites))}")

# Check stun icons
with open('game_file/src/app/localtb/config_client/hero_stuntskill_view.lua', 'r', encoding='utf-8', errors='ignore') as f:
    stun_text = f.read()
stun_pattern = re.compile(r'skillID\s*=\s*(\d+)\s*;\(nil\)\.name\s*=\s*"([^"]+)"\s*;\(nil\)\.des\s*=\s*"([^"]+)"\s*_ENV.*?icon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
stun_icons = {m[3] for m in stun_pattern.findall(stun_text)}
print(f"Stun icons in lua: {len(stun_icons)} | In plist: {len(stun_icons.intersection(stun_sprites))}")

# Check beast icons
with open('game_file/src/app/localtb/config_server/divine_beast_skill_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    beast_text = f.read()
beast_pattern = re.compile(r'skillIcon\s*=\s*nil,\s*nil,\s*"([^"]+)"')
beast_icons = set(beast_pattern.findall(beast_text))
print(f"Beast icons in lua: {len(beast_icons)} | In plist: {len(beast_icons.intersection(beast_sprites))}")
