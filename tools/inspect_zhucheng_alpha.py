from PIL import Image
import numpy as np

im = Image.open('scratch/zhucheng.png')
print("Dimensions:", im.size)
print("Mode:", im.mode)

# Check transparency / alpha channel
if im.mode == 'RGBA':
    alpha = np.array(im.split()[-1])
    min_a, max_a, mean_a = alpha.min(), alpha.max(), alpha.mean()
    print(f"Alpha stats: min={min_a}, max={max_a}, mean={mean_a:.1f}")
    
    # Calculate non-transparent bbox
    bbox = im.getbbox()
    print("Bounding box of non-transparent content:", bbox)
else:
    print("No alpha channel present.")
