import os

GAME_SRC = r"E:\intqam-sultan\game_file\src"

def search_terms():
    terms = ["MARCH_VALUE_LIMIT_BOOST", "DISPATCH_TROOP_COUNT_NUM", "NEBULA_TOWER", "attributeSystem"]
    for root, dirs, files in os.walk(GAME_SRC):
        for f in files:
            if f.endswith(".lua"):
                p = os.path.join(root, f)
                try:
                    with open(p, "r", encoding="utf-8", errors="ignore") as fl:
                        text = fl.read()
                        matches = [t for t in terms if t in text]
                        if matches:
                            print(f"{p} -> {matches}")
                except:
                    pass

if __name__ == "__main__":
    search_terms()
