import os

GAME_SRC = r"E:\intqam-sultan\game_file\src"

def search_kl_api():
    for root, dirs, files in os.walk(GAME_SRC):
        for f in files:
            if "kingdomLevel" in f.lower() or "kingdom_level" in f.lower():
                print(os.path.join(root, f))

if __name__ == "__main__":
    search_kl_api()
