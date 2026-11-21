# -*- coding: utf-8 -*-
import json

transcript_path = "C:/Users/Computer Home/.gemini/antigravity/brain/bfca99be-9899-4d0f-a8d1-cd2925d889df/.system_generated/logs/transcript.jsonl"
with open(transcript_path, "r", encoding="utf-8") as f:
    for line in f:
        obj = json.loads(line)
        if obj.get("source") == "USER_EXPLICIT" or obj.get("type") == "USER_INPUT":
            print(f"=== [Step {obj.get('step_index')}] ===")
            print(obj.get("content"))

