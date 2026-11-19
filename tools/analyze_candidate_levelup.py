from PIL import Image
import numpy as np

im = Image.open('scratch/dev_icons/candidate_levelup.png')
print("candidate_levelup size:", im.size)
# inspect color palette
arr = np.array(im)
alpha = arr[:, :, 3]
visible = arr[alpha > 50]
print("Visible pixels count:", len(visible))
# average RGB of visible pixels
avg_r, avg_g, avg_b = visible[:, 0].mean(), visible[:, 1].mean(), visible[:, 2].mean()
print(f"Average color: R={avg_r:.1f}, G={avg_g:.1f}, B={avg_b:.1f}")
