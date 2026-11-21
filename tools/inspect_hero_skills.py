import json

def inspect_heroes(data_path, label):
    with open(data_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    hero_module = data.get("heroSysCtrl", {})
    heros = hero_module.get("heroList", {})
    print(f"=== {label} Heroes ({len(heros)}) ===")
    for hid, h in sorted(heros.items(), key=lambda x: int(x[0])):
        skills = h.get("skillList", {})
        is_awake = h.get("isAwake", False)
        power_skill = h.get("powerSkill", {})
        adv_skill = h.get("advancedSkill", {})
        state = h.get("state", 0)
        print(f"Hero {hid}: level={h.get('level')}, quality={h.get('quality')}, state={state}, isAwake={is_awake}, skills={len(skills)}, power={bool(power_skill)}, adv={bool(adv_skill)}")
        if skills:
            print(f"   skills: {skills}")

if __name__ == "__main__":
    inspect_heroes("tools/beetoo1_full_init_data.json", "beetoo1")
    print("\n" + "="*50 + "\n")
    inspect_heroes("tools/beetoo2_full_init_data.json", "beetoo2")
