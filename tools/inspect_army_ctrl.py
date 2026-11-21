import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

army = data.get("armyCtrl", {})
for k, v in army.items():
    if k not in ["lastCalcuTime", "activeDefCompile", "isJudgeCompileHero"]:
        print(k, "=>", type(v), v if not isinstance(v, dict) else list(v.keys())[:10])
