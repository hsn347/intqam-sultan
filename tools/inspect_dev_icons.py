import os
from PIL import Image
import numpy as np

files = os.listdir('scratch/dev_icons')
for f in files:
    if f.endswith('.png'):
        p = os.path.join('scratch/dev_icons', f)
        im = Image.open(p)
        bbox = im.getbbox()
        arr = np.array(im)
        print(f"{f}: size={im.size}, bbox={bbox}")
