import os, re, json

BASE_DIR = r"e:\intqam-sultan\game_file"

payload = {
    "metadata": {
        "game": "Revenge of Sultans (انتقام السلاطين)",
        "scope": "Maximum Single March Capacity When Attacking Outside Castle (سعة المسيرة القصوى للفيلق الواحد عند الهجوم خارج القلعة)",
        "origin_function": "buildLogic.getExpArmyCount()",
        "target_effects": {
            "96": {
                "name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
                "type": "Numeric Flat Addition",
                "description": "Direct numerical troop increase added to total march capacity (زيادة عددية مباشرة لعدد الجنود)"
            },
            "19": {
                "name": "gBuffEffect.MARCH_LIMIT_BOOST",
                "type": "Percentage Permille Multiplier",
                "description": "Permille multiplier (/ 1000) applied to base march capacity (زيادة مئوية بالألف)"
            },
            "5": {
                "name": "gAttributeEnum.DISPATCH_TROOP_COUNT_NUM",
                "type": "Attribute System Flat Troop Addition",
                "description": "Total dispatch troop count from attribute system, mapped from attrID=3 in attribute_config.lua (سمة حجم مسيرة القوات)"
            }
        }
    },
    "eligible_systems": {},
    "ineligible_systems": {}
}

# 1. WAR GEMS
war_gems = []
path_war_gems = os.path.join(BASE_DIR, r"src\app\localtb\config_server\war_stone_config.lua")
with open(path_war_gems, 'r', encoding='utf-8', errors='ignore') as f:
    text_wg = f.read()

for gid in range(12060101, 12060111):
    m = re.search(rf'gemID\s*=\s*{gid}.*?level\s*=\s*(\d+).*?attribute,\s*\({gid}\)\[1\]\s*=\s*{gid},\s*96.*?attribute,\s*\({gid}\)\[3\]\s*=\s*{gid},\s*(\d+)', text_wg, re.DOTALL)
    if m:
        war_gems.append({
            "gemID": gid,
            "level": int(m.group(1)),
            "buffType": 96,
            "march_troops_boost": int(m.group(2))
        })
    else:
        m2 = re.search(rf'\(12050310\)\.gemID\s*=\s*{gid}.*?\(12050310\)\.level\s*=\s*(\d+).*?attribute,\s*\({gid}\)\[1\]\s*=\s*{gid},\s*96.*?attribute,\s*\({gid}\)\[3\]\s*=\s*{gid},\s*(\d+)', text_wg, re.DOTALL)
        if m2:
            war_gems.append({
                "gemID": gid,
                "level": int(m2.group(1)),
                "buffType": 96,
                "march_troops_boost": int(m2.group(2))
            })

payload["eligible_systems"]["war_gems"] = {
    "system_name": "War Gems (أحجار الحرب)",
    "source_enum": "gBuffSource.WAR_GEM",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/warGem/warGemCtrl.lua",
    "lua_function_code": """function warGemCtrl:getBuffPlus(buffType)
	if not self.buffPlusCache or self.gemDataMgr:getIsClearBuffCache() then
		self.buffPlusCache, _UPVALUE0_ = self.gemDataMgr:getIsClearBuffCache(), self.gemDataMgr:getIsClearBuffCache()
		self.gemDataMgr:setIsClearBuffCache(false)
	end
	if not self.buffPlusCache[buffType] then
		local buffTable = self.gemDataMgr:getBuffTable()
		self.buffPlusCache[buffType] = buffTable and buffTable[buffType] or 0
	end
	return self.buffPlusCache[buffType]
end""",
    "live_memory_read_guidance": "Gems are inlaid in equipped castle gear. In live memory: inspect conn.init_data.equipment (or gem_data / wargem_slots), identify inlaid gem IDs 12060101-12060110, and sum their flat soldier boost values (+500 to +12,500).",
    "filtered_records": war_gems
}

# 2. KINGDOM LEVEL
path_kl = os.path.join(BASE_DIR, r"src\app\localtb\config_server\kingdom_lv_config.lua")
with open(path_kl, 'r', encoding='utf-8', errors='ignore') as f:
    lines_kl = f.readlines()

kl_records = []
cur_kl = None
for i, l in enumerate(lines_kl):
    m = re.search(r'kingdomLv\s*=\s*(\d+)', l)
    if m:
        cur_kl = int(m.group(1))
    m2 = re.search(r'\(nil\)\.index\s*=\s*(\d+)', l)
    if m2 and cur_kl is None:
        cur_kl = int(m2.group(1))
    
    m_buff = re.search(r'buff,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*nil,\s*96\b', l)
    if m_buff:
        idx = int(m_buff.group(1))
        if i + 1 < len(lines_kl):
            next_l = lines_kl[i+1]
            m_val = re.search(r'buff,\s*\(nil\)\[(\d+)\]\s*=\s*nil,\s*nil,\s*(\d+)', next_l)
            if m_val and int(m_val.group(1)) == idx + 1:
                val = int(m_val.group(2))
                kl_records.append({
                    "kingdomLevel": cur_kl,
                    "buffType": 96,
                    "march_troops_boost": val
                })

seen_kl = set()
unique_kl = []
for r in kl_records:
    if r["kingdomLevel"] not in seen_kl:
        seen_kl.add(r["kingdomLevel"])
        unique_kl.append(r)
unique_kl.sort(key=lambda x: x["kingdomLevel"])

payload["eligible_systems"]["kingdom_level"] = {
    "system_name": "Kingdom Level (مستوى المملكة)",
    "source_enum": "gBuffSource.KINGDOM_LEVEL",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/kingdomLevel/kingdomLevelDataModuleAPI.lua",
    "lua_function_code": """function kingdomLevelDataModuleAPI:getBuff(effectType)
	if not self:isUnlock() then
		return 0
	end
	local kingdomLevel = self:getKingdomLevel()
	return kingdomLevelBuff:getBuffEffect(kingdomLevel, effectType)
end

function kingdomLevelBuff:getBuffEffect(kingdomLevel, effectType)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if not kingdomLevelltCtrl:buffValid(effectType, kingdomLevel, castleLevel) then
		return 0
	end
	return kingdomLevelltCtrl:getBuff(kingdomLevel, effectType)
end""",
    "live_memory_read_guidance": "Read conn.init_data.kingdom_level (or lordInfoCtrl:getKingdomLevel()). Look up kingdomLevel in kingdom_lv_config.lua: if buff[96] exists, return that value directly.",
    "filtered_records": unique_kl
}

# 3. NEBULA TOWER
path_nt = os.path.join(BASE_DIR, r"src\app\localtb\config_client\tower_lv_privilege.lua")
with open(path_nt, 'r', encoding='utf-8', errors='ignore') as f:
    lines_nt = f.readlines()

nt_records = []
cur_idx = None
cur_season = None
cur_kl = None
for i, l in enumerate(lines_nt):
    m_idx = re.search(r'\.index\s*=\s*(\d+)', l)
    if m_idx:
        cur_idx = int(m_idx.group(1))
    m_s = re.search(r'\.season\s*=\s*(\d+)', l)
    if m_s:
        cur_season = int(m_s.group(1))
    m_k = re.search(r'\.kingdomLv\s*=\s*nil,\s*(\d+)', l)
    if m_k:
        cur_kl = int(m_k.group(1))
    
    if re.search(r'\.buff,\s*\(nil\)\[1\]\s*=\s*nil,\s*nil,\s*96\b', l):
        if i + 2 < len(lines_nt):
            l3 = lines_nt[i+2]
            m_val = re.search(r'\.buff,\s*\(nil\)\[3\]\s*=\s*nil,\s*nil,\s*(\d+)', l3)
            if m_val:
                val = int(m_val.group(1))
                nt_records.append({
                    "privilegeIndex": cur_idx,
                    "season": cur_season,
                    "kingdomLv": cur_kl,
                    "buffType": 96,
                    "march_troops_boost": val
                })

seen_nt = set()
unique_nt = []
for r in nt_records:
    if r["privilegeIndex"] not in seen_nt:
        seen_nt.add(r["privilegeIndex"])
        unique_nt.append(r)

payload["eligible_systems"]["nebula_tower"] = {
    "system_name": "Nebula Tower (برج السديم)",
    "source_enum": "gBuffSource.NEBULA_TOWER",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/nebulaWar/nebulaActivityCtrl.lua",
    "lua_function_code": """function nebulaActivityCtrl:getNebulaTowerBuffEffect(buffType)
	local buff = 0
	local curFloor = self:getCurPassFloor()
	local privilegeList = nebulaTowerLvDesRead:getPrivilegeListByFloor(curFloor)
	if privilegeList then
		for _, privilege in pairs(privilegeList) do
			if privilege.buffType == buffType then
				buff = buff + privilege.buffValue
			end
		end
	end
	return buff
end""",
    "live_memory_read_guidance": "Check conn.init_data for nebula activity tower progress (curFloor). Check tower_lv_privilege for all unlocked privilege indices with buffType 96, and sum the flat boost.",
    "filtered_records": unique_nt
}

# 4. PETS
path_pet = os.path.join(BASE_DIR, r"src\app\localtb\config_server\pet_level_conf.lua")
with open(path_pet, 'r', encoding='utf-8', errors='ignore') as f:
    text_pet = f.read()

pet_talents = sorted(list(set(re.findall(r'\b(1802\d{6})\b', text_pet))))
pet_records = []
for pt in pet_talents:
    val = int(pt[4:])
    pet_records.append({
        "talentSkillID": int(pt),
        "petAttributeType": 18,
        "mappedBuffEffect": 96,
        "march_troops_boost": val
    })

payload["eligible_systems"]["pets"] = {
    "system_name": "Pets Talent Skills (مواهب ومهارات الحيوانات الأليفة)",
    "source_enum": "gBuffSource.PET",
    "target_effect": 96,
    "mapping_formula": "buffAttribute_2_petAttribute[96] = gPetAttributeType.MARCH_VALUE_LIMIT_BOOST (18)",
    "lua_source_file": "src/app/module/pet/petCtrl.lua",
    "lua_function_code": """function petCtrl:getPetAttributeAdd(buffAttributeType)
	local attrType = buffAttribute_2_petAttribute[buffAttributeType] -- 96 -> 18
	if not attrType then return 0 end
	local ret = 0
	if self.petTalentData then
		for _, talent in pairs(self.petTalentData) do
			if talent.active and talent.attrType == attrType then
				ret = ret + talent.value
			end
		end
	end
	return ret
end""",
    "live_memory_read_guidance": "Read conn.init_data.pet_data. For each pet, check learned talent skills. Any skill starting with '1802' encodes petAttribute 18 (mapped to buff 96). The last 6 digits represent the flat troop count added to march.",
    "sample_filtered_records": pet_records[:20],
    "total_matching_skills_count": len(pet_records)
}

# 5. DIVINE BEAST
payload["eligible_systems"]["divine_beast"] = {
    "system_name": "Divine Beast Passive Skills (مهارات الوحوش الإلهية)",
    "source_enum": "gBuffSource.DIVINE_BEAST",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/divineBeast/divineBeastCtrl.lua",
    "lua_function_code": """function divineBeastCtrl:getBuffEffect(effectType)
	return self.buffDatas[effectType] or 0
end""",
    "live_memory_read_guidance": "Read conn.init_data.divine_beast (or divineBeastCtrl.buffDatas). If skill 1002 is unlocked, look up level in divine_beast_skill_config: Level 1=+4,000, Level 2=+8,000, Level 3=+14,000, Level 4=+20,000.",
    "filtered_records": [
        {"skillID": 100201, "level": 1, "buffType": 96, "march_troops_boost": 4000},
        {"skillID": 100202, "level": 2, "buffType": 96, "march_troops_boost": 8000},
        {"skillID": 100203, "level": 3, "buffType": 96, "march_troops_boost": 14000},
        {"skillID": 100204, "level": 4, "buffType": 96, "march_troops_boost": 20000}
    ]
}

# 6. MIRACULOUS WEAPON
payload["eligible_systems"]["miraculous_weapon"] = {
    "system_name": "Miraculous Weapon Resonance (رنين السلاح الإعجازي)",
    "source_enum": "gBuffSource.MIRACULOUS_WEAPON",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/equipment/miraculousWeaponCtrl.lua",
    "lua_function_code": """function miraculousWeaponCtrl:getBuffEffect(effectType)
	local effect = 0
	if type(self.weaponList) == "table" then
		for k, weaponInstance in pairs(self.weaponList) do
			effect = effect + self:queryWeaponCellEffect(weaponInstance, effectType)
		end
	end
	if type(self.userInfo) == "table" and type(self.userInfo.resonanceBuff) == "table" then
		for k, v in pairs(self.userInfo.resonanceBuff) do
			if effectType == v.buffType then
				effect = effect + v.value
			end
		end
	end
	return effect
end""",
    "live_memory_read_guidance": "Read conn.init_data.miraculous_weapon. Check userInfo.resonanceBuff: if resonance level 7 is reached (power >= 2,615,000), adds flat +24,000 troops. Also sum any weapon_buff where buffType == 96.",
    "filtered_records": [
        {
            "resonance_id": 7,
            "required_power": 2615000,
            "buffType": 96,
            "march_troops_boost": 24000
        }
    ]
}

# 7. HERO BIOGRAPHY
path_hbio = os.path.join(BASE_DIR, r"src\app\localtb\config_server\hero_biography_skill.lua")
with open(path_hbio, 'r', encoding='utf-8', errors='ignore') as f:
    lines_hbio = f.readlines()

hbio_records = []
cur_gid = None
cur_type = None
cur_skill = None
for i, l in enumerate(lines_hbio):
    m_s = re.search(r'\.skillID\s*=\s*(\d+)', l)
    if m_s:
        cur_skill = int(m_s.group(1))
    m_g = re.search(r'\.GroupID\s*=\s*(\d+)', l)
    if m_g:
        cur_gid = int(m_g.group(1))
    m_t = re.search(r'\.type\s*=\s*(\d+)', l)
    if m_t:
        cur_type = int(m_t.group(1))
    
    if re.search(r'\.buffType.*?[,=\s]96\b', l) and not re.search(r'496', l):
        for j in range(i, min(i+10, len(lines_hbio))):
            m_bn = re.search(r'\.buffNum.*?(\d+)\s*$', lines_hbio[j].strip())
            if m_bn:
                val = int(m_bn.group(1))
                hbio_records.append({
                    "skillID": cur_skill,
                    "groupID": cur_gid,
                    "type": cur_type,
                    "buffType": 96,
                    "march_troops_boost": val
                })
                break

seen_hbio = set()
unique_hbio = []
for r in hbio_records:
    key = (r["groupID"], r["type"], r["march_troops_boost"])
    if key not in seen_hbio:
        seen_hbio.add(key)
        unique_hbio.append(r)

payload["eligible_systems"]["hero_biography"] = {
    "system_name": "Hero Biography Skills (سيرة الأبطال)",
    "source_enum": "gBuffSource.HERO_BIOGRAPHY",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/hero/heroBiographyCtrl.lua",
    "lua_function_code": """function heroBiographyCtrl:queryHeroBiographyBuff(buffType)
	local ret = 0
	local heroBiographyRead = include("heroBiographyRead")
	for k, v in pairs(heroBiographyRead.skill) do
		if v.buffType then
			for i = 1, #v.buffType do
				if v.buffType[i] == buffType and self:isSkillActived(v.ID) then
					ret = ret + v.buffNum[i]
				end
			end
		end
	end
	return ret
end""",
    "live_memory_read_guidance": "Read conn.init_data.hero_biography. Check completed hero biography story missions/nodes: each activated biography node matching group 3, 5, or 8 adds +500 or +1200 soldiers.",
    "filtered_records": unique_hbio
}

# 8. HERO MASTERY
hm_records = [
    {"skillID": 17190701, "level": 1, "buffType": 96, "march_troops_boost": 1200},
    {"skillID": 17190702, "level": 2, "buffType": 96, "march_troops_boost": 1350},
    {"skillID": 17190703, "level": 3, "buffType": 96, "march_troops_boost": 1575},
    {"skillID": 17190704, "level": 4, "buffType": 96, "march_troops_boost": 1950},
    {"skillID": 17190705, "level": 5, "buffType": 96, "march_troops_boost": 2475},
    {"skillID": 17190706, "level": 6, "buffType": 96, "march_troops_boost": 3150},
    {"skillID": 17190707, "level": 7, "buffType": 96, "march_troops_boost": 3975},
    {"skillID": 17190708, "level": 8, "buffType": 96, "march_troops_boost": 4875},
    {"skillID": 17190709, "level": 9, "buffType": 96, "march_troops_boost": 5850},
    {"skillID": 17190710, "level": 10, "buffType": 96, "march_troops_boost": 7200}
]

payload["eligible_systems"]["hero_mastery_skills"] = {
    "system_name": "Hero Mastery Passive Skills (مهارات إتقان الأبطال)",
    "source_enum": "gBuffSource.HERO_SYSTEM",
    "target_effect": 96,
    "effect_name": "gBuffEffect.MARCH_VALUE_LIMIT_BOOST",
    "lua_source_file": "src/app/module/hero/heroCtrl.lua",
    "lua_function_code": """function heroCtrl:getHeroTotalPassiveBuff(buffEffect)
	local ret = 0
	if type(self.heroListInfo) == "table" then
		for k, v in pairs(self.heroListInfo) do
			if v.state ~= gHeroState.HERO_STATE_DEAD and v.state ~= gHeroState.HERO_STATE_CAPTURED then
				local value = self:getBuffValue(v, gSkillActiveType.PASSIVE_SKILL, buffEffect) or 0
				ret = ret + value
			end
		end
	end
	return ret
end""",
    "live_memory_read_guidance": "Read conn.init_data.heroListInfo. For every non-dead, non-captured hero, check their unlocked mastery skills. Skills 17190701 - 17190710 provide passive buffType 96 (from +1200 up to +7200 troops).",
    "filtered_records": hm_records
}

# 9. EQUIPMENT
payload["eligible_systems"]["equipment"] = {
    "system_name": "Military Equipment (المعدات العسكرية)",
    "source_enum": "gBuffSource.EQUIPMENT",
    "target_effect": 96,
    "mapping_formula": "buffEffectType_equipmentAdditionID[96] = gEquipmentBaseProperty.MARCH_VALUE_LIMIT_BOOST (78)",
    "lua_source_file": "src/app/module/equipment/equipmentAdditionMgr.lua",
    "lua_function_code": """function equipmentAdditionMgr.queryByBuffEffectType(effectType)
	local additionID = buffEffectType_equipmentAdditionID[effectType] -- 96 -> 78
	if additionID then
		return equipmentAdditionMgr.query(additionID) -- returns addition_list[78].total
	end
end""",
    "live_memory_read_guidance": "Read conn.init_data.equipment. For each worn equipment item (wear == 1), sum the property values where propertyType == 78 in its extra/refine property array.",
    "property_definition": {
        "propertyType": 78,
        "name": "gEquipmentBaseProperty.MARCH_VALUE_LIMIT_BOOST",
        "mapsToBuffEffect": 96
    }
}

# 10. CASTLE SKINS & DRESS SYSTEM
dress_records = [
    {"subType": 344, "name": "King March Queue Skin", "attributeID": 3, "attributeType": 5, "march_troops_boost": 1000, "scope": "ownAttribute"},
    {"subType": 375, "name": "King Star Battle Headframe", "attributeID": 3, "attributeType": 5, "march_troops_boost": 5000, "scope": "ownAttribute"},
    {"subType": 388, "name": "Special Castle Skin 388", "attributeID": 3, "attributeType": 5, "march_troops_boost": 1500, "scope": "ownAttribute"},
    {"subType": 422, "name": "Special Castle Skin 422", "attributeID": 3, "attributeType": 5, "march_troops_boost": 1500, "scope": "ownAttribute"},
    {"subType": 550, "name": "Special Castle Skin 550", "attributeID": 3, "attributeType": 5, "march_troops_boost": 1500, "scope": "ownAttribute"},
    {"subType": 551, "name": "Special Castle Skin 551", "attributeID": 3, "attributeType": 5, "march_troops_boost": 1500, "scope": "ownAttribute"},
    {"subType": 553, "name": "Special March Skin 553", "attributeID": 3, "attributeType": 5, "march_troops_boost": 1000, "scope": "ownAttribute"}
]

payload["eligible_systems"]["castle_skins_and_dress"] = {
    "system_name": "Castle Skins & Headframes (مظاهر القلعة والأطر ومسيرات الجيش)",
    "source_enum": "gAttributeSourceEnum.DRESS (1) via attributeSystem",
    "target_effect": 5,
    "effect_name": "gAttributeEnum.DISPATCH_TROOP_COUNT_NUM (5)",
    "mapping_formula": "attribute_config.lua: attrID = 3 -> attrType = 5 (DISPATCH_TROOP_COUNT_NUM)",
    "lua_source_file": "src/app/module/attribute/attributeSystem.lua",
    "lua_function_code": """function attributeSystem.query(attrType)
	local attr = attribute_list[attrType]
	if attr then
		return attr.total
	end
	return 0
end""",
    "live_memory_read_guidance": "Read conn.init_data.dress / castle_skin owned items list. For each owned skin/headframe/march dress, if its config in dress_type_config defines ownAttribute with attrID 3 (which maps to attrType 5), sum the flat troop value.",
    "filtered_records": dress_records
}

# INELIGIBLE SYSTEMS AUDIT
payload["ineligible_systems"] = {
    "military_rank": {
        "controller": "militaryRankCtrl",
        "reason": "Does not provide effect 96, 19, or attribute 5. Only provides troop attack, defense, HP, march speed, and wounded soldier conversion."
    },
    "hero_cenotaph": {
        "controller": "heroCenotaphCtrl",
        "reason": "Only provides troop attack, defense, HP, and march speed buffs."
    },
    "magic_lamp": {
        "controller": "magicLampCtrl",
        "reason": "Adventure rewards and decrees only. Has no getBuffEffect method and no march limit buffs."
    },
    "parliament_and_interior": {
        "controller": "intetiorCtrl",
        "reason": "Policies and decrees only grant buffType 7, 11, 13, and 18 (BUILD_SPEED_BOOST). None grant march limit boost 19 or 96."
    },
    "manor_garden": {
        "controller": "manorCityCtrl",
        "reason": "Farmland resonance only grants basic troop attributes 1, 3, 28 (attack, defense, HP)."
    },
    "exotic_pavilion": {
        "controller": "exoticPavilionCtrl",
        "reason": "Only provides intimacy and charm interaction buffs."
    },
    "alliance_prosperity_and_science": {
        "controller": "allianceScience",
        "reason": "Uses separate allianceSkillDef IDs; prosperity does not include effect 96 or 19."
    },
    "hero_appoint": {
        "controller": "heroAppointCtrl",
        "reason": "Config table hero_appoint.lua does not contain buffType 96, 19, or attribute 5."
    },
    "building_mastery": {
        "controller": "cityCtrl (BUILD_MASTERY)",
        "reason": "specialization_adding.lua only contains buffIDs 1 through 18. Does not contain buffType 96 or 19."
    },
    "kingdom_chronicles": {
        "controller": "legendMCtrl",
        "reason": "Only grants temporary attack, defense, and resource production buffs."
    }
}

out_path = r"e:\intqam-sultan\tools\verified_payload.json"
with open(out_path, 'w', encoding='utf-8') as fp:
    json.dump(payload, fp, indent=2, ensure_ascii=False)

print(f"Verified payload written successfully to {out_path} ({len(json.dumps(payload))} bytes)")
