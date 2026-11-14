from PIL import Image

tex = Image.open('scratch/questIcon_0.png')
print('Texture size:', tex.size)

# quest_building_121.png:
# [119, 81, 126, 126, 128, 963, 119, 81]
# Let's crop from top-left (128, 963, 128+119, 963+81)
crop1 = tex.crop((128, 963, 128+119, 963+81))
crop1.save('scratch/crop_quest_building_121.png')

# Also if Y is from bottom:
# y_bottom = 2048 - 963 - 81
crop1_b = tex.crop((128, 2048 - 963 - 81, 128+119, 2048 - 963))
crop1_b.save('scratch/crop_quest_building_121_bottom.png')

# quest_building_byzantine_121.png:
# [139, 113, 158, 158, 454, 511, 139, 113]
crop2 = tex.crop((454, 511, 454+139, 511+113))
crop2.save('scratch/crop_quest_building_byzantine_121.png')

crop2_b = tex.crop((454, 2048 - 511 - 113, 454+139, 2048 - 511))
crop2_b.save('scratch/crop_quest_building_byzantine_121_bottom.png')

print('Cropped images saved!')
