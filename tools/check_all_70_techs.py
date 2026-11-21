import os

def check_all_70_techs():
    researched = {
        '21001': 5, '21002': 5, '21003': 1, '21005': 3, '22001': 10, '22002': 5,
        '22003': 5, '22004': 4, '22005': 10, '22006': 6, '22007': 1, '22008': 10,
        '22009': 10, '22010': 1, '23001': 1, '23003': 1, '24001': 2, '24002': 3,
        '24003': 2, '24004': 3, '24005': 3, '24006': 2, '24007': 3, '24008': 2,
        '24009': 3, '24010': 3, '24011': 1, '24012': 3, '24013': 2, '24014': 3,
        '24015': 3, '24016': 3, '24017': 1, '24018': 2, '24019': 2, '24021': 4,
        '24022': 2, '24027': 1, '24032': 2, '24033': 1, '24101': 1, '24103': 1,
        '24104': 1, '24105': 1, '24106': 2, '24107': 1, '24108': 2, '24109': 1,
        '24111': 1, '24112': 1, '24113': 1, '24114': 1, '24115': 1, '24116': 1,
        '24117': 2, '25001': 4, '25002': 5, '25003': 5, '25004': 5, '25005': 1,
        '25006': 1, '25007': 3, '25008': 4, '25009': 3, '25010': 3, '25011': 1,
        '25012': 1, '25015': 1, '25029': 1, '25030': 1
    }
    
    path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua"
    current = {}
    results = []
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if "technologyID" in line:
                parts = line.split("=")
                if len(parts) == 2:
                    current["id"] = parts[1].strip().rstrip(";")
            elif "buffType" in line:
                parts = line.split("=")
                if len(parts) == 2:
                    current["buffType"] = parts[1].strip().rstrip(";")
            elif "powerNum" in line:
                parts = line.split("=")
                if len(parts) == 2:
                    current["powerNum"] = parts[1].strip().rstrip(";")
            elif "technologyMaxLevel" in line:
                tid = current.get("id", "")
                if len(tid) >= 3:
                    base_id = tid[:-2]
                    lv = int(tid[-2:])
                    if base_id in researched and researched[base_id] == lv:
                        btype = current.get("buffType", "")
                        pnum = current.get("powerNum", "")
                        results.append((base_id, lv, btype, pnum))
                current = {}

    print(f"Matched {len(results)} technologies:")
    for base_id, lv, btype, pnum in sorted(results, key=lambda x: int(x[2]) if x[2].isdigit() else 0):
        print(f"Tech {base_id} (Lv {lv}): buffType = {btype:4s} | powerNum = {pnum}")

if __name__ == "__main__":
    check_all_70_techs()
