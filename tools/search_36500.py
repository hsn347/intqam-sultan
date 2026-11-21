import os

GAME_DIR = r"E:\intqam-sultan\game_file"

def search_number():
    targets = ["36500", "36,500", "35500", "37500"]
    print("Searching for 36500 in game_file...")
    for root, dirs, files in os.walk(GAME_DIR):
        for f in files:
            if f.endswith((".lua", ".json", ".xml", ".txt", ".csv")):
                p = os.path.join(root, f)
                try:
                    with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                        content = fp.read()
                        for t in targets:
                            if t in content:
                                print(f"Found {t} in: {p}")
                except:
                    pass

if __name__ == "__main__":
    search_number()
