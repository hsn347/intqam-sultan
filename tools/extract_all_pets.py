# -*- coding: utf-8 -*-
"""
extract_all_pets.py
══════════════════════════════════════════════════════════════════════════════
Automated extraction tool for the 18 Revenge of Sultans Pet Icons (أيقونات الحيوانات الأليفة).
Extracts the official classic in-game pet avatars (peticon_<id>_01.png) directly from:
  - 1251 (Horse / الحصان): mainuiused_0.plist.bytes & mainuiused_0.png
  - 1252 - 1268: peticon_0.plist.bytes & peticon_0.png
inside game_file/apk_packages/split_UnityDataAssetPack.apk.

Deploys to:
  - dashboard/public/images/pets/
  - dashboard/dist/images/pets/
  - Brain artifact directory
══════════════════════════════════════════════════════════════════════════════
"""

import io
import os
import re
import struct
import zipfile
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

APK_PATH = os.path.join("game_file", "apk_packages", "split_UnityDataAssetPack.apk")
BRAIN_DIR = r"C:\Users\Computer Home\.gemini\antigravity\brain\445108ce-6438-4e84-a28e-3f2e1c1673ba\pets"
PUBLIC_DIR = os.path.join("dashboard", "public", "images", "pets")
DIST_DIR = os.path.join("dashboard", "dist", "images", "pets")

PET_IDS = [
    (1251, "الحصان", "mainuiused_0"),
    (1252, "الفهد", "peticon_0"),
    (1253, "الصقر", "peticon_0"),
    (1254, "جمل عربي", "peticon_0"),
    (1255, "ذئب عربي", "peticon_0"),
    (1256, "أسد عربي", "peticon_0"),
    (1257, "الوشق", "peticon_0"),
    (1258, "أيّل", "peticon_0"),
    (1259, "فيل", "peticon_0"),
    (1260, "دب", "peticon_0"),
    (1261, "المها", "peticon_0"),
    (1262, "ثعبان", "peticon_0"),
    (1263, "اللآما", "peticon_0"),
    (1264, "الضب", "peticon_0"),
    (1265, "النمر الأبيض", "peticon_0"),
    (1266, "طائر حورس", "peticon_0"),
    (1267, "تنين المجد التليد", "peticon_0"),
    (1268, "الغوريلا", "peticon_0"),
]


def load_atlas(apk_zip, bundle_partial):
    """Loads Texture2D and TextAsset binary data for a bundle."""
    plist_bundle = [n for n in apk_zip.namelist() if bundle_partial in n and ".plist.bytes" in n][0]
    png_bundle = [n for n in apk_zip.namelist() if bundle_partial in n and ".png_" in n][0]

    # Texture2D
    env_png = UnityPy.load(io.BytesIO(apk_zip.read(png_bundle)))
    tex = None
    for obj in env_png.objects:
        if obj.type.name == "Texture2D":
            tex = obj.read().image
            break
    if tex is None:
        raise ValueError(f"Texture2D not found in {png_bundle}")

    # Plist TextAsset
    env_plist = UnityPy.load(io.BytesIO(apk_zip.read(plist_bundle)))
    plist_data = None
    for obj in env_plist.objects:
        if obj.type.name == "TextAsset":
            data = obj.read()
            s = getattr(data, "m_Script", getattr(data, "script", ""))
            plist_data = s.encode("utf-8", "surrogateescape") if isinstance(s, str) else bytes(s)
            break
    if plist_data is None:
        raise ValueError(f"TextAsset not found in {plist_bundle}")

    return tex, plist_data


def extract_sprite(tex, plist_data, sprite_name):
    """Extracts, un-rotates and centers sprite onto transparent canvas."""
    target_bytes = sprite_name.encode("ascii")
    idx = plist_data.find(target_bytes)
    if idx == -1:
        raise ValueError(f"Sprite {sprite_name} not found in plist data")

    chunk = plist_data[idx + len(target_bytes):idx + len(target_bytes) + 120]

    # Rotated flag
    rot_idx = chunk.find(b"\x0b")
    rotated = (chunk[rot_idx + 1] == 1) if rot_idx != -1 and rot_idx + 1 < len(chunk) else False

    # Floats (sub-pixel offsets)
    floats = []
    pos = 0
    while pos < len(chunk) - 5:
        if chunk[pos] == 0x0F:
            floats.append(struct.unpack("<f", chunk[pos + 1:pos + 5])[0])
            pos += 5
        else:
            pos += 1
    off_x = floats[0] if len(floats) > 0 else 0.0
    off_y = floats[1] if len(floats) > 1 else 0.0

    # Integers (w, h, orig_w, orig_h, x, y)
    ints = []
    pos = 0
    while pos < len(chunk) - 5:
        if chunk[pos] == 0x06:
            ints.append(struct.unpack("<i", chunk[pos + 1:pos + 5])[0])
            pos += 5
        else:
            pos += 1

    if len(ints) < 6:
        raise ValueError(f"Insufficient int coordinates for {sprite_name}")

    w, h, orig_w, orig_h, x, y = ints[:6]

    if rotated:
        crop = tex.crop((x, y, x + h, y + w)).transpose(Image.ROTATE_270)
    else:
        crop = tex.crop((x, y, x + w, y + h))

    # Center onto transparent original canvas
    if orig_w > 0 and orig_h > 0 and (orig_w != w or orig_h != h):
        ox = int(round((orig_w - w) / 2.0 + off_x))
        oy = int(round((orig_h - h) / 2.0 - off_y))
        ox = max(0, min(ox, orig_w - w))
        oy = max(0, min(oy, orig_h - h))
        canvas = Image.new("RGBA", (orig_w, orig_h), (0, 0, 0, 0))
        canvas.paste(crop, (ox, oy), crop)
        return canvas

    return crop


def run_extraction():
    print("=" * 70)
    print("🚀 Extracting All 18 Official Game Pet Icons (peticon_<id>_01.png)")
    print(f"📦 Source APK: {APK_PATH}")
    print("=" * 70)

    if not os.path.exists(APK_PATH):
        raise FileNotFoundError(f"APK not found at {APK_PATH}")

    for d in [PUBLIC_DIR, DIST_DIR, BRAIN_DIR]:
        os.makedirs(d, exist_ok=True)

    extracted_count = 0

    with zipfile.ZipFile(APK_PATH, "r") as apk_zip:
        # Cache loaded bundles
        atlases = {}
        for b_name in ["mainuiused_0", "peticon_0"]:
            print(f"📂 Loading bundle: {b_name}...")
            tex, plist_data = load_atlas(apk_zip, b_name)
            atlases[b_name] = (tex, plist_data)
            print(f"   Atlas Texture Size: {tex.size}")

        print("\n🐾 Extracting and deploying pets:")
        for pet_id, arabic_name, bundle_key in PET_IDS:
            sprite_name = f"peticon_{pet_id}_01.png"
            tex, plist_data = atlases[bundle_key]
            img = extract_sprite(tex, plist_data, sprite_name)

            # Deploy to all directories with both naming styles (id.png and peticon_id_01.png)
            filenames = [f"{pet_id}.png", sprite_name]

            for dest_dir in [PUBLIC_DIR, DIST_DIR, BRAIN_DIR]:
                for fn in filenames:
                    out_path = os.path.join(dest_dir, fn)
                    img.save(out_path, format="PNG", optimize=True)

            print(f"  ✅ ID {pet_id} ({arabic_name}): {sprite_name} -> {img.size} RGBA")
            extracted_count += 1

    print("\n" + "=" * 70)
    print(f"🎉 ALL {extracted_count} PET ICONS EXTRACTED & DEPLOYED SUCCESSFULLY!")
    print(f"📁 Public Dir: {PUBLIC_DIR}")
    print(f"📁 Dist Dir:   {DIST_DIR}")
    print(f"📁 Brain Dir:  {BRAIN_DIR}")
    print("=" * 70)


if __name__ == "__main__":
    run_extraction()
