import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

print("=== ALL TOP-LEVEL KEYS IN BEETOO1 INIT_DATA ===")
for k in sorted(diag.keys()):
    v = diag[k]
    t = type(v).__name__
    l = len(v) if isinstance(v, (dict, list, str)) else 0
    print(f"  • {k:<30} ({t}, len={l})")
