import os
from PIL import Image

orig = Image.open('tools/orig_dayaniklilik_1.png').convert('RGBA')
w, h = orig.size
print(f"Orig size: {w}x{h}")

# The center of symmetry of the frame:
# Let's find the bounding box of non-transparent pixels
bbox = orig.getbbox()
print("BBox:", bbox)
cx = (bbox[0] + bbox[2]) / 2.0
cy = (bbox[1] + bbox[3]) / 2.0
print(f"Center: ({cx}, {cy})")

# Let's inspect the top-left quadrant [0:int(cx), 0:int(cy)]
# In the original image:
# Bottle is at the center, pointing to top-right. Yellow '+' is in bottom-right.
# Top-left is 100% EMPTY of bottle!
# Let's check if top-left quadrant is free of bottle:
# Let's inspect!
