import os

src_dir = r"e:\intqam-sultan\game_file\src"
binary_files = []
text_files = []
for root, dirs, files in os.walk(src_dir):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            with open(fpath, "rb") as fp:
                head = fp.read(4)
                if head.startswith(b"\x1bLua"):
                    binary_files.append(fpath)
                else:
                    text_files.append(fpath)
print(f"Total lua files: {len(binary_files) + len(text_files)}")
print(f"Binary lua files: {len(binary_files)}")
print(f"Text lua files: {len(text_files)}")
if binary_files:
    print("Sample binary files:")
    for b in binary_files[:10]:
        print(" ", b)
