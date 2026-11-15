import zipfile
import glob

for apk in glob.glob('game_file/apk_packages/*.apk'):
    with zipfile.ZipFile(apk, 'r') as z:
        for n in z.namelist():
            if 'mainui' in n.lower() or 'quest' in n.lower() or 'button' in n.lower():
                data = z.read(n)
                if b'Button_quest' in data:
                    print(f"FOUND Button_quest in {apk} -> {n}")
                if b'questGuideNode' in data:
                    print(f"FOUND questGuideNode in {apk} -> {n}")
