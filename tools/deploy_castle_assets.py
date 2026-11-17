# -*- coding: utf-8 -*-
"""
deploy_castle_assets.py
══════════════════════════════════════════════════════════════════════════════
Deploys and synchronizes the high-resolution Main Castle (zhucheng.png) assets:
  1. main_castle.png        — Tight-cropped transparent RGBA castle sprite (590x505)
  2. main_castle_square.png — Centered square transparent RGBA castle sprite (590x590)

Synchronized across:
  - dashboard/public/images/castles/
  - dashboard/dist/images/castles/
  - Both conversation artifact brain directories
══════════════════════════════════════════════════════════════════════════════
"""

import os
from PIL import Image
import numpy as np

SRC_PATH = os.path.join("scratch", "zhucheng.png")

DEST_DIRS = [
    os.path.join("dashboard", "public", "images", "castles"),
    os.path.join("dashboard", "dist", "images", "castles"),
    r"C:\Users\Computer Home\.gemini\antigravity\brain\445108ce-6438-4e84-a28e-3f2e1c1673ba\castles",
    r"C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\castles",
]


def process_and_deploy():
    print("=" * 70)
    print("🚀 Processing and Deploying Main Castle (zhucheng) Assets")
    print(f"📦 Source Image: {SRC_PATH}")
    print("=" * 70)

    if not os.path.exists(SRC_PATH):
        raise FileNotFoundError(f"Source file not found at {SRC_PATH}")

    im = Image.open(SRC_PATH).convert("RGBA")
    print(f"Original image size: {im.size} {im.mode}")

    # Compute tight bounding box on alpha > 10
    alpha = np.array(im.split()[-1])
    mask = alpha > 10
    rows = np.any(mask, axis=1)
    cols = np.any(mask, axis=0)
    rmin, rmax = np.where(rows)[0][[0, -1]]
    cmin, cmax = np.where(cols)[0][[0, -1]]

    tight_w = cmax - cmin + 1
    tight_h = rmax - rmin + 1
    print(f"Tight bounding box: ({cmin}, {rmin}, {cmax + 1}, {rmax + 1}) -> {tight_w}x{tight_h}")

    tight_im = im.crop((cmin, rmin, cmax + 1, rmax + 1))

    # Create square image with centered sprite
    max_dim = max(tight_w, tight_h)
    square_im = Image.new("RGBA", (max_dim, max_dim), (0, 0, 0, 0))
    offset_x = (max_dim - tight_w) // 2
    offset_y = (max_dim - tight_h) // 2
    square_im.paste(tight_im, (offset_x, offset_y), tight_im)
    print(f"Square image size: {square_im.size}")

    for dest_dir in DEST_DIRS:
        os.makedirs(dest_dir, exist_ok=True)

        path_tight = os.path.join(dest_dir, "main_castle.png")
        path_square = os.path.join(dest_dir, "main_castle_square.png")

        tight_im.save(path_tight, format="PNG", optimize=True)
        square_im.save(path_square, format="PNG", optimize=True)

        print(f"  ✅ Saved: {path_tight} ({tight_im.size}, {os.path.getsize(path_tight)} bytes)")
        print(f"  ✅ Saved: {path_square} ({square_im.size}, {os.path.getsize(path_square)} bytes)")

    print("\n" + "=" * 70)
    print("🎉 ALL CASTLE ASSETS DEPLOYED AND SYNCHRONIZED SUCCESSFULLY!")
    print("=" * 70)


if __name__ == "__main__":
    process_and_deploy()
