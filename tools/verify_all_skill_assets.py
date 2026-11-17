import os
from PIL import Image

base_dir = 'dashboard/public/images/skills'
categories = ['lord', 'hero', 'stun', 'beast']

total_valid = 0
results = {}

for cat in categories:
    dir_path = os.path.join(base_dir, cat)
    if not os.path.exists(dir_path):
        results[cat] = {"count": 0, "status": "MISSING"}
        continue
    files = [f for f in os.listdir(dir_path) if f.endswith('.png')]
    valid_count = 0
    sample_sizes = []
    for f in files:
        fp = os.path.join(dir_path, f)
        try:
            with Image.open(fp) as im:
                im.verify()
            with Image.open(fp) as im:
                valid_count += 1
                if len(sample_sizes) < 3:
                    sample_sizes.append((f, im.size, im.mode))
        except Exception as e:
            print(f"Corrupt image {fp}: {e}")
    total_valid += valid_count
    results[cat] = {
        "count": len(files),
        "valid": valid_count,
        "sample": sample_sizes
    }

print(f"Total Valid Images in {base_dir}: {total_valid}")
for cat, data in results.items():
    print(f"  Category '{cat}': {data['valid']} valid PNGs")
    for s in data.get('sample', []):
        print(f"    Sample: {s[0]} -> {s[1]}, mode={s[2]}")

# Also check brain artifact directory
brain_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\skills'
os.makedirs(brain_dir, exist_ok=True)
import shutil
for cat in categories:
    src_cat = os.path.join(base_dir, cat)
    dst_cat = os.path.join(brain_dir, cat)
    if os.path.exists(src_cat):
        shutil.copytree(src_cat, dst_cat, dirs_exist_ok=True)
print(f"Copied all skills to brain artifact directory: {brain_dir}")
