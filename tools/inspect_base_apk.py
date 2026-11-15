import zipfile

with zipfile.ZipFile('game_file/apk_packages/base.apk', 'r') as z:
    names = z.namelist()
    print("Total files in base.apk:", len(names))
    for n in names:
        if any(k in n.lower() for k in ['quest', 'mainui', 'csb', 'fui']):
            print(n)
