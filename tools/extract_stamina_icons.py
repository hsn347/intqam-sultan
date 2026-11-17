# -*- coding: utf-8 -*-
"""
extract_stamina_icons.py
══════════════════════════════════════════════════════════════════════════════
Automated extraction and compositing tool for the Stamina Potion (قارورة طاقة الأمير).
Extracts the official in-game green potion (3004.png) directly from:
  assets/aa/textures_assets_textures/itemui/3004.png_2ca305cf8ff81a779a5347a0c6b8223a.bundle
in game_file/apk_packages/split_UnityDataAssetPack.apk.

Generates:
  1. dayaniklilik_2.png — Standalone transparent potion icon (193x214 RGBA).
  2. dayaniklilik_1.png — Full ornate medallion / decorative frame with
     the new 3004 potion perfectly centered and the previous bottle cleanly infilled.

Deploys to:
  - dashboard/public/images/dayaniklilik_2.png
  - dashboard/public/images/daily/dayaniklilik_2.png
  - dashboard/public/images/daily/dayaniklilik_1.png
  - dashboard/public/images/resources/dayaniklilik_2.png
  - Matching dashboard/dist/ paths
  - Brain artifact directory
══════════════════════════════════════════════════════════════════════════════
"""

import io
import os
import sys
import zipfile
import numpy as np
from PIL import Image
import UnityPy

UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.62f2"

APK_PATH = os.path.join("game_file", "apk_packages", "split_UnityDataAssetPack.apk")
BUNDLE_NAME_PARTIAL = "3004.png_"
BRAIN_DIR = r"C:\Users\Computer Home\.gemini\antigravity\brain\445108ce-6438-4e84-a28e-3f2e1c1673ba"

PUBLIC_DIR = os.path.join("dashboard", "public", "images")
DIST_DIR = os.path.join("dashboard", "dist", "images")


def extract_raw_3004(apk_zip):
    """Extracts raw 3004.png Texture2D from APK bundle."""
    bundle_name = [n for n in apk_zip.namelist() if BUNDLE_NAME_PARTIAL in n][0]
    data = apk_zip.read(bundle_name)
    env = UnityPy.load(io.BytesIO(data))
    for obj in env.objects:
        if obj.type.name == "Texture2D":
            return obj.read().image
    raise ValueError(f"Texture2D not found in {bundle_name}")


def create_dayaniklilik_2(raw_3004):
    """
    Creates standalone transparent stamina potion icon (193x214 RGBA),
    preserving the exact dimensions and high sharpness for task rows.
    """
    bbox = raw_3004.getbbox()
    active = raw_3004.crop(bbox) # ~105x106

    target_w = 193
    target_h = int(round(active.height * (target_w / active.width))) # 195
    scaled = active.resize((target_w, target_h), Image.Resampling.LANCZOS)

    canvas = Image.new("RGBA", (193, 214), (0, 0, 0, 0))
    offset_y = (214 - target_h) // 2 # 9
    canvas.paste(scaled, (0, offset_y), scaled)
    return canvas, raw_3004


def create_dayaniklilik_1(raw_3004, original_im1_path, original_im2_path):
    """
    Replaces the previous potion inside the ornate medallion frame with
    the new 3004 potion. Inpaints the previous bottle using radial profile
    interpolation from the surrounding plate texture to guarantee zero ghosting.
    """
    im1 = Image.open(original_im1_path)
    im2 = Image.open(original_im2_path)

    arr1 = np.array(im1).copy()
    arr2 = np.array(im2)

    # Position of old bottle in frame
    x0, y0 = 120, 96
    sh, sw = arr2.shape[:2]

    # Medallion center
    cx = 216.5
    cy = 203.0

    Y, X = np.ogrid[:429, :418]
    dist = np.sqrt((X - cx)**2 + (Y - cy)**2)

    # Old bottle mask
    bottle_mask = np.zeros((429, 418), dtype=bool)
    bottle_mask[y0:y0+sh, x0:x0+sw] = (arr2[:, :, 3] > 10)

    # Clean plate mask
    clean_mask = (~bottle_mask) & (arr1[:, :, 3] > 200)

    # Compute radial profile
    r_int = np.clip(np.round(dist).astype(int), 0, 200)
    profile = np.zeros((201, 3))
    counts = np.zeros(201)

    for i in range(201):
        m = (r_int == i) & clean_mask
        if np.any(m):
            profile[i] = arr1[m][:, :3].mean(axis=0)
            counts[i] = np.sum(m)

    valid_r = np.where(counts > 0)[0]
    for i in range(201):
        if counts[i] == 0:
            idx = np.argmin(np.abs(valid_r - i))
            profile[i] = profile[valid_r[idx]]

    # Reconstruct clean frame plate
    restored = arr1.copy()
    for y in range(y0, y0+sh):
        for x in range(x0, x0+sw):
            if bottle_mask[y, x]:
                r = int(np.clip(np.round(dist[y, x]), 0, 200))
                restored[y, x, :3] = profile[r]
                restored[y, x, 3] = 255

    clean_frame = Image.fromarray(restored)

    # Scale new 3004 potion (Scale 1.9x = 199x201)
    bbox = raw_3004.getbbox()
    crop3004 = raw_3004.crop(bbox)
    scale = 1.9
    new_w = int(crop3004.width * scale) # 199
    new_h = int(crop3004.height * scale) # 201
    scaled_new = crop3004.resize((new_w, new_h), Image.Resampling.LANCZOS)

    # Center on medallion
    pos_x = int(cx - new_w / 2.0)
    pos_y = int(cy - new_h / 2.0)

    composite = clean_frame.copy()
    composite.paste(scaled_new, (pos_x, pos_y), scaled_new)
    return composite


def deploy_assets():
    print("=" * 70)
    print("🚀 Extracting and Generating Stamina Potion Icons (3004.png)")
    print(f"📦 APK Source: {APK_PATH}")
    print("=" * 70)

    if not os.path.exists(APK_PATH):
        raise FileNotFoundError(f"APK not found at {APK_PATH}")

    with zipfile.ZipFile(APK_PATH, "r") as z:
        raw_3004 = extract_raw_3004(z)
        print(f"✅ Extracted raw 3004.png from APK: {raw_3004.size} {raw_3004.mode}")

    # Generate dayaniklilik_2
    im_dayaniklilik_2, _ = create_dayaniklilik_2(raw_3004)
    print(f"✅ Generated dayaniklilik_2.png: {im_dayaniklilik_2.size} {im_dayaniklilik_2.mode}")

    # Generate dayaniklilik_1
    orig_im1_path = os.path.join(PUBLIC_DIR, "daily", "dayaniklilik_1.png")
    orig_im2_path = os.path.join(PUBLIC_DIR, "daily", "dayaniklilik_2.png")
    im_dayaniklilik_1 = create_dayaniklilik_1(raw_3004, orig_im1_path, orig_im2_path)
    print(f"✅ Generated dayaniklilik_1.png: {im_dayaniklilik_1.size} {im_dayaniklilik_1.mode}")

    # Deployment mapping
    deployments = [
        # dayaniklilik_2 in public
        (im_dayaniklilik_2, os.path.join(PUBLIC_DIR, "dayaniklilik_2.png")),
        (im_dayaniklilik_2, os.path.join(PUBLIC_DIR, "daily", "dayaniklilik_2.png")),
        (im_dayaniklilik_2, os.path.join(PUBLIC_DIR, "resources", "dayaniklilik_2.png")),
        # dayaniklilik_1 in public
        (im_dayaniklilik_1, os.path.join(PUBLIC_DIR, "daily", "dayaniklilik_1.png")),

        # dayaniklilik_2 in dist
        (im_dayaniklilik_2, os.path.join(DIST_DIR, "dayaniklilik_2.png")),
        (im_dayaniklilik_2, os.path.join(DIST_DIR, "daily", "dayaniklilik_2.png")),
        (im_dayaniklilik_2, os.path.join(DIST_DIR, "resources", "dayaniklilik_2.png")),
        # dayaniklilik_1 in dist
        (im_dayaniklilik_1, os.path.join(DIST_DIR, "daily", "dayaniklilik_1.png")),

        # brain artifact copies
        (im_dayaniklilik_2, os.path.join(BRAIN_DIR, "dayaniklilik_2.png")),
        (im_dayaniklilik_1, os.path.join(BRAIN_DIR, "dayaniklilik_1.png")),
        (raw_3004, os.path.join(BRAIN_DIR, "3004_raw.png")),
    ]

    print("\n📂 Deploying assets across target directories:")
    for img, path in deployments:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        img.save(path, format="PNG", optimize=True)
        print(f"  -> Saved: {path} ({img.size})")

    print("\n" + "=" * 70)
    print("🎉 STAMINA POTION ICONS EXTRACTED & DEPLOYED SUCCESSFULLY!")
    print("=" * 70)


if __name__ == "__main__":
    deploy_assets()
