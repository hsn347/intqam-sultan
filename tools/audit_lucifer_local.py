import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("=== AUDIT OF ALL 36 CONTROLLERS IN LUCIFER LIVE MEMORY ===")
for k in sorted(data.keys()):
    val = data[k]
    val_str = json.dumps(val, ensure_ascii=False)
    if len(val_str) > 120:
        val_summary = f"{val_str[:120]}... (len: {len(val_str)})"
    else:
        val_summary = val_str
    print(f"[{k}]: {val_summary}")
