from PIL import Image

# 1. quest_building_121 (The EXACT daily quest icon from questIcon_0.png)
crop121 = Image.open('scratch/crop_quest_building_121.png')

# Place on 126x126 transparent canvas
canvas_126 = Image.new('RGBA', (126, 126), (0, 0, 0, 0))
# x = (126 - 119) // 2 = 3
# y = (126 - 81) // 2 = 22
canvas_126.paste(crop121, (3, 22), crop121)
canvas_126.save('scratch/quest_building_121.png')
print('Saved scratch/quest_building_121.png (126x126)')

# 2. icon_build_121 (Building 121 HD portrait from buildIcon_0.png)
crop_b121 = Image.open('scratch/icon_build_121.png')
canvas_250 = Image.new('RGBA', (250, 250), (0, 0, 0, 0))
canvas_250.paste(crop_b121, ((250 - crop_b121.width) // 2, (250 - crop_b121.height) // 2), crop_b121)
canvas_250.save('scratch/icon_build_121_full.png')
print('Saved scratch/icon_build_121_full.png (250x250)')

# 3. icon_building_arena (Arena function icon from iconBuilding_0.png)
crop_arena = Image.open('scratch/icon_building_arena.png')
canvas_110 = Image.new('RGBA', (110, 110), (0, 0, 0, 0))
canvas_110.paste(crop_arena, ((110 - crop_arena.width) // 2, (110 - crop_arena.height) // 2), crop_arena)
canvas_110.save('scratch/icon_building_arena_full.png')
print('Saved scratch/icon_building_arena_full.png (110x110)')
