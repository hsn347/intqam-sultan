import os
from PIL import Image

PET_DIR = "dashboard/public/images/pets"
missing = []
valid = []

for pet_id in range(1251, 1269):
    fn1 = f"{pet_id}.png"
    fn2 = f"peticon_{pet_id}_01.png"
    p1 = os.path.join(PET_DIR, fn1)
    p2 = os.path.join(PET_DIR, fn2)
    
    for p, fn in [(p1, fn1), (p2, fn2)]:
        if not os.path.exists(p):
            missing.append(fn)
        else:
            with Image.open(p) as im:
                valid.append((fn, im.size, im.mode, os.path.getsize(p)))

print(f"Total valid files: {len(valid)} / 36")
if missing:
    print("Missing:", missing)
else:
    print("All 36 files present! Sample files:")
    for v in valid[:6]:
        print(f"  - {v[0]}: size={v[1]}, mode={v[2]}, bytes={v[3]}")
    for v in valid[-4:]:
        print(f"  - {v[0]}: size={v[1]}, mode={v[2]}, bytes={v[3]}")
