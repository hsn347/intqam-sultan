import json

def check_all_systems():
    with open("march_capacity_extra_sources.json", "r", encoding="utf-8") as fp:
        data = json.load(fp)
        
    for k, v in data["eligible_systems"].items():
        print(f"=== SYSTEM: {k} ({v.get('system_name')}) ===")
        print(f"  Source enum: {v.get('source_enum')}")
        print(f"  Target effect: {v.get('target_effect')}")
        print(f"  Guidance: {v.get('live_memory_read_guidance')[:200]}")
        recs = v.get("filtered_records", [])
        print(f"  Record count: {len(recs)}")
        if recs and len(recs) <= 10:
            print(f"  Records: {recs}")
        elif recs:
            print(f"  Sample record: {recs[0]}")
        print()

if __name__ == "__main__":
    check_all_systems()
