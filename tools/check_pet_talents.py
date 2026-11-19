# -*- coding: utf-8 -*-
import re
import os

filepath = os.path.join('game_file', 'src', 'app', 'localtb', 'config_server', 'pet_level_conf.lua')
with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

entries = re.split(r'index\s*=', text)
pet_skills = {}
pet_names = {
    1251: "حصان (Horse)",
    1252: "فهد (Leopard)",
    1253: "صقر (Eagle)",
    1254: "جمل (Camel)",
    1255: "ذئب (Wolf)",
    1256: "أسد (Lion)",
    1257: "وشق (Caracal)",
    1258: "غزال (Deer)",
    1259: "فيل (Elephant)",
    1260: "دب (Bear)",
    1261: "مها (Eland)",
    1262: "ثعبان (Snake)",
    1263: "ألبكة (Alpaca)",
    1264: "ورل (Lizard)",
    1265: "نمر (Tiger)",
    1266: "حورس (Horus)",
    1267: "تنين (Dragon)",
    1268: "غوريلا (Gorilla)",
}

for e in entries:
    pid_m = re.search(r'petid\s*=\s*(\d+)', e)
    lv_m = re.search(r'lv\s*=\s*(\d+)', e)
    if pid_m and lv_m:
        pid = int(pid_m.group(1))
        lv = int(lv_m.group(1))
        ts = re.findall(r'talent_skill.*?=\s*[^,]+,\s*(\d{8,12})', e)
        if ts:
            if pid not in pet_skills:
                pet_skills[pid] = {}
            for t_str in ts:
                attr = int(t_str[:2])
                val_type = int(t_str[2:4])
                val = int(t_str[4:])
                if attr not in pet_skills[pid] or val > pet_skills[pid][attr]:
                    pet_skills[pid][attr] = val

attr_names = {
    11: "GATHER_SPEED (جمع موارد)",
    12: "SOLDIER_LOAD (حمولة الجنود)",
    13: "TRAIN_SPEED (سرعة التدريب)",
    14: "TROOP_ATTACK (هجوم القوات)",
    15: "MONSTER_SPEED (سرعة مسير للوحوش)",
    16: "STUDY_RES_REDUCE (تقليل موارد البحث)",
    17: "CLUMP_NUM (حجم الحشد)",
    18: "MARCH_LIMIT (سعة المسيرة)",
    19: "REINFORCE_MAX (سعة التعزيز)",
    20: "SKILL_CD_REDUCE (تقليل وقت مهارة اللورد)",
    21: "RES_PROTECT (حماية الموارد)",
    22: "RES_OUTPUT (إنتاج الموارد)",
    23: "TROOP_DEFENSE (دفاع القوات)",
    24: "FOOD_REDUCE (تقليل استهلاك الطعام)",
    25: "RES_PLUNDER (نهب الموارد)",
    26: "CURE_SPEED (سرعة علاج المصابين)",
    27: "TROOP_HP (صحة القوات)",
    28: "WOUNDED_LIMIT (سعة المستشفى / المصابين)",
    29: "MASS_SPEED (سرعة الهجوم الحاشد)",
    30: "PROTECT_POWER_EXCHANGE (طاقة الحماية)",
    31: "ELITE_POWER (قوة النخبة)",
    32: "ARMY_DEF_REDUCE (تقليل دفاع العدو)",
    33: "MASS_ATK_PLUS (زيادة هجوم الحشد)",
    34: "SINGLE_MASSACRE (مجزرة الهجوم الفردي)",
    35: "INSTANT_BUILD (تسريع بناء)",
    36: "INSTANT_RESEARCH (تسريع بحث)",
    37: "ENEMY_ATK_REDUCE (تقليل هجوم العدو)",
    38: "DEFEND_DEFENSE (دفاع الحامية)",
    39: "DAMAGE_REDUCE (تقليل الضرر)",
    40: "BUILD_SPEED (سرعة البناء)",
    41: "MARCH_SPEED (سرعة المسير)",
    42: "DAMAGE_BOOST (زيادة الضرر)",
    43: "LEGEND_DEF_UP (دفاع أسطوري)",
    44: "LEGEND_ATTACK_UP (هجوم أسطوري)",
    45: "LEGEND_HALLOFWAR (قاعة الحرب)",
    46: "EXPEDITION_LOSS (خسائر الحملة)",
    47: "RUINS_MARCH_LIMIT (مسيرة الأطلال)",
    85: "BASE_ATTACK (هجوم أساسي)",
    86: "BASE_HP (صحة أساسية)",
    87: "RADIANCE_MARCH_SPEED (سرعة مسير الإشراق)",
    88: "SIEGE_SHIELD (درع الحصار)",
}

for pid, attrs in sorted(pet_skills.items()):
    attr_list = [f"{attr_names.get(a, f'Attr_{a}')}" for a in sorted(attrs.keys())]
    print(f"Pet {pid} [{pet_names.get(pid, 'Unknown')}]: {', '.join(attr_list)}")
