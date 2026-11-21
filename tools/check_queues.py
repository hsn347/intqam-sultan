import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

queue = data.get("queueCtrl", {})
print("Queue keys:", list(queue.keys()))
for k, v in queue.items():
    if "march" in k.lower() or "army" in k.lower() or "troop" in k.lower():
        print(k, "=>", v)
