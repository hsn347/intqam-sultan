from PIL import Image

def crop_tight(path, out_path):
    im = Image.open(path)
    bbox = im.getbbox()
    cropped = im.crop(bbox)
    # make it a nice square canvas
    max_d = max(cropped.size)
    sq = Image.new('RGBA', (max_d, max_d), (0,0,0,0))
    offset = ((max_d - cropped.width)//2, (max_d - cropped.height)//2)
    sq.paste(cropped, offset, cropped)
    sq.save(out_path)
    print(f"Saved {out_path} ({sq.size})")

crop_tight('scratch/dev_icons/icon_building_levelup.png', 'scratch/dev_icons/candidate_levelup.png')
crop_tight('scratch/dev_icons/icon_pandect_queue.png', 'scratch/dev_icons/candidate_hammer.png')
crop_tight('scratch/dev_icons/btn_dailyreward.png', 'scratch/dev_icons/candidate_reward.png')
