# -*- coding: utf-8 -*-
"""
extract_all_skill_icons.py
══════════════════════════════════════════════════════════════════════════════
Automated extraction utility for Revenge of Sultans skill icons.
Extracts transparent, authentic PNG sprites directly from Unity AssetBundles
in game_file/apk_packages/split_UnityDataAssetPack.apk without distortion or artifacts.

Categories extracted:
  1. lord  -> lordskill_0.plist.bytes  & lordskill_0.png
  2. hero  -> skillicon_0.plist.bytes  & skillicon_0.png
  3. stun  -> stunskillicon_0.plist.bytes & stunskillicon_0.png
  4. beast -> divinebeast_0.plist.bytes & divinebeast_0.png

Target output directories:
  - dashboard/public/images/skills/<category>/
  - dashboard/dist/images/skills/<category>/
  - brain artifact: C:/Users/Computer Home/.gemini/antigravity/brain/<conv_id>/skills/<category>/
══════════════════════════════════════════════════════════════════════════════
"""

import io
import os
import re
import struct
import sys
import zipfile
from PIL import Image
import UnityPy

# Set Unity fallback version for UnityPy bundle unpacking
UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

APK_PATH = os.path.join("game_file", "apk_packages", "split_UnityDataAssetPack.apk")
BRAIN_DIR = r"C:\Users\Computer Home\.gemini\antigravity\brain\445108ce-6438-4e84-a28e-3f2e1c1673ba\skills"
PUBLIC_DIR = os.path.join("dashboard", "public", "images", "skills")
DIST_DIR = os.path.join("dashboard", "dist", "images", "skills")

TARGETS = {
    "lord": {
        "plist": "lordskill_0.plist.bytes",
        "png": "lordskill_0.png",
        "desc": "Lord Skills (Battle, Develop, Assist)",
    },
    "hero": {
        "plist": "skillicon_0.plist.bytes",
        "png": "skillicon_0.png",
        "desc": "Hero Skills",
    },
    "stun": {
        "plist": "stunskillicon_0.plist.bytes",
        "png": "stunskillicon_0.png",
        "desc": "Stun Skills",
    },
    "beast": {
        "plist": "divinebeast_0.plist.bytes",
        "png": "divinebeast_0.png",
        "desc": "Divine Beast Skills & UI Icons",
    },
}


def parse_plist_and_texture(apk_zip, plist_partial, png_partial):
    """Loads Texture2D and TextAsset binary data from APK bundles."""
    plist_bundle = [n for n in apk_zip.namelist() if plist_partial in n][0]
    png_bundle = [n for n in apk_zip.namelist() if png_partial in n][0]

    # Load Texture2D
    env_png = UnityPy.load(io.BytesIO(apk_zip.read(png_bundle)))
    tex = None
    for obj in env_png.objects:
        if obj.type.name == "Texture2D":
            tex = obj.read().image
            break
    if tex is None:
        raise ValueError(f"Texture2D not found in {png_bundle}")

    # Load TextAsset
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


def parse_sprites_from_plist(plist_data):
    """
    Parses TexturePacker binary plist metadata:
    Returns list of dicts: {name, rotated, w, h, orig_w, orig_h, x, y, off_x, off_y}
    """
    matches = list(re.finditer(rb'([a-zA-Z0-9_-]+\.png)', plist_data))
    if not matches:
        return []

    sprites = []
    # Index 0 is typically the atlas texture name itself (e.g. lordSkill_0.png)
    for i in range(1, len(matches)):
        m = matches[i]
        name = m.group(1).decode("ascii")
        start = m.end()
        end = matches[i + 1].start() if i + 1 < len(matches) else start + 120
        chunk = plist_data[start:end]

        # Rotation flag: 0x0b 0x01 = True, 0x0b 0x00 = False
        rotated = False
        rot_idx = chunk.find(b"\x0b")
        if rot_idx != -1 and rot_idx + 1 < len(chunk):
            rotated = (chunk[rot_idx + 1] == 1)

        # Offsets (float 0x0f)
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

        # Integers (int 0x06)
        ints = []
        pos = 0
        while pos < len(chunk) - 5:
            if chunk[pos] == 0x06:
                ints.append(struct.unpack("<i", chunk[pos + 1:pos + 5])[0])
                pos += 5
            else:
                pos += 1

        if len(ints) < 6:
            continue

        w, h, orig_w, orig_h, x, y = ints[:6]
        sprites.append({
            "name": name,
            "rotated": rotated,
            "w": w,
            "h": h,
            "orig_w": orig_w,
            "orig_h": orig_h,
            "x": x,
            "y": y,
            "off_x": off_x,
            "off_y": off_y,
        })

    return sprites


def extract_and_restore_sprite(tex, sprite_meta):
    """
    Crops sprite from atlas, handles 90-degree CCW un-rotation,
    and accurately centers onto transparent original canvas if trimmed.
    """
    x = sprite_meta["x"]
    y = sprite_meta["y"]
    w = sprite_meta["w"]
    h = sprite_meta["h"]
    orig_w = sprite_meta["orig_w"]
    orig_h = sprite_meta["orig_h"]
    rot = sprite_meta["rotated"]
    off_x = sprite_meta["off_x"]
    off_y = sprite_meta["off_y"]

    if rot:
        crop_w, crop_h = h, w
        crop = tex.crop((x, y, x + crop_w, y + crop_h))
        # 90 degrees clockwise restores TexturePacker CCW rotation
        crop = crop.transpose(Image.ROTATE_270)
    else:
        crop = tex.crop((x, y, x + w, y + h))

    # Place on original transparent canvas if sprite was trimmed
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
    print("🚀 Starting Complete Revenge of Sultans Skill Icons Extraction")
    print(f"📦 APK Source: {APK_PATH}")
    print("=" * 70)

    if not os.path.exists(APK_PATH):
        raise FileNotFoundError(f"APK file not found at {APK_PATH}")

    total_extracted = 0
    results_summary = {}

    with zipfile.ZipFile(APK_PATH, "r") as apk_zip:
        for cat, cfg in TARGETS.items():
            print(f"\n📂 Processing Category: [{cat}] - {cfg['desc']}")
            tex, plist_data = parse_plist_and_texture(apk_zip, cfg["plist"], cfg["png"])
            sprites = parse_sprites_from_plist(plist_data)
            print(f"  Atlas Size: {tex.size} | Parsed Sprites: {len(sprites)}")

            # Destination directories
            cat_public_dir = os.path.join(PUBLIC_DIR, cat)
            cat_dist_dir = os.path.join(DIST_DIR, cat)
            cat_brain_dir = os.path.join(BRAIN_DIR, cat)

            for d in [cat_public_dir, cat_dist_dir, cat_brain_dir]:
                os.makedirs(d, exist_ok=True)

            cat_count = 0
            for sp in sprites:
                img = extract_and_restore_sprite(tex, sp)
                filename = sp["name"]

                # Save to all 3 target trees
                p_public = os.path.join(cat_public_dir, filename)
                p_dist = os.path.join(cat_dist_dir, filename)
                p_brain = os.path.join(cat_brain_dir, filename)

                img.save(p_public, format="PNG", optimize=True)
                img.save(p_dist, format="PNG", optimize=True)
                img.save(p_brain, format="PNG", optimize=True)
                cat_count += 1

            total_extracted += cat_count
            results_summary[cat] = cat_count
            print(f"  ✅ Successfully extracted {cat_count} icons to public, dist, and brain dirs.")

    print("\n" + "=" * 70)
    print("🎉 ALL SKILL ICONS EXTRACTED SUCCESSFULLY!")
    print(f"📊 Total Icons Extracted: {total_extracted}")
    for cat, count in results_summary.items():
        print(f"   - {cat.upper()}: {count} icons")
    print("=" * 70)


if __name__ == "__main__":
    run_extraction()
