from PIL import Image

def test_resize(src, name):
    im = Image.open(src)
    for sz in [16, 20, 24, 32]:
        resized = im.resize((sz, sz), Image.Resampling.LANCZOS)
        out = f"scratch/dev_icons/{name}_{sz}x{sz}.png"
        resized.save(out)
        print(f"Saved {out}")

test_resize('scratch/dev_icons/candidate_levelup.png', 'levelup')
test_resize('scratch/dev_icons/btn_main_pandect_01.png', 'pandect_hammer')
test_resize('scratch/dev_icons/icon_pandect_queue.png', 'queue_hammer')
test_resize('scratch/dev_icons/candidate_reward.png', 'reward')
