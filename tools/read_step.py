import json

path = r"C:\Users\Computer Home\.gemini\antigravity\brain\01d52bec-3e5b-4692-9750-33902ddd6074\.system_generated\logs\transcript.jsonl"
with open(path, "r", encoding="utf-8") as f:
    for line in f:
        d = json.loads(line)
        if d.get("source") == "MODEL" and d.get("type") == "PLANNER_RESPONSE":
            c = d.get("content", "")
            if "184,600" in c or "LUCIFER" in c or "137,600" in c:
                print(f"Step {d.get('step_index')}:")
                print(c[:400])
                print("-" * 40)

