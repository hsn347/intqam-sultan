from PIL import Image

img = Image.open(r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\.user_uploaded\media_1794774025827_de83b180.jpg')
w, h = img.size
print("User screenshot size:", w, h)

# The circled button is at the bottom right, around:
# x: ~850 to 980 (out of 1024 or proportion)
# y: ~1500 to 1680 (out of 1700 or proportion)
# Let's crop relative to image size:
# In the image, height is large, width is ~ 576 or 1080?
box = (int(w * 0.82), int(h * 0.80), int(w * 0.99), int(h * 0.90))
crop = img.crop(box)
crop.save('scratch/user_quest_button_crop.png')
print("Cropped button saved to scratch/user_quest_button_crop.png")
