import os

def scan_tech_43():
    path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua"
    tech_map = {}
    current = {}
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if "technologyID" in line:
                # technologyID = 2401601
                parts = line.split("=")
                if len(parts) == 2:
                    current["id"] = parts[1].strip().rstrip(";")
            elif "technologyLevel" in line:
                parts = line.split(",")
                if len(parts) == 2:
                    current["lv"] = parts[1].strip().rstrip(";")
            elif "buffType" in line and "= 43" in line:
                current["buffType"] = 43
            elif "powerNum" in line:
                parts = line.split("=")
                if len(parts) == 2:
                    current["powerNum"] = parts[1].strip().rstrip(";")
            elif "technologyMaxLevel" in line:
                if current.get("buffType") == 43 and "id" in current:
                    tid = current["id"]
                    base_id = tid[:-2] if len(tid) > 2 else tid
                    lv = current.get("lv", "0")
                    pwr = current.get("powerNum", "0")
                    if base_id not in tech_map:
                        tech_map[base_id] = []
                    tech_map[base_id].append((lv, pwr))
                current = {}

    print(f"Found {len(tech_map)} technologies with buffType = 43:")
    for k, v in tech_map.items():
        print(f"Tech {k}: {v[:3]} ... max {v[-1]}")

if __name__ == "__main__":
    scan_tech_43()
