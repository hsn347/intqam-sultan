local ltBase = include("ltBase")
local heroltCtrl = class("heroltCtrl", ltBase, include("aAReadClass").new())
function heroltCtrl:ctor()
	heroltCtrl.super.ctor(self)
end
function heroltCtrl:init()
	_ENV = nil
	;(nil)[1] = "hero_view_info"
	heroltCtrl:defineValue("herosInfo", nil)
	_ENV = nil
	;(nil)[1] = "hero_type_info"
	heroltCtrl:defineValue("heroClassesInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_upgrade_conf"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroUpgradeInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_level_config"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroLevelInfo", nil)
	_ENV = nil
	;(nil)[1] = "hero_skill_view_info"
	heroltCtrl:defineValue("heroSkillDesInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_skill_conf"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroSkillInfo", nil)
	_ENV = nil
	;(nil)[1] = "hero_skill_popview"
	heroltCtrl:defineValue("heroSkilPopInfo", nil)
	_ENV = nil
	;(nil)[1] = "hero_output_view"
	heroltCtrl:defineValue("heroChipInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "prison_hero_buff"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroJailAddBuff", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_awakeskill_config"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroAwakeSkill", nil)
	_ENV = nil
	;(nil)[1] = "hero_stuntskill_view"
	heroltCtrl:defineValue("heroStuntSkillInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_stuntskill_config"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroStuntSkillConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_change_config"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroChangeConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_masteryskill_config"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroMasteryskillCfg", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_awakeskill_xp"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroAwakeskillXp", nil)
	_ENV = nil
	;(nil)[1] = "hero_dress"
	heroltCtrl:defineValue("heroDressCfg", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_dress_server"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroDressSerCfg", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_tactics"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroTactics", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_combos_skill"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroCombosSkill", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_inherit_attr"
	;(nil)[2] = true
	heroltCtrl:defineValue("heroInheritAttr", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_inherit_awake"
	;(nil)[2] = true
	heroltCtrl:defineValue("hero_inherit_awake", nil)
	_ENV = nil
	;(nil)[1] = "hero_dress_output_view"
	heroltCtrl:defineValue("heroDressOutPut", nil)
	heroltCtrl:defineValue("heroStuntskillMasteryExp", function()
		heroltCtrl.heroStuntskillMasteryExp, heroltCtrl = nil, nil
		for k, v in ipairs(heroltCtrl.heroAwakeskillXp) do
			heroltCtrl.heroStuntskillMasteryExp[v.itemID] = v.masteryExp
		end
		return heroltCtrl.heroStuntskillMasteryExp
	end)
	heroltCtrl:defineValue("heroExchangeInfo", function()
		heroltCtrl.heroExchangeInfo, heroltCtrl = nil, nil
		for k, v in ipairs(heroltCtrl.heroChangeConfig) do
			heroltCtrl.heroExchangeInfo[v.itemID[1]], heroltCtrl = nil, nil
			heroltCtrl.heroExchangeInfo[v.itemID[1]].index = k
			heroltCtrl.heroExchangeInfo[v.itemID[1]].changeID = v.changeID[1]
			heroltCtrl.heroExchangeInfo[v.itemID[1]].changeNum = math.ceil(v.changeID[2] / v.itemID[2])
			if next(v.newTokenID) then
				heroltCtrl.heroExchangeInfo[v.itemID[1]].newTokenID = v.newTokenID[1]
				heroltCtrl.heroExchangeInfo[v.itemID[1]].newTokenNum = math.ceil(v.newTokenID[2] / v.itemID[2])
			end
			heroltCtrl.heroExchangeInfo[v.itemID[1]].masteryExp = heroltCtrl.heroStuntskillMasteryExp[v.itemID[1]]
		end
		return heroltCtrl.heroExchangeInfo
	end)
	heroltCtrl:defineValue("hero_palace_addition", function()
		heroltCtrl.hero_palace_addition, heroltCtrl = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.hero_palace_addition")
		for k, v in ipairs(cfg) do
			if not heroltCtrl.hero_palace_addition[v.palaceType] then
				heroltCtrl.hero_palace_addition[v.palaceType], heroltCtrl = nil, nil
			end
			table.insert(heroltCtrl.hero_palace_addition[v.palaceType], v)
		end
		return heroltCtrl.hero_palace_addition
	end)
	heroltCtrl:defineValue("hero_palace_buff_screen", function()
		heroltCtrl.hero_palace_buff_screen, heroltCtrl = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.hero_palace_buff_screen")
		for k, v in ipairs(cfg) do
			heroltCtrl.hero_palace_buff_screen[v.buffScreen] = true
		end
		return heroltCtrl.hero_palace_buff_screen
	end)
	heroltCtrl:defineValue("hero_palace_herotype", function()
		heroltCtrl.hero_palace_herotype, heroltCtrl = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.hero_palace_herotype")
		for k, v in ipairs(cfg) do
			heroltCtrl.hero_palace_herotype[v.palaceType] = v.heroID
		end
		return heroltCtrl.hero_palace_herotype
	end)
	local createData = function(name)
		heroltCtrl.stuntSkillByIDMap, heroltCtrl, heroltCtrl.stuntSkillData, heroltCtrl, heroltCtrl.stuntSkillConfig, heroltCtrl = nil, nil, nil, nil, nil, nil
		for k, v in ipairs(heroltCtrl.heroStuntSkillConfig) do
			local heroltCtrl, tmpData
			tmpData.heroID = v.heroID
			tmpData.skillID = v.skillID
			tmpData.unlockNum = v.unlockNum
			tmpData.propertyGroup = v.propertyGroup
			tmpData.basePower = v.basePower
			tmpData.extrePower = v.extrePower
			tmpData.buffData, heroltCtrl, tmpData.activeType = v.activeType, v.activeType, v.activeType
			local skillID = v.skillID
			tmpData.buffData.buffType = v.init_buff[1]
			tmpData.buffData.buffMode = v.init_buff[2]
			tmpData.buffData.min = v.init_buff[3]
			tmpData.buffData.max = v.init_buff[4]
			heroltCtrl.stuntSkillByIDMap[tostring(skillID)] = tmpData
			if not heroltCtrl.stuntSkillConfig[v.heroID] then
				heroltCtrl.stuntSkillConfig[v.heroID], heroltCtrl = skillID, skillID
				heroltCtrl.stuntSkillConfig[v.heroID].id = v.unlockNum[1]
				heroltCtrl.stuntSkillConfig[v.heroID].num = v.unlockNum[2]
				heroltCtrl.stuntSkillConfig[v.heroID].spId = v.unlockNum[4]
				heroltCtrl.stuntSkillConfig[v.heroID].spNum = v.unlockNum[5]
			end
			if not heroltCtrl.stuntSkillData[v.skillID] then
				heroltCtrl.stuntSkillData[v.skillID], heroltCtrl = skillID, skillID
				heroltCtrl.stuntSkillData[v.skillID].max = v.init_buff[4]
			end
		end
		if name == "stuntSkillConfig" then
			return heroltCtrl.stuntSkillConfig
		elseif name == "stuntSkillData" then
			return heroltCtrl.stuntSkillData
		elseif name == "stuntSkillByIDMap" then
			return heroltCtrl.stuntSkillByIDMap
		end
	end
	heroltCtrl:defineValue("stuntSkillConfig", createData)
	heroltCtrl:defineValue("stuntSkillData", createData)
	heroltCtrl:defineValue("stuntSkillByIDMap", createData)
	heroltCtrl:defineValue("stuntSkillInfo", function()
		heroltCtrl.stuntSkillInfo, heroltCtrl = nil, nil
		for k, v in ipairs(heroltCtrl.heroStuntSkillInfo) do
			heroltCtrl.stuntSkillInfo[v.skillID] = v
		end
		return heroltCtrl.stuntSkillInfo
	end)
	local createData4 = function(name)
		heroltCtrl.awakeInfo, heroltCtrl, heroltCtrl.heroAwakeConfig = require_data("hero_awake_config", true, true).data, require_data("hero_awake_config", true, true).data, require_data("hero_awake_config", true, true).data
		for k, v in ipairs(heroltCtrl.heroAwakeConfig) do
			v.item = v.itemID[1]
			v.itemCount = v.itemID[2]
			heroltCtrl.awakeInfo[v.heroID] = v
		end
		return heroltCtrl[name]
	end
	heroltCtrl:defineValue("heroAwakeConfig", createData4)
	heroltCtrl:defineValue("awakeInfo", createData4)
	local createData2 = function(name)
		heroltCtrl.awakeSKillByIDMap, heroltCtrl, heroltCtrl.awakeSillLvMap, heroltCtrl, heroltCtrl.awakeSkillInfo, heroltCtrl = nil, nil, nil, nil, nil, nil
		for k, v in ipairs(heroltCtrl.heroAwakeSkill) do
			local heroltCtrl, tmpData
			local skillType = v.skillID
			local realID = v.skillID * 1000 + v.lv
			local buffNum = #v.buffType
			tmpData.heroID = v.heroID
			tmpData.skillID = realID
			tmpData.buffList, heroltCtrl, tmpData.skillType = v.heroID, v.heroID, skillType
			tmpData.power = v.power
			for i = 1, buffNum do
				heroltCtrl = nil
				;(nil).activeType = v.activeType[i]
				;(nil).buffType = v.buffType[i]
				;(nil).buffMode = v.buffMode[i]
				;(nil).buffValue = v.buffValue[i]
				table.insert(tmpData.buffList, nil)
			end
			heroltCtrl.awakeSKillByIDMap[tostring(realID)] = tmpData
			if not heroltCtrl.awakeSkillInfo[v.heroID] then
				heroltCtrl.awakeSkillInfo[v.heroID] = v
			end
			if not heroltCtrl.awakeSillLvMap[v.heroID] or heroltCtrl.awakeSillLvMap[v.heroID] and not heroltCtrl.awakeSillLvMap[v.heroID][v.lv] then
				if not heroltCtrl.awakeSillLvMap[v.heroID] then
					heroltCtrl.awakeSillLvMap[v.heroID], heroltCtrl = realID, realID
				end
				if not heroltCtrl.awakeSillLvMap[v.heroID][v.lv] then
					heroltCtrl.awakeSillLvMap[v.heroID][v.lv] = v
				end
			end
		end
		if name == "awakeSkillInfo" then
			return heroltCtrl.awakeSkillInfo
		elseif name == "awakeSillLvMap" then
			return heroltCtrl.awakeSillLvMap
		elseif name == "awakeSKillByIDMap" then
			return heroltCtrl.awakeSKillByIDMap
		end
	end
	heroltCtrl:defineValue("awakeSkillInfo", createData2)
	heroltCtrl:defineValue("awakeSillLvMap", createData2)
	heroltCtrl:defineValue("awakeSKillByIDMap", createData2)
	heroltCtrl:defineValue("outputInfo", function()
		heroltCtrl.outputInfo, heroltCtrl = nil, nil
		for k, v in pairs(heroltCtrl.heroChipInfo) do
			heroltCtrl.outputInfo[v.heroID] = v
			heroltCtrl.outputInfo[v.heroID].chipID = k
		end
		return heroltCtrl.outputInfo
	end)
	heroltCtrl:defineValue("allHeroInfo", function()
		heroltCtrl.allHeroInfo, heroltCtrl = nil, nil
		for k, v in ipairs(gHeroTmpClose) do
			if heroltCtrl.herosInfo[v] then
				heroltCtrl.herosInfo[v] = nil
			end
		end
		for k, v in pairs(heroltCtrl.herosInfo) do
			if not self:isHeroUnLock(k) and heroltCtrl.herosInfo[k] then
				heroltCtrl.herosInfo[k] = nil
			end
		end
		for k, v in pairs(heroltCtrl.herosInfo) do
			table.insert(heroltCtrl.allHeroInfo, k)
		end
		table.sort(heroltCtrl.allHeroInfo)
		return heroltCtrl.allHeroInfo
	end)
	heroltCtrl:defineValue("heroRecruitInfo", function()
		heroltCtrl.heroRecruitInfo, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroUpgradeInfo) do
			if not heroltCtrl.heroRecruitInfo[v.heroID] then
				heroltCtrl.heroRecruitInfo[v.heroID], heroltCtrl = nil, nil
			end
			heroltCtrl.heroRecruitInfo[v.heroID][v.quality] = v
		end
		return heroltCtrl.heroRecruitInfo
	end)
	heroltCtrl:defineValue("heroCradItemMap", function()
		heroltCtrl.heroCradItemMap, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroUpgradeInfo) do
			if not heroltCtrl.heroCradItemMap[v.heroCard[1]] then
				heroltCtrl.heroCradItemMap[v.heroCard[1]] = v.heroID
			end
		end
		return heroltCtrl.heroCradItemMap
	end)
	heroltCtrl:defineValue("heroRare2LevelInfo", function()
		heroltCtrl.heroRare2LevelInfo, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroLevelInfo) do
			if not heroltCtrl.heroRare2LevelInfo[v.rarity] then
				heroltCtrl.heroRare2LevelInfo[v.rarity], heroltCtrl = nil, nil
			end
			heroltCtrl.heroRare2LevelInfo[v.rarity][v.level] = v
		end
		return heroltCtrl.heroRare2LevelInfo
	end)
	local createData3 = function(name)
		heroltCtrl.heroBuff2ActiveType, heroltCtrl, heroltCtrl.heroID2MaxQualitySkillInfo, heroltCtrl, heroltCtrl.heroSkillPopNeedInfo, heroltCtrl = nil, nil, nil, nil, nil, nil
		for _, v in ipairs(heroltCtrl.heroSkilPopInfo) do
			if not heroltCtrl.heroSkillPopNeedInfo[v.skillID] then
				heroltCtrl.heroSkillPopNeedInfo[v.skillID], heroltCtrl = nil, nil
			end
			heroltCtrl.heroSkillPopNeedInfo[v.skillID][v.quality] = v
			if not heroltCtrl.heroID2MaxQualitySkillInfo[v.heroID] then
				heroltCtrl.heroID2MaxQualitySkillInfo[v.heroID], heroltCtrl = nil, nil
			end
			heroltCtrl.heroID2MaxQualitySkillInfo[v.heroID][v.skillID] = v
			if not heroltCtrl.heroBuff2ActiveType[v.buffType] then
				heroltCtrl.heroBuff2ActiveType[v.buffType] = v.activeType
			end
		end
		if name == "heroSkillPopNeedInfo" then
			return heroltCtrl.heroSkillPopNeedInfo
		elseif name == "heroID2MaxQualitySkillInfo" then
			return heroltCtrl.heroID2MaxQualitySkillInfo
		elseif name == "heroBuff2ActiveType" then
			return heroltCtrl.heroBuff2ActiveType
		end
	end
	heroltCtrl:defineValue("heroSkillPopNeedInfo", createData3)
	heroltCtrl:defineValue("heroID2MaxQualitySkillInfo", createData3)
	heroltCtrl:defineValue("heroBuff2ActiveType", createData3)
	heroltCtrl:defineValue("heroSkillInfoMap", function()
		heroltCtrl.heroSkillInfoMap, heroltCtrl = nil, nil
		for k, v in pairs(heroltCtrl.heroSkillInfo) do
			heroltCtrl.heroSkillInfoMap[v.skillID] = v
		end
		return heroltCtrl.heroSkillInfoMap
	end)
	heroltCtrl:defineValue("heroMasterySkillMap", function()
		heroltCtrl.heroMasterySkillMap, heroltCtrl = nil, nil
		for k, v in pairs(heroltCtrl.heroMasteryskillCfg) do
			heroltCtrl.heroMasterySkillMap[tostring(v.skillID)] = v
		end
		return heroltCtrl.heroMasterySkillMap
	end)
	heroltCtrl:defineValue("heroMasteryMap", function()
		heroltCtrl.heroMasteryMap, heroltCtrl = nil, nil
		for k, v in ipairs(heroltCtrl.heroMasteryskillCfg) do
			if not heroltCtrl.heroMasteryMap[v.heroID] then
				heroltCtrl.heroMasteryMap[v.heroID], heroltCtrl = nil, nil
			end
			table.insert(heroltCtrl.heroMasteryMap[v.heroID], v)
		end
		return heroltCtrl.heroMasteryMap
	end)
	heroltCtrl:defineValue("heroAllCombosSkill", function()
		heroltCtrl.heroAllCombosSkill, heroltCtrl = nil, nil
		for _, v in pairs(heroltCtrl.heroDressSerCfg) do
			if v.combos and next(v.combos) then
				heroltCtrl = nil
				;(nil).skillGroup = v.combos
				;(nil).lieutenant = v.lieutenant
				;(nil).heroID = v.heroID
				;(nil).dressID = v.dressId
				table.insert(heroltCtrl.heroAllCombosSkill, nil)
			end
		end
		return heroltCtrl.heroAllCombosSkill
	end)
	heroltCtrl:defineValue("heroCombosSkillMap", function()
		heroltCtrl.heroCombosSkillMap, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroCombosSkill) do
			heroltCtrl.heroCombosSkillMap[tostring(v.skillID)] = v
		end
		return heroltCtrl.heroCombosSkillMap
	end)
	function _UPVALUE2_()
		heroltCtrl.heroCombosSkillMap, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroCombosSkill) do
			heroltCtrl.heroCombosSkillMap[tostring(v.skillID)] = v
		end
		return heroltCtrl.heroCombosSkillMap
	end
	;(function()
		heroltCtrl.heroCombosSkillMap, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroCombosSkill) do
			heroltCtrl.heroCombosSkillMap[tostring(v.skillID)] = v
		end
		return heroltCtrl.heroCombosSkillMap
	end)[1] = "hero_appoint"
	;(function()
		heroltCtrl.heroCombosSkillMap, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroCombosSkill) do
			heroltCtrl.heroCombosSkillMap[tostring(v.skillID)] = v
		end
		return heroltCtrl.heroCombosSkillMap
	end)[2] = true
	heroltCtrl:defineValue("hero_appoint", function()
		heroltCtrl.heroCombosSkillMap, heroltCtrl = nil, nil
		for _, v in ipairs(heroltCtrl.heroCombosSkill) do
			heroltCtrl.heroCombosSkillMap[tostring(v.skillID)] = v
		end
		return heroltCtrl.heroCombosSkillMap
	end)
	heroltCtrl:defineValue("hero_stuntskill_property", function()
		local config = require_data("hero_stuntskill_property", true, true).data
		local _ENV, ret = "hero_stuntskill_property", "hero_stuntskill_property"
		for _, v in ipairs(config) do
			if not ret[v.propertyGroup] then
				ret[v.propertyGroup], _ENV = nil, nil
			end
			table.insert(ret[v.propertyGroup], v)
		end
		return ret
	end)
	heroltCtrl:defineValue("sss_awake_stage", function()
		local config = require_data("sss_awake_stage", true, true).data
		local _ENV, ret = "sss_awake_stage", "sss_awake_stage"
		local stageID = 1
		for _, v in ipairs(config) do
			if not ret[v.heroId] then
				stageID = 1
				ret[v.heroId], _ENV = nil, nil
			end
			v.stageID = stageID
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
			table.insert(ret[v.heroId], v)
			stageID = stageID + 1
		end
		return ret
	end)
	heroltCtrl:defineValue("sss_awake_stage_gift", function()
		local config = require_data("sss_awake_stage_gift", true, true).data
		local _ENV, ret = "sss_awake_stage_gift", "sss_awake_stage_gift"
		for _, v in ipairs(config) do
			ret[v.rechargeID] = v
		end
		return ret
	end)
	heroltCtrl.canUpQualityHero = 0
end
heroltCtrl:init()
function heroltCtrl:getAllHeroCombosSkill()
	local _ENV, ret
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for _, v in ipairs(self.heroAllCombosSkill) do
		local heroInfo = heroCtrl:getHeroInfoByID(v.lieutenant)
		local heroQuality = heroInfo and heroInfo.quality or 1
		for _, skillGroup in ipairs(v.skillGroup) do
			local skillID = tonumber(skillGroup .. string.format("%02d", heroQuality))
			local skillInfo = self:getCombosSkillInfo(skillID)
			if skillInfo and skillInfo.skillType == 3 then
				local isActive = heroCtrl:isWearDressID(v.heroID, v.dressID)
				_ENV = v.dressID
				v.dressID.skillGroup = skillGroup
				v.dressID.skillID = skillID
				v.dressID.isActive = isActive
				v.dressID.heroID = v.heroID
				v.dressID.dressID = v.dressID
				table.insert(ret, v.dressID)
			end
		end
	end
	return ret
end
function heroltCtrl:getHeroInheritAttr()
	return heroltCtrl.heroInheritAttr
end
function heroltCtrl:getInheriAttrByLevel(level)
	for _, v in ipairs(heroltCtrl.heroInheritAttr) do
		if level >= v.heroLv[1] and level <= v.heroLv[2] then
			return v
		end
	end
end
function heroltCtrl:getInheriAttrAdd(level)
	local cfg
	for _, v in ipairs(heroltCtrl.heroInheritAttr) do
		if level and level >= v.heroLv[1] and level <= v.heroLv[2] then
			cfg = v
			break
		end
	end
	cfg = cfg or heroltCtrl.heroInheritAttr[#heroltCtrl.heroInheritAttr]
	return cfg
end
function heroltCtrl:getCombosSkillInfo(skillID)
	return self.heroCombosSkillMap[tostring(skillID)]
end
function heroltCtrl:getHeroDress(heroId)
	return heroltCtrl.herosInfo[heroId].dressUpId
end
function heroltCtrl:getHeroItemID(heroId)
	return heroltCtrl.herosInfo[heroId].itemID
end
function heroltCtrl:getHeroRarity(heroID)
	return heroltCtrl.herosInfo[heroID].rarity
end
function heroltCtrl:isHeroUnLock(heroID)
	local lockTime = heroltCtrl.herosInfo[heroID] and heroltCtrl.herosInfo[heroID].lockTime
	if not lockTime then
		return false
	end
	local isShow = true
	if 0 < lockTime and lockTime > serviceFunctions.systemTime() then
		isShow = false
	end
	return isShow
end
function heroltCtrl:getDressName(heroDressId)
	return heroltCtrl.heroDressCfg[heroDressId].heroDressName
end
function heroltCtrl:getDressNamePNG(heroDressId)
	return SoraDFIsRA() and heroltCtrl.heroDressCfg[heroDressId].heroDressNamePNGar or heroltCtrl.heroDressCfg[heroDressId].heroDressNamePNGen
end
function heroltCtrl:getDressNameLongPNG(heroDressId)
	return SoraDFIsRA() and string.format("heroDress_name_%d_ar_long.png", heroDressId) or string.format("heroDress_name_%d_en_long.png", heroDressId)
end
function heroltCtrl:getDressBeiJing(heroDressId)
	return heroltCtrl.heroDressCfg[heroDressId].beiJing
end
function heroltCtrl:getDressBaoshi(heroDressId)
	return heroltCtrl.heroDressCfg[heroDressId].baoShi
end
function heroltCtrl:getDressZhezhao(heroDressId)
	return heroltCtrl.heroDressCfg[heroDressId].zheZhao
end
function heroltCtrl:getDressCard(heroDressId)
	return heroltCtrl.heroDressCfg[heroDressId].heroCard
end
function heroltCtrl:getDressHerIcon(heroDressId)
	local icon = heroltCtrl.heroDressCfg[heroDressId].herIcon
	if icon == "" then
		local heroID = math.floor(heroDressId / 100)
		icon = string.format("Avatar_hero_%d.png", heroID)
	end
	return icon
end
function heroltCtrl:getDressViewBg(heroDressId)
	return heroltCtrl.heroDressCfg[heroDressId].viewBg, heroltCtrl.heroDressCfg[heroDressId].new == 1
end
function heroltCtrl:getDressSerCfg()
	return heroltCtrl.heroDressSerCfg
end
function heroltCtrl:getDressSerSkilCfg(skillID)
	local dressId = math.floor(skillID / 100)
	for _, v in ipairs(heroltCtrl.heroAllCombosSkill) do
		if SoraDisInList(dressId, v.skillGroup) then
			return v
		end
	end
end
function heroltCtrl:getOwnBuff(heroDressId)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "value"
	return serviceFunctions.tableFormat(heroltCtrl.heroDressSerCfg[heroDressId].getBuff, nil)
end
function heroltCtrl:getDressBuff(heroDressId)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "value"
	return serviceFunctions.tableFormat(heroltCtrl.heroDressSerCfg[heroDressId].dressBuff, nil)
end
function heroltCtrl:getDressActiveItem(heroDressId)
	return heroltCtrl.heroDressSerCfg[heroDressId].activationItem
end
function heroltCtrl:isDefaultDress(heroDressId)
	if not heroDressId then
		return true
	end
	return heroltCtrl.heroDressSerCfg[heroDressId].defaultDress == 1
end
function heroltCtrl:getDressLieutenant(heroDressId)
	return heroltCtrl.heroDressSerCfg[heroDressId].lieutenant
end
function heroltCtrl:getDressCombos(heroDressId)
	return heroltCtrl.heroDressSerCfg[heroDressId].combos
end
function heroltCtrl:getAllGetDressBuff()
	local _ENV, buffList
	for k, v in pairs(heroltCtrl.heroDressSerCfg) do
		if next(v.getBuff) then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "value"
			local buff = serviceFunctions.tableFormat(v.getBuff, nil)
			for ki, vi in ipairs(buff) do
				vi.heroID = v.heroID
				vi.dressID = v.dressId
				table.insert(buffList, vi)
			end
		end
	end
	table.sort(buffList, function(a, b)
		return a.id < b.id
	end)
	return buffList
end
function heroltCtrl:getAllHeroesChipsID()
	local _ENV, chipTable
	for k, v in pairs(heroltCtrl.heroChipInfo) do
		table.insert(chipTable, k)
	end
	return chipTable
end
function heroltCtrl:getHeroMasterPower(heroID)
	local power = 0
	heroID = tonumber(heroID)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local advanceInfo = heroCtrl:getHeroAdvancedSkillInfo(heroID)
	if self.heroMasterySkillMap[tostring(advanceInfo.skillID)] then
		power = self.heroMasterySkillMap[tostring(advanceInfo.skillID)].Power
	end
	return power
end
function heroltCtrl:getHeroPower(heroID, level, quality)
	local power = 0
	quality = tonumber(quality)
	heroID = tonumber(heroID)
	level = tonumber(level)
	if self.heroRecruitInfo and self.heroRecruitInfo[heroID] and self.heroRecruitInfo[heroID][quality] then
		local qualityPower = self.heroRecruitInfo[heroID][quality].power
		local heroType = self.heroRecruitInfo[heroID][quality].rarity
		local levelPower = 0
		local masterPower = self:getHeroMasterPower(heroID)
		if self.heroRare2LevelInfo[heroType] and self.heroRare2LevelInfo[heroType][level] then
			levelPower = self.heroRare2LevelInfo[heroType][level].power
		end
		power = qualityPower + levelPower + masterPower
	end
	return power
end
function heroltCtrl:getSkillMaxValue(skillID)
	if self.stuntSkillByIDMap[tostring(skillID)] then
		return self.stuntSkillByIDMap[tostring(skillID)].buffData.max
	end
end
function heroltCtrl:getCurPower(skillID, curValue)
	if self.stuntSkillByIDMap[tostring(skillID)] then
		local extrePower = self.stuntSkillByIDMap[tostring(skillID)].extrePower
		local maxValue = self:getSkillMaxValue(skillID)
		local curPower = math.floor(curValue / maxValue * extrePower)
		return curPower
	end
end
function heroltCtrl:getHeroAwakePower(heroID)
	if self.awakeInfo[heroID] then
		return self.awakeInfo[heroID].power
	end
	return 0
end
function heroltCtrl:querySkillBuffType(skillID)
	if self.heroSkillInfoMap[skillID] then
		return self.heroSkillInfoMap[skillID].buffType
	else
		return 0
	end
end
function heroltCtrl:querySkillBuffInfo(skillID)
	if self.heroSkillInfoMap[skillID] then
		return self.heroSkillInfoMap[skillID]
	else
		return nil
	end
end
function heroltCtrl:queryMasterySkillByID(skillID)
	if not self.awakeSKillByIDMap[tostring(skillID)] then
		_ENV = self.awakeSKillByIDMap[tostring(skillID)]
	end
	return self.awakeSKillByIDMap[tostring(skillID)]
end
function heroltCtrl:queryPowerSkillByID(skillID)
	if self.stuntSkillByIDMap[tostring(skillID)] then
		return self.stuntSkillByIDMap[tostring(skillID)]
	else
		_ENV = self.stuntSkillByIDMap[tostring(skillID)]
		return self.stuntSkillByIDMap[tostring(skillID)]
	end
end
function heroltCtrl:querySkillActiveType(skillID)
	if self.heroSkillInfoMap[skillID] then
		return self.heroSkillInfoMap[skillID].activeType
	else
		return 0
	end
end
function heroltCtrl:querySkillBuffMode(skillID)
	if self.heroSkillInfoMap[skillID] then
		return self.heroSkillInfoMap[skillID].buffMode
	else
		return 0
	end
end
function heroltCtrl:querySkillBuffValue(skillID)
	if self.heroSkillInfoMap[skillID] then
		return self.heroSkillInfoMap[skillID].buffValue
	else
		return 0
	end
end
function heroltCtrl:getHeroIDByItemID(itemID)
	local heroID
	for k, v in pairs(heroltCtrl.herosInfo) do
		if v.itemID == itemID then
			heroID = v.heroID
			break
		end
	end
	return heroID
end
function heroltCtrl:getHerosMarchCapacity(heros, needNormal)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local ret = 0
	for _, v in pairs(heros) do
		local hInfo = heroCtrl:getHeroInfoByID(v)
		if hInfo then
			local pType = heroltCtrl.herosInfo[v].rarity
			local lInfo = self.heroRare2LevelInfo[pType][hInfo.level]
			local value = math.floor(heroCtrl:getBuffValue(hInfo, gSkillActiveType.BATTLE_SKILL, gBuffEffect.MARCH_VALUE_LIMIT_BOOST)) or 0
			if needNormal then
				if hInfo.state == gHeroState.HERO_STATE_NORMAL then
					ret = ret + lInfo.march_add + value
				end
			else
				ret = ret + lInfo.march_add + value
				print("getHerosMarchCapacity=====", v, lInfo.march_add, value)
			end
		end
	end
	return ret
end
function heroltCtrl.filterHeroClass(classType, heroID)
	local heroVarType = type(heroID)
	local isInHeroList = function(classType, heroType)
		local ret = false
		if type(heroType) == "number" then
			ret = classType == heroType
		elseif type(heroType) == "table" then
			for k, v in ipairs(heroType) do
				if v == classType then
					ret = true
					break
				end
			end
		end
		return ret
	end
	if heroVarType == "number" or heroVarType == "string" then
		heroID = tonumber(heroID)
		if heroltCtrl.herosInfo[heroID] then
			return isInHeroList(classType, heroltCtrl.herosInfo[heroID].heroType)
		end
	elseif heroVarType == "table" then
		local _ENV, retTbl = isInHeroList, isInHeroList
		for _, v in ipairs(heroID) do
			local _id = tonumber(v)
			if heroltCtrl.herosInfo[_id] and isInHeroList(classType, heroltCtrl.herosInfo[_id].heroType) then
				table.insert(retTbl, _id)
			end
		end
		return retTbl
	end
end
function heroltCtrl.getHeroInfo(heroID)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	if not clone(heroltCtrl.herosInfo[tonumber(heroID)]) then
		local _ENV, info = clone(heroltCtrl.herosInfo[tonumber(heroID)]), clone(heroltCtrl.herosInfo[tonumber(heroID)])
	end
	local dressID = heroCtrl:getHeroDressSeting(heroID)
	local herIcon = info.herIcon
	local cardBg = info.cardBg
	local serCfg = heroltCtrl.heroDressSerCfg[dressID]
	if dressID and serCfg and serCfg.defaultDress ~= 1 then
		herIcon = heroltCtrl.heroDressCfg[dressID].herIcon
		cardBg = heroltCtrl.heroDressCfg[dressID].cardBg
	end
	info.herIcon = herIcon
	info.cardBg = cardBg
	return info
end
function heroltCtrl.getHeroInfoHerIcon(heroID)
	local info = heroltCtrl.herosInfo[tonumber(heroID)]
	return info.herIcon
end
function heroltCtrl.getHeroType(heroID)
	local info = heroltCtrl.getHeroInfo(heroID)
	local heroType = info.heroType
	local retType = heroType
	if type(heroType) == "number" then
		retType = heroType
	elseif type(heroType) == "table" then
		retType = heroType[1]
	end
	return retType
end
function heroltCtrl:getAllHeroID()
	return self.allHeroInfo
end
function heroltCtrl.getHeroClassTypeInfo(heroID, class)
	local heroInfo = heroltCtrl.getHeroInfo(heroID)
	if heroInfo then
		local class = class or heroltCtrl.getHeroType(heroID)
		return heroltCtrl.heroClassesInfo[class]
	end
end
function heroltCtrl.getHeroClassTypeName(class)
	return heroltCtrl.heroClassesInfo[class].typename
end
function heroltCtrl:getHeroLevelInfo(heroID, heroLv)
	local heroInfo = heroltCtrl.getHeroInfo(heroID)
	if heroInfo then
		return self.heroRare2LevelInfo[heroInfo.rarity][heroLv]
	end
end
function heroltCtrl:getUpgradeInfo(heroID, heroQuality)
	return self.heroRecruitInfo[heroID][heroQuality]
end
function heroltCtrl:getUpgradeActiveTime(heroID)
	return self.heroRecruitInfo[heroID][gHeroQuality.WHITE].activateTime or 0
end
function heroltCtrl:judgeUpgradeItem(heroID, quality)
	local info = self.heroRecruitInfo[heroID][quality or gHeroQuality.WHITE]
	if info then
		local itemID, needNum = info.heroCard[1], info.heroCard[2]
		local gametop = gModuleMgr.getObject("gametop")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local itemNum = backpackCtrl:getItemCount(itemID)
		return itemNum, needNum, itemID, needNum <= itemNum
	end
end
function heroltCtrl:judgeAwakeItem(heroID)
	local awakeInfo = self:getAwakeInfo(tonumber(heroID))
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local canAwake = false
	if awakeInfo then
		canAwake = awakeInfo.itemCount <= backpackCtrl:getItemCount(awakeInfo.item)
	end
	return canAwake
end
function heroltCtrl.getSkillDesInfo(sid)
	return heroltCtrl.heroSkillDesInfo[sid]
end
function heroltCtrl.getMaxQualitySkills(heroID)
	heroID = tonumber(heroID)
	local _ENV, retTbl = tonumber(heroID), tonumber(heroID)
	for _, v in ipairs(heroltCtrl.heroSkillInfo) do
		local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(v.heroID)
		if v.heroID == heroID and v.quality == maxQuality then
			table.insert(retTbl, v)
		end
	end
	return retTbl
end
function heroltCtrl:getSkillInfo(sid)
	return self.heroSkillPopNeedInfo[sid]
end
function heroltCtrl:getMaxQualitySkillInfoByHeroID(hid)
	hid = tonumber(hid)
	return self.heroID2MaxQualitySkillInfo[hid]
end
function heroltCtrl:getActiveByBuffType(buffType)
	return self.heroBuff2ActiveType[buffType]
end
function heroltCtrl:getSkillInfoByHeroID(hid, level, quality)
	local _ENV, desTbl
	if not self.heroID2MaxQualitySkillInfo[hid] then
		local _ENV, skillList = self.heroID2MaxQualitySkillInfo[hid], self.heroID2MaxQualitySkillInfo[hid]
	end
	if next(skillList) then
		local skillIDs = table.keys(skillList)
		table.sort(skillIDs)
		for _, v in ipairs(skillIDs) do
			local detailSkillID = tonumber(v .. string.format("%02d", quality))
			local limitLv = self.heroSkillInfoMap[detailSkillID].init_skill
			_ENV = quality
			quality.sid = v
			quality.data = self.heroSkillInfoMap[detailSkillID]
			quality.title = i18n(self.getSkillDesInfo(v).herName)
			quality.des = self:getSkillDes(v, quality)
			quality.isLock = level < limitLv
			quality.limitLv = limitLv
			table.insert(desTbl, quality)
		end
	end
	return desTbl
end
function heroltCtrl:getSkillDes(sid, quality)
	local buffDesRead = include("buffDesRead")
	local skillInfo = self.heroSkillPopNeedInfo[tonumber(sid)][tonumber(quality)]
	if skillInfo then
		return buffDesRead.getTitleWithValue(skillInfo.buffType, skillInfo.buffValue)
	end
end
function heroltCtrl:getSkillCfg(sid, quality)
	return self.heroSkillPopNeedInfo[tonumber(sid)][tonumber(quality)]
end
function heroltCtrl:getSomeSkillBuffValue(heros, buffid)
	local heroBuff = self:getSomeSkillValue(heros)
	return heroBuff[buffid] or 0
end
function heroltCtrl:getSomeSkillValue(heros, buffMode, lieuTenantHeros, revertHeros)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local bAllMode = false
	if not buffMode then
		bAllMode = true
	end
	local _ENV, retTab = "heroCtrl", "heroCtrl"
	for _, v in ipairs(heros) do
		local hInfo = heroCtrl:getHeroInfoByID(v)
		retTab = heroCtrl:getBuffList(retTab, hInfo, buffMode, bAllMode)
	end
	if commonCheck.HERO_COMBOS_SKILL and lieuTenantHeros then
		for _, v in ipairs(lieuTenantHeros) do
			local hInfo = heroCtrl:getHeroInfoByID(v)
			local mainHeroID = revertHeros and revertHeros[tostring(v)]
			retTab = heroCtrl:getLieutenantBuffList(retTab, hInfo, buffMode, bAllMode, mainHeroID)
		end
	end
	return retTab
end
function heroltCtrl:getSomeUnknowHerosSkillValue(herosTbl)
	local _ENV, effectTbls
	local executeSkillList = function(skillInfo)
		for k, v in pairs(skillInfo) do
			if not v.isLock then
				local skillData = v.data
				if not effectTbls[skillData.buffType] then
					effectTbls[skillData.buffType] = skillData.buffValue
				else
					effectTbls[skillData.buffType] = effectTbls[skillData.buffType] + skillData.buffValue
				end
			end
		end
	end
	for _, v in ipairs(herosTbl) do
		local ret = self:getSkillInfoByHeroID(v.heroID, v.level, v.quality)
		executeSkillList(ret)
	end
	return effectTbls
end
function heroltCtrl.getChipInfo(itemID)
	return heroltCtrl.heroChipInfo[itemID]
end
function heroltCtrl.getJailAttackBuffByLevel(lv)
	for _, v in ipairs(heroltCtrl.heroJailAddBuff) do
		if not v.grade[2] then
			return v.attack
		elseif lv >= v.grade[1] and lv <= v.grade[2] then
			return v.attack
		end
	end
end
function heroltCtrl.normalHeroHeadClick(heroID)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local info = heroCtrl:getHeroInfoByID(heroID)
	if info then
		if gHeroState.HERO_STATE_CAPTURED == info.state then
			_ENV = nil
			;(nil).heroID = heroID
			uiManager:show("HeroJailDetail", nil)
		else
			SoraDShowHeroDetailView(heroID)
		end
	end
end
function heroltCtrl.getLimitHeroLv(isAwaked)
	local lordLv = SoraDGetLordLv()
	local virLordLv = lordLv * 3
	if isAwaked then
		return gHeroAwakeMaxLevel, virLordLv >= gHeroAwakeMaxLevel
	else
		return math.min(virLordLv, gHeroMaxLevel), virLordLv >= gHeroMaxLevel
	end
end
function heroltCtrl:getAwakeInfo(heroID)
	return self.awakeInfo[heroID]
end
function heroltCtrl:getHeroBottomPointNum(...)
	local redNum = 0
	local needMildGuide = false
	local funUnlockRead = include("funUnlockRead")
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.HERO)
	if unlockLv > SoraDGetCastleLv() then
		return redNum
	end
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local judgeItemEnough = function(hid, _quality)
		local heroCard = self:getUpgradeInfo(hid, _quality).heroCard
		local itemNum = backpackCtrl:getItemCount(heroCard[1])
		if itemNum >= heroCard[2] then
			return true
		end
	end
	local upgradingHeroID = heroCtrl:getUpgradeQueue()
	for k, _ in pairs(heroltCtrl.herosInfo) do
		local info = heroCtrl:getHeroInfoByID(k)
		if info then
			local maxQuality = self:getHeroAwakeMaxQuality(k)
			if info.state == gHeroState.HERO_STATE_DEAD or info.state == gHeroState.HERO_STATE_CAPTURED then
				redNum = redNum + 1
			elseif upgradingHeroID and upgradingHeroID == k then
			elseif maxQuality > info.quality then
				if judgeItemEnough(k, info.quality + 1) then
					redNum = redNum + 1
					needMildGuide = k
				end
			elseif info.quality == maxQuality and info.level >= gHeroMaxLevel and not info.isAwake then
				local awakeInfo = self:getAwakeInfo(k)
				if awakeInfo.itemCount <= backpackCtrl:getItemCount(awakeInfo.item) then
					redNum = redNum + 1
					needMildGuide = k
				end
			end
		elseif judgeItemEnough(k, gHeroQuality.WHITE) then
			redNum = redNum + 1
		end
	end
	local retActive, numActive = heroCtrl:isHaveActiveRed()
	if retActive then
		redNum = redNum + numActive
	end
	if needMildGuide then
		heroltCtrl.canUpQualityHero = needMildGuide
		_ENV = nil
		;(nil).byUID = true
		if not SoraDConfigGet("Game:heroList:guide~table", nil) then
			local _ENV, guideData = SoraDConfigGet("Game:heroList:guide~table", nil), SoraDConfigGet("Game:heroList:guide~table", nil)
		end
		if not guideData.heroUpQuality then
			gModuleMgr.sharedMgr("mildGuideManager"):starToHeroUpQuality()
		end
	end
	local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
	local ret, num = heroNewTrialCtrl:getAllAfkStatusAndNum()
	if ret then
		redNum = redNum + num
	end
	return redNum
end
function heroltCtrl:getHeroNormalItemRedNum(heroID)
	local redNum = 0
	local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
	local __, getAwardNum = heroBiographyCtrl:isAllTaskFinish(heroID)
	redNum = redNum + getAwardNum
	local isStoryAwardGot = heroBiographyCtrl:isStoryAwardGot(heroID)
	if not isStoryAwardGot then
		redNum = redNum + 1
	end
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	if heroCtrl:isHeroHaveActiveRed(heroID) then
		redNum = redNum + 1
	end
	local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
	local rarity = self:getHeroRarity(heroID)
	local ret, num = heroNewTrialCtrl:getTrialAfkStatusAndNum(heroID)
	if ret and rarity == gHeroRarity.ORANGE then
		redNum = redNum + num
	end
	return redNum
end
function heroltCtrl:getHeroLockItemRedNum(heroID)
	local redNum = 0
	local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
	local ret, num = heroNewTrialCtrl:getReceiveStatusAndNum(heroID)
	if ret then
		redNum = redNum + num
	end
	return redNum
end
function heroltCtrl:getUpgradeGuideInfo()
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local judgeItemEnough = function(hid, _quality)
		local heroCard = self:getUpgradeInfo(hid, _quality).heroCard
		local itemNum = backpackCtrl:getItemCount(heroCard[1])
		if itemNum >= heroCard[2] then
			return true
		end
	end
	local guideHeroName = ""
	local isAllWhite = true
	for k, _ in pairs(heroltCtrl.herosInfo) do
		local info = heroCtrl:getHeroInfoByID(k)
		if info then
			local maxQuality = self:getHeroAwakeMaxQuality(k)
			if info.quality > gHeroQuality.WHITE then
				isAllWhite = false
			end
			if info.state == gHeroState.HERO_STATE_DEAD or info.state == gHeroState.HERO_STATE_CAPTURED then
			elseif maxQuality > info.quality and judgeItemEnough(k, info.quality + 1) and guideHeroName == "" then
				guideHeroName = heroltCtrl.getHeroName(k)
			end
		end
	end
	return isAllWhite, guideHeroName
end
function heroltCtrl:playHeroSound(heroID)
	if self.soundHandler then
		AudioEngine.stopEffect(self.soundHandler)
		self.soundHandler = nil
	end
	self.soundHandler = SoraDPlaySound("heroVoice", tonumber(heroID))
end
_UPVALUE3_, _ENV, _ENV, heroltCtrl.getQualityParticle = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170001], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170001], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170001], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170001], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170001], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170101], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170101], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170101], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170101], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170101], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170201], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170201], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170201], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170201], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170201], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170301], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170301], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170301], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170301], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170301], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170401], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170401], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170401], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170401], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170401], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170501], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170501], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170501], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170501], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170501], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170601], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170601], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170601], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170601], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170601], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170701], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170701], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170701], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170701], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170701], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170801], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170801], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170801], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170801], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170801], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170901], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170901], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170901], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170901], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[170901], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171001], heroltCtrl.isUsm = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171101], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171101], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171101], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171101], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171101], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171201], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171201], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171201], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171201], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171201], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171301], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171301], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171301], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171301], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171301], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171401], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171401], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171401], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171401], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171401], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171501], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171501], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171501], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171501], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171501], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171601], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171601], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171601], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171601], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171601], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171602], heroltCtrl.isUsm = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171701], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171701], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171701], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171701], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171701], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171801], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171801], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171801], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171801], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171801], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171901], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171901], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171901], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171901], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171901], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171902], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171902], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171902], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171902], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[171902], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172001], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172001], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172001], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172001], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172001], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172101], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172101], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172101], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172101], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172101], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172201], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172201], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172201], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172201], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172201], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172301], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172301], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172301], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172301], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172301], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172302], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172302], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172302], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172302], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172302], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172401], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172401], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172401], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172401], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172401], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172501], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172501], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172501], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172501], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172501], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172601], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172601], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172601], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172601], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172601], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172701], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172701], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172701], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172701], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172701], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172801], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172801], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172801], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172801], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172801], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172901], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172901], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172901], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172901], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[172901], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173001], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173001], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173001], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173001], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173001], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173101], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173101], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173101], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173101], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173101], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173201], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173201], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173201], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173201], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173201], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173301], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173301], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173301], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173301], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE3_, _ENV, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173301], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.detail, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.share, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE4_, heroltCtrl.story, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[3] = include("aAReadClass").new()
_UPVALUE3_, heroltCtrl.gift, include("aAReadClass").new()[4] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[1] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[2] = include("aAReadClass").new()
_UPVALUE5_, heroltCtrl.binary, include("aAReadClass").new()[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173401], heroltCtrl.binaryNew, include("aAReadClass").new()[1] = heroltCtrl, include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173401], heroltCtrl.binaryNew, include("aAReadClass").new()[2] = heroltCtrl, include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173401], heroltCtrl.binaryNew, include("aAReadClass").new()[3] = heroltCtrl, include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173401], heroltCtrl.binaryNew, include("aAReadClass").new()[4] = heroltCtrl, include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173401], heroltCtrl.binaryNew, include("aAReadClass").new()[5] = heroltCtrl, include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 100
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -30
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 10
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 20
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173402], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173402], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173402], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173402], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173402], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 100
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, 10
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -10
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -50
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173501], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173501], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173501], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173501], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173501], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 100
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -65
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -160
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173601], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173601], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173601], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173601], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173601], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 100
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -65
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -160
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173602], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173602], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173602], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173602], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173602], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -120
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -110
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -230
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, -50
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 50
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173701], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173701], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173701], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173701], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173701], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -100
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -200
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173801], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173801], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173801], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173801], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173801], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -100
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -100
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -180
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173802], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173802], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173802], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173802], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173802], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -80
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -180
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, -1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173901], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173901], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173901], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173901], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173901], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -80
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -180
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, -1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173902], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173902], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173902], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173902], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[173902], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -40
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174001], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174001], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174001], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174001], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174001], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -40
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174002], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174002], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174002], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174002], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174002], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -80
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -170
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174101], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174101], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174101], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174101], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174101], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, -50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -200
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -320
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, -1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174102], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174102], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174102], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174102], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174102], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -80
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -140
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174201], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174201], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174201], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174201], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174201], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 90
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -30
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, -20
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -100
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174202], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174202], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174202], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174202], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174202], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -240
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174301], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174301], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174301], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174301], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174301], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, -170
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -410
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 50
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -415
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, -160
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, -150
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[1] = 0.85, 0.85
include("aAReadClass").new().binaryNew, (0.85)[2] = 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[3] = 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[4] = 0.85, 3.33
include("aAReadClass").new().binaryNew, (0.85)[5] = 0.85, 3.33
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174302], include("aAReadClass").new().isUsm = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -240
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174401], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174401], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174401], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174401], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174401], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, -100
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -230
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -340
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174402], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174402], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174402], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174402], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174402], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 50
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 110
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -120
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174501], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174501], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174501], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174501], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174501], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, -60
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -300
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -380
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[1] = 0.85, 0.85
include("aAReadClass").new().binaryNew, (0.85)[2] = 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[3] = 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[4] = 0.85, 3.33
include("aAReadClass").new().binaryNew, (0.85)[5] = 0.85, 3.33
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174502], include("aAReadClass").new().isUsm = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -130
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 40
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -220
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174601], include("aAReadClass").new().binaryNew, (0.85)[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174601], include("aAReadClass").new().binaryNew, (0.85)[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174601], include("aAReadClass").new().binaryNew, (0.85)[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174601], include("aAReadClass").new().binaryNew, (0.85)[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174601], include("aAReadClass").new().binaryNew, (0.85)[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -300
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -380
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[1] = 0.85, 0.85
include("aAReadClass").new().binaryNew, (0.85)[2] = 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[3] = 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[4] = 0.85, 3.33
include("aAReadClass").new().binaryNew, (0.85)[5] = 0.85, 3.33
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174602], include("aAReadClass").new().isUsm = include("aAReadClass").new()
_UPVALUE3_, _ENV = 0.85, include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().detail, (0.85)[3] = 0.85, 0.85, -170
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().share, (0.85)[3] = 0.85, 0.85, -340
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[2] = 0.85, 0.85, 40
_UPVALUE4_, include("aAReadClass").new().story, (0.85)[3] = 0.85, 0.85, -120
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[1] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[2] = 0.85, 0.85, 1
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[3] = 0.85, 0.85, 0
_UPVALUE3_, include("aAReadClass").new().gift, (0.85)[4] = 0.85, 0.85, 100
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[1] = 0.85, 0.85, 0.85
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[2] = 0.85, 0.85, 0
_UPVALUE5_, include("aAReadClass").new().binary, (0.85)[3] = 0.85, 0.85, 0
include("aAReadClass").new().binaryNew, (0.85)[1] = 0.85, 0.85
include("aAReadClass").new().binaryNew, (0.85)[2] = 0.85, -78
include("aAReadClass").new().binaryNew, (0.85)[3] = 0.85, -425
include("aAReadClass").new().binaryNew, (0.85)[4] = 0.85, 2.23
include("aAReadClass").new().binaryNew, (0.85)[5] = 0.85, 2.23
include("aAReadClass").new().isUsm = true
include("aAReadClass").new().maxChunkSize = 96352
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174701], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.85
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", 0
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.85
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", 0
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", 0
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 3.33
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 3.33
include("aAReadClass").new().isUsm = true
include("aAReadClass").new().maxChunkSize = 102752
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174702], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -100
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -50
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
include("aAReadClass").new().maxChunkSize = 121024
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174801], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 130
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
include("aAReadClass").new().maxChunkSize = 132960
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174802], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -100
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -150
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
include("aAReadClass").new().maxChunkSize = 121024
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174901], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -70
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
include("aAReadClass").new().maxChunkSize = 132960
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[174902], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -100
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175001], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -340
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175002], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -100
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -270
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.85
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", 0
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175101], include("aAReadClass").new().binaryNew, ("is3S")[1] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175101], include("aAReadClass").new().binaryNew, ("is3S")[2] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175101], include("aAReadClass").new().binaryNew, ("is3S")[3] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175101], include("aAReadClass").new().binaryNew, ("is3S")[4] = include("aAReadClass").new()
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175101], include("aAReadClass").new().binaryNew, ("is3S")[5] = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -100
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -380
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.85
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", 0
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.85
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", 0
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", 0
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 3.33
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 3.33
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175102], include("aAReadClass").new().isUsm = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 60
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 130
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175201], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 60
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -330
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175202], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", -30
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 260
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175301], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175302], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 260
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175401], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 220
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175402], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 300
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175501], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 220
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175502], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 60
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175601], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 40
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", -20
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175602], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", 10
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 70
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
;(function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175701], include("aAReadClass").new().is3S = include("aAReadClass").new()
_UPVALUE3_, _ENV = "is3S", include("aAReadClass").new()
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().detail, ("is3S")[3] = "is3S", "is3S", -170
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[2] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().share, ("is3S")[3] = "is3S", "is3S", -300
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE4_, include("aAReadClass").new().story, ("is3S")[3] = "is3S", "is3S", 240
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[1] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[2] = "is3S", "is3S", 1
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[3] = "is3S", "is3S", 0
_UPVALUE3_, include("aAReadClass").new().gift, ("is3S")[4] = "is3S", "is3S", 100
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[1] = "is3S", "is3S", 0.8
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[2] = "is3S", "is3S", -20
_UPVALUE5_, include("aAReadClass").new().binary, ("is3S")[3] = "is3S", "is3S", -410
include("aAReadClass").new().binaryNew, ("is3S")[1] = "is3S", 0.8
include("aAReadClass").new().binaryNew, ("is3S")[2] = "is3S", -20
include("aAReadClass").new().binaryNew, ("is3S")[3] = "is3S", -510
include("aAReadClass").new().binaryNew, ("is3S")[4] = "is3S", 2
include("aAReadClass").new().binaryNew, ("is3S")[5] = "is3S", 2
include("aAReadClass").new().isUsm = true
heroltCtrl.heroSpineCriDef, (function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end)[175702], include("aAReadClass").new().is3S = function(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "et_yingxionglightwhite_%02d.plist"
	;(nil)[gHeroQuality.GREEN] = "et_yingxionglightgreen_%02d.plist"
	;(nil)[gHeroQuality.BLUE] = "et_yingxionglightblue_%02d.plist"
	;(nil)[gHeroQuality.PURPLE] = "et_yingxionglightpur_%02d.plist"
	;(nil)[gHeroQuality.ORANGE] = "et_yingxionglightred_%02d.plist"
	local (nil)[gHeroQuality.RED], plistFiles = "et_yingxionglightred_%02d.plist", nil
	quality = tonumber(quality)
	return string.format(plistFiles[quality], 1), string.format(plistFiles[quality], 2), string.format(plistFiles[quality], 3)
end, include("aAReadClass").new()
function heroltCtrl:getHeroSpineCfg(id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end
_ENV, _ENV = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[171301], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[171501], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[171601], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[171602], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[171901], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[171902], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172001], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172101], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172201], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172301], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172302], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172601], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172701], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[172901], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173001], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173101], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
_ENV, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173201], include("aAReadClass").new().offset = include("aAReadClass").new()
include("aAReadClass").new().scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173401], include("aAReadClass").new().offset = include("aAReadClass").new()
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173402], ("offset").offset = "offset", cc.p(10, -330)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173501], ("offset").offset = "offset", cc.p(0, -310)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173601], ("offset").offset = "offset", cc.p(-25, -440)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173602], ("offset").offset = "offset", cc.p(0, -320)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173701], ("offset").offset = "offset", cc.p(-80, -440)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173801], ("offset").offset = "offset", cc.p(30, -410)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173802], ("offset").offset = "offset", cc.p(-80, -390)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173901], ("offset").offset = "offset", cc.p(30, -380)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[173902], ("offset").offset = "offset", cc.p(-5, -410)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174001], ("offset").offset = "offset", cc.p(-10, -360)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174002], ("offset").offset = "offset", cc.p(30, -360)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174101], ("offset").offset = "offset", cc.p(-10, -390)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174102], ("offset").offset = "offset", cc.p(-10, -500)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174201], ("offset").offset = "offset", cc.p(0, -360)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174202], ("offset").offset = "offset", cc.p(-40, -350)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174301], ("offset").offset = "offset", cc.p(0, -450)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174302], ("offset").offset = "offset", cc.p(55, -460)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174401], ("offset").offset = "offset", cc.p(0, -400)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174402], ("offset").offset = "offset", cc.p(0, -500)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174501], ("offset").offset = "offset", cc.p(80, -300)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174502], ("offset").offset = "offset", cc.p(-20, -450)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174601], ("offset").offset = "offset", cc.p(-10, -445)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174602], ("offset").offset = "offset", cc.p(0, -340)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174701], ("offset").offset = "offset", cc.p(-15, -375)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174702], ("offset").offset = "offset", cc.p(55, -545)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174801], ("offset").offset = "offset", cc.p(-10, -330)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174802], ("offset").offset = "offset", cc.p(30, -200)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174901], ("offset").offset = "offset", cc.p(15, -480)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[174902], ("offset").offset = "offset", cc.p(0, -380)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175001], ("offset").offset = "offset", cc.p(-40, -300)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175002], ("offset").offset = "offset", cc.p(-40, -270)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175101], ("offset").offset = "offset", cc.p(15, -535)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175102], ("offset").offset = "offset", cc.p(0, -530)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175201], ("offset").offset = "offset", cc.p(70, -190)
_ENV = "offset"
;("offset").scale = 0.75
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175202], ("offset").offset = "offset", cc.p(0, -440)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175301], ("offset").offset = "offset", cc.p(-50, -165)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175302], ("offset").offset = "offset", cc.p(20, -480)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175401], ("offset").offset = "offset", cc.p(20, -200)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175402], ("offset").offset = "offset", cc.p(-15, -240)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175501], ("offset").offset = "offset", cc.p(0, -170)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175502], ("offset").offset = "offset", cc.p(60, -210)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175601], ("offset").offset = "offset", cc.p(45, -450)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175602], ("offset").offset = "offset", cc.p(20, -550)
_ENV = "offset"
;("offset").scale = 1.0
;(function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175701], ("offset").offset = "offset", cc.p(10, -455)
_ENV = "offset"
;("offset").scale = 1.0
heroltCtrl.cardSpineConfig, (function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end)[175702], ("offset").offset = function(self, id, param)
	if not param then
		param, _ENV = nil, nil
	end
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.heroSpineCriDef[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	if not cfg then
		return
	end
	local spineCfg
	if not param.useSpine and cfg.isUsm then
		if cfg.is3S then
			spineCfg = string.format("heroModle_%d_01.usm,heroModle_%d_02.usm", dressID, dressID)
		else
			spineCfg = string.format("heroModle_%d.usm", dressID)
		end
	else
		spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	end
	if display.height > 1200 and cfg.detail[3] < -70 then
		_UPVALUE3_ = cfg.detail[3]
		cfg.detail, cfg.detail[3][1] = cfg.detail[3], 1
		cfg.detail, cfg.detail[3][2] = cfg.detail[3], 0
		cfg.detail, cfg.detail[3][3] = cfg.detail[3], -70
	end
	return cfg, spineCfg
end, "offset", cc.p(60, -300)
function heroltCtrl:getHeroCardSpineCfg(id)
	local dressID = id
	if SoraDisInList(id, self.allHeroInfo) then
		dressID = heroltCtrl.herosInfo[id].dressUpId[1]
	end
	local cfg = heroltCtrl.cardSpineConfig[dressID]
	if not cfg then
		dressID = math.floor(dressID / 10) * 10 + 1
		cfg = heroltCtrl.heroSpineCriDef[dressID]
	end
	local spineCfg = string.format("spine/herosV/heroModle_%d.skel", dressID)
	return cfg, spineCfg
end
function heroltCtrl.getAllHeroAndDressID()
	local _ENV, cfg
	for k, v in pairs(heroltCtrl.herosInfo) do
		for ki, vi in ipairs(v.dressUpId) do
			_ENV = nil
			;(nil).heroID = v.heroID
			;(nil).dressID = vi
			table.insert(cfg, nil)
		end
	end
	table.sort(cfg, function(a, b)
		if a.heroID == b.heroID then
			return a.dressID < b.dressID
		else
			return a.heroID < b.heroID
		end
	end)
	return cfg
end
function heroltCtrl.getHeroDefaultDressID(hid)
	local dressID
	for k, v in pairs(heroltCtrl.herosInfo) do
		if v.heroID == hid then
			dressID = v.dressUpId[1]
			break
		end
	end
	return dressID
end
function heroltCtrl:isOwnMoreDress(heroId)
	local dressList = heroltCtrl.herosInfo[heroId].dressUpId
	return 1 < #dressList
end
function heroltCtrl:isHaveDressHero(heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end
function _ENV(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end
_ENV = "offset"
;("offset")[1702] = true
;("offset")[1707] = true
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).de, ("offset")[1715] = "offset", true
_ENV = "offset"
;("offset")[1700] = true
;("offset")[1702] = true
;("offset")[1704] = true
;("offset")[1706] = true
;("offset")[1707] = true
;("offset")[1708] = true
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).ru, ("offset")[1715] = "offset", true
_ENV = "offset"
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).fr, ("offset")[1704] = "offset", true
_ENV = "offset"
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).nl, ("offset")[1706] = "offset", true
_ENV = "offset"
;("offset")[1704] = true
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).ro, ("offset")[1707] = "offset", true
_ENV = "offset"
;("offset")[1700] = true
;("offset")[1704] = true
;("offset")[1707] = true
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).pt, ("offset")[1708] = "offset", true
_ENV = "offset"
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).tr, ("offset")[1715] = "offset", true
_ENV = "offset"
;("offset")[1700] = true
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).es, ("offset")[1707] = "offset", true
_ENV = "offset"
;("offset")[1700] = true
;(function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).it, ("offset")[1708] = "offset", true
_ENV = "offset"
;("offset")[1700] = true
;("offset")[1702] = true
;("offset")[1703] = true
;("offset")[1706] = true
;("offset")[1708] = true
heroltCtrl.longHeroNamePng, (function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end).vi, ("offset")[1715] = function(self, heros)
	local ret = false
	local add = 0
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	for k, v in ipairs(heros) do
		if heroltCtrl:isOwnMoreDress(v) then
			ret = true
			add = add + heroCtrl:getDressAdd(v)
		end
	end
	print("ret,add====", ret, add)
	return ret, add
end, "offset", true
function heroltCtrl.getHeroName(heroID)
	local info = heroltCtrl.getHeroInfo(heroID)
	return info.herName
end
function heroltCtrl.getHeroNamePng(heroID, needLong)
	local info = heroltCtrl.getHeroInfo(heroID)
	local lang = SoraDGetDefaultLanguage()
	if needLong and heroltCtrl.longHeroNamePng[lang] and heroltCtrl.longHeroNamePng[lang][heroID] then
		return string.format("%s_02_%s.png", info.name, lang)
	elseif lang == "en" and not IsArClient and heroID == 1722 then
		return string.format("%s_%s_ros.png", info.name, lang)
	else
		return lang == "ar" and string.format("%s.png", info.name) or string.format("%s_%s.png", info.name, lang)
	end
end
function heroltCtrl.getHeroChip(heroID)
	local info = heroltCtrl.getHeroInfo(heroID)
	local publicRead = include("publicRead")
	return publicRead.getIcon(info.itemID)
end
function heroltCtrl.getHeroCardBg(heroID)
	local info = heroltCtrl.getHeroInfo(heroID)
	return info.cardBg
end
function heroltCtrl.getHeroViewBg(heroID)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local dressID = heroCtrl:getHeroDressSeting(heroID)
	if dressID and heroltCtrl.heroDressSerCfg[dressID].defaultDress ~= 1 then
		return heroltCtrl.heroDressCfg[dressID].viewBg, heroltCtrl.heroDressCfg[dressID].new == 1
	else
		local info = heroltCtrl.getHeroInfo(heroID)
		return info.viewBg, info.new == 1
	end
end
function heroltCtrl.getCardFrmBg(quality, fromMemory)
	quality = tonumber(quality)
	local fileName = "frame_YX_pinzhi_hui.png"
	_ENV = quality
	quality[gHeroQuality.WHITE] = "frame_YX_pinzhi_hui.png"
	quality[gHeroQuality.GREEN] = "frame_YX_pinzhi_lv.png"
	quality[gHeroQuality.BLUE] = "frame_YX_pinzhi_lan.png"
	quality[gHeroQuality.PURPLE] = "frame_YX_pinzhi_zi.png"
	quality[gHeroQuality.ORANGE] = "frame_YX_pinzhi_huang.png"
	local quality[gHeroQuality.RED], suitTbl = "frame_YX_pinzhi_hong.png", quality
	fileName = suitTbl[quality] or fileName
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl:getRarity(heroID)
	return self.outputInfo[heroID] and self.outputInfo[heroID].rarity
end
function heroltCtrl:getChipID(heroID)
	return self.outputInfo[heroID] and self.outputInfo[heroID].chipID
end
function heroltCtrl:getAwakeSkill(heroID)
	return self.awakeSkillInfo[heroID]
end
function heroltCtrl:getAwakeLvSkillData(heroID, lv)
	return self.awakeSillLvMap[heroID][lv]
end
function heroltCtrl:getStuntSkillInfo(skillID)
	return self.stuntSkillInfo[skillID]
end
function heroltCtrl:getAwakeCost(heroID)
	return self.stuntSkillConfig[heroID]
end
function heroltCtrl:getMaxBuffValue(skillID)
	if not skillID or not self.stuntSkillData then
		return 0
	end
	local info = self.stuntSkillData[skillID]
	if not info then
		return 0
	end
	return tonumber(info.max) or 0
end
function heroltCtrl:getExchangeInfo(chipID)
	return self.heroExchangeInfo[chipID]
end
function heroltCtrl:getCardRareImg(heroID)
	local rarity = self:getHeroRarity(heroID) or gHeroRarity.WHITE
	local fileName = "icon_hero_B.png"
	_ENV = heroID
	_ENV = nil
	;(nil).png = "icon_hero_B.png"
	heroID[gHeroRarity.WHITE], (nil).color = nil, cc.c3b(0, 255, 0)
	_ENV = nil
	;(nil).png = "icon_hero_A.png"
	heroID[gHeroRarity.GREEN], (nil).color = nil, cc.c3b(0, 185, 255)
	_ENV = nil
	;(nil).png = "icon_hero_S.png"
	heroID[gHeroRarity.BLUE], (nil).color = nil, cc.c3b(255, 0, 255)
	_ENV = nil
	;(nil).png = "icon_hero_SS.png"
	heroID[gHeroRarity.PURPLE], (nil).color = nil, cc.c3b(255, 190, 60)
	_ENV = nil
	;(nil).png = "icon_hero_SSS.png"
	heroID[gHeroRarity.ORANGE], (nil).color = nil, cc.c3b(224, 43, 43)
	local suitTbl = heroID
	fileName = suitTbl[rarity] and suitTbl[rarity].png or fileName
	local color = suitTbl[rarity] and suitTbl[rarity].color or cc.c3b(0, 255, 0)
	return fileName, rarity, color
end
function heroltCtrl.getBg(quality, fromMemory)
	quality = tonumber(quality)
	local fileName = "frame_YXpingzhi_01.png"
	_ENV = quality
	quality[gHeroQuality.WHITE] = "frame_item_base_01.png"
	quality[gHeroQuality.GREEN] = "frame_item_base_02.png"
	quality[gHeroQuality.BLUE] = "frame_item_base_03.png"
	quality[gHeroQuality.PURPLE] = "frame_item_base_04.png"
	quality[gHeroQuality.ORANGE] = "frame_item_base_05.png"
	local quality[gHeroQuality.RED], suitTbl = "frame_item_base_07.png", quality
	fileName = suitTbl[quality] or fileName
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl.getFlagSkillBg(quality, fromMemory)
	quality = tonumber(quality)
	local fileName = "frame_YX_xiaoqizhi01.png"
	_ENV = quality
	quality[gHeroQuality.WHITE] = "frame_YX_xiaoqizhi01.png"
	quality[gHeroQuality.GREEN] = "frame_YX_xiaoqizhi02.png"
	quality[gHeroQuality.BLUE] = "frame_YX_xiaoqizhi03.png"
	quality[gHeroQuality.PURPLE] = "frame_YX_xiaoqizhi04.png"
	quality[gHeroQuality.ORANGE] = "frame_YX_xiaoqizhi05.png"
	local quality[gHeroQuality.RED], suitTbl = "frame_YX_xiaoqizhi05.png", quality
	fileName = suitTbl[quality] or fileName
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl.getHeroQuality2Word(quality)
	_ENV = nil
	;(nil)[gHeroQuality.WHITE] = "common_text_1900"
	;(nil)[gHeroQuality.GREEN] = "common_text_1901"
	;(nil)[gHeroQuality.BLUE] = "common_text_1902"
	;(nil)[gHeroQuality.PURPLE] = "common_text_1903"
	;(nil)[gHeroQuality.ORANGE] = "common_text_1904"
	local (nil)[gHeroQuality.RED], suitTbl = "common_text_4827", nil
	return suitTbl[quality] and i18n(suitTbl[quality]) or "NA"
end
function heroltCtrl.getSkillBg(quality, fromMemory)
	quality = tonumber(quality)
	local fileName = "icon_hero_gray.png"
	_ENV = quality
	quality[gHeroQuality.WHITE] = "icon_hero_gray.png"
	quality[gHeroQuality.GREEN] = "icon_hero_green.png"
	quality[gHeroQuality.BLUE] = "icon_hero_blue.png"
	quality[gHeroQuality.PURPLE] = "icon_hero_purple.png"
	quality[gHeroQuality.ORANGE] = "icon_hero_red.png"
	local quality[gHeroQuality.RED], suitTbl = "icon_hero_redplus.png", quality
	fileName = suitTbl[quality] or fileName
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl.getCubeBg(quality, fromMemory)
	quality = tonumber(quality)
	local fileName = "frame_item_base_01.png"
	_ENV = quality
	quality[gHeroQuality.WHITE] = "frame_item_base_01.png"
	quality[gHeroQuality.GREEN] = "frame_item_base_02.png"
	quality[gHeroQuality.BLUE] = "frame_item_base_03.png"
	quality[gHeroQuality.PURPLE] = "frame_item_base_04.png"
	quality[gHeroQuality.ORANGE] = "frame_item_base_05.png"
	local quality[gHeroQuality.RED], suitTbl = "frame_item_base_07.png", quality
	fileName = suitTbl[quality] or fileName
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl.getJailStateLoadBar(state, fromMemory)
	state = tonumber(state)
	local fileName = "progressbar_01_red.png"
	_ENV = state
	state[gHeroJailState.waiting] = "progressbar_alliance_yellow.png"
	state[gHeroJailState.execute] = "progressbar_01_red.png"
	local state[gHeroJailState.escape], suitTbl = "progressbar_01_green1.png", state
	fileName = suitTbl[state] or fileName
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl.getJailStateColor(state)
	_ENV, state = tonumber(state), tonumber(state)
	tonumber(state)[gHeroJailState.waiting] = cc.c3b(220, 150, 90)
	tonumber(state)[gHeroJailState.execute] = cc.c3b(250, 40, 40)
	local tonumber(state)[gHeroJailState.escape], suitTbl = cc.c3b(0, 190, 30), tonumber(state)
	local color = cc.c3b(250, 40, 40)
	color = suitTbl[state] or color
	return color
end
function heroltCtrl.getQuality2Des(quality)
	_ENV, quality = tonumber(quality), tonumber(quality)
	tonumber(quality)[gHeroQuality.WHITE] = i18n("common_text_1900")
	tonumber(quality)[gHeroQuality.GREEN] = i18n("common_text_1901")
	tonumber(quality)[gHeroQuality.BLUE] = i18n("common_text_1902")
	tonumber(quality)[gHeroQuality.PURPLE] = i18n("common_text_1903")
	tonumber(quality)[gHeroQuality.ORANGE] = i18n("common_text_1904")
	local tonumber(quality)[gHeroQuality.RED], suitTbl = i18n("common_text_4827"), tonumber(quality)
	return suitTbl[quality] or "NA"
end
function heroltCtrl.getQualityColor(quality)
	_ENV, quality = tonumber(quality), tonumber(quality)
	tonumber(quality)[gHeroQuality.WHITE] = cc.c3b(230, 230, 230)
	tonumber(quality)[gHeroQuality.GREEN] = cc.c3b(0, 255, 0)
	tonumber(quality)[gHeroQuality.BLUE] = cc.c3b(0, 185, 255)
	tonumber(quality)[gHeroQuality.PURPLE] = cc.c3b(255, 0, 255)
	tonumber(quality)[gHeroQuality.ORANGE] = cc.c3b(255, 190, 60)
	local tonumber(quality)[gHeroQuality.RED], colorTbl = cc.c3b(255, 27, 26), tonumber(quality)
	return colorTbl[quality] or colorTbl[gHeroQuality.WHITE]
end
function heroltCtrl.getStateDes(state)
	_ENV, state = tonumber(state), tonumber(state)
	tonumber(state)[gHeroState.HERO_STATE_NORMAL] = i18n("hero_text_75")
	tonumber(state)[gHeroState.HERO_STATE_DEAD] = i18n("chapter_name_807")
	tonumber(state)[gHeroState.HERO_STATE_CAPTURED] = i18n("hero_text_76")
	tonumber(state)[gHeroState.HERO_STATE_BATTLE] = i18n("hero_text_77")
	tonumber(state)[gHeroState.HERO_STATE_DEFEND] = i18n("common_text_306")
	local tonumber(state)[gHeroState.HERO_STATE_ESCAPE], suitTbl = i18n("hero_text_78"), tonumber(state)
	return suitTbl[state] or "NA"
end
function heroltCtrl.getMSkillID(heroID)
	return tonumber(tostring(heroID) .. "07")
end
function heroltCtrl:getAdvancedSkillPercent(heroID, level, exp)
	local nextLv = math.min(10, level + 1)
	local nextSkillID = string.format("%d07%.2d", heroID, nextLv)
	local nextInfo = self.heroMasterySkillMap[nextSkillID]
	return math.min(100, exp / nextInfo.EXP * 100), nextInfo.EXP
end
function heroltCtrl:getAdvancedSkillFullEXP(heroID, level, exp)
	local needExp = 0
	local nextLv = math.min(10, level + 1)
	local nextSkillID = string.format("%d07%.2d", heroID, nextLv)
	local nextInfo = self.heroMasterySkillMap[nextSkillID]
	needExp = nextInfo.EXP - exp
	if nextLv < 10 then
		for lv = math.min(10, nextLv + 1), 10 do
			local skillID = string.format("%d07%.2d", heroID, lv)
			local info = self.heroMasterySkillMap[skillID]
			needExp = info.EXP + needExp
		end
	end
	return needExp
end
function heroltCtrl:getMasterySkillInfo(skillID)
	return self.heroMasterySkillMap[tostring(skillID)]
end
function heroltCtrl:getMaxAdvancedLv(heroID)
	return heroltCtrl.heroMasteryMap[heroID][#heroltCtrl.heroMasteryMap[heroID]].lv
end
function heroltCtrl:getMaxAdvancedCfg(heroID)
	if heroltCtrl.heroMasteryMap[heroID] then
		local maxCfg = heroltCtrl.heroMasteryMap[heroID][#heroltCtrl.heroMasteryMap[heroID]]
		return maxCfg.skillID, maxCfg.lv
	end
end
function heroltCtrl:getAdvancedSkillInfoByHeroLv(heroID, lv)
	for k, v in ipairs(heroltCtrl.heroMasteryskillCfg) do
		if v.heroID == heroID and v.lv == lv then
			return v
		end
	end
end
function heroltCtrl:isHeroUSkillFull(powerSkill, bActive)
	local ret = true
	if bActive then
		return true
	end
	for k, v in pairs(powerSkill) do
		local maxV = self.stuntSkillData[v.skillID].max
		if maxV > v.buffValue then
			ret = false
			break
		end
	end
	return ret
end
function heroltCtrl:getAllHeroChipID()
	local _ENV, chips
	for k, v in pairs(heroltCtrl.herosInfo) do
		_ENV = nil
		;(nil).itemID = v.itemID
		;(nil).heroID = v.heroID
		;(nil).rarity = self:getRarity(v.heroID)
		table.insert(chips, nil)
	end
	table.sort(chips, function(a, b)
		if a.rarity == b.rarity then
			return a.itemID < b.itemID
		else
			return a.rarity < b.rarity
		end
	end)
	return chips
end
function heroltCtrl:getAdvancedSkillFeedEXP(itemID)
	return self.heroStuntskillMasteryExp[itemID] or 0
end
function heroltCtrl:getIsHeroTacticOpen()
	return table.nums(self.heroTactics) > 0
end
function heroltCtrl:getTacticsByHeroID(heroID)
	local _ENV, list
	for k, v in pairs(self.heroTactics) do
		for k2, v2 in pairs(v.heroGroupID) do
			if v2 == heroID then
				table.insert(list, v)
				break
			end
		end
	end
	return list
end
function heroltCtrl:getTacticsDesc(descValue)
	if not descValue or descValue == "" then
		return ""
	end
	local strs = string.split(descValue, ";")
	local i18nkey = strs[1]
	local _ENV, i18nValue = ";", ";"
	for k, v in pairs(strs) do
		if k ~= 1 then
			local values = string.split(v, "=")
			if #values == 2 then
				i18nValue[values[1]] = values[2]
			end
		end
	end
	return i18n(i18nkey, i18nValue)
end
function heroltCtrl:getClassIcon(heroType)
	_ENV, heroType = tonumber(heroType), tonumber(heroType)
	tonumber(heroType)[1] = "icon_xzyx_ms.png"
	tonumber(heroType)[2] = "icon_xzyx_pb.png"
	tonumber(heroType)[3] = "icon_xzyx_qs.png"
	tonumber(heroType)[4] = "icon_xzyx_gj.png"
	local tonumber(heroType)[5], suitTbl = "icon_xzyx_d.png", tonumber(heroType)
	local fileName = suitTbl[heroType]
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function heroltCtrl:getDressOutPutInfo(itemID)
	local _ENV, cfg
	for k, v in ipairs(heroltCtrl.heroDressOutPut) do
		if v.itemID == itemID then
			table.insert(cfg, v)
		end
	end
	return cfg
end
function heroltCtrl:getAllAwakeSkillItem(heroID)
	local _ENV, chipArray
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local heroRarity = self:getHeroRarity(heroID)
	for i, v in ipairs(heroltCtrl.heroAwakeskillXp) do
		local count = backpackCtrl:getItemCount(v.itemID)
		if 0 < count then
			local _heroID = self:getHeroIDByItemID(v.itemID)
			local isHave = true
			if _heroID and not heroCtrl:getHeroInfoByID(_heroID) then
				isHave = false
			end
			local rarity = self:getItemRarity(v.itemID)
			local goodType = backpackltCtrl:getItemType(v.itemID)
			if v.heroID and not next(v.heroID) then
				_ENV = nil
				;(nil).id = v.itemID
				;(nil).count = count
				;(nil).rarity = rarity
				;(nil).goodType = goodType
				;(nil).heroID = _heroID
				;(nil).isHave = isHave
				table.insert(chipArray, nil)
			end
			if v.heroID and next(v.heroID) then
				for _, id in ipairs(v.heroID) do
					if id == heroID then
						_ENV = nil
						;(nil).id = v.itemID
						;(nil).count = count
						;(nil).rarity = rarity
						;(nil).goodType = goodType
						;(nil).heroID = _heroID
						;(nil).isHave = isHave
						table.insert(chipArray, nil)
					end
				end
			end
		end
	end
	dump(chipArray, "getAllAwakeSkillItem chipArray========")
	table.sort(chipArray, function(a, b)
		if a.isHave and not b.isHave then
			return true
		end
		if not a.isHave and b.isHave then
			return false
		end
		if a.goodType ~= b.goodType then
			return a.goodType < b.goodType
		end
		if a.rarity == b.rarity then
			return a.id < b.id
		else
			return a.rarity < b.rarity
		end
	end)
	return chipArray
end
function heroltCtrl:getItemRarity(itemID)
	local info = heroltCtrl.getChipInfo(itemID)
	if info then
		return self:getRarity(info.heroID)
	end
	return 0
end
function heroltCtrl:isAwakeSkillItem(itemID)
	return heroltCtrl.heroStuntskillMasteryExp[itemID]
end
function heroltCtrl:getHeroPalaceAdditionCfg(heroType)
	if not heroType then
		return heroltCtrl.hero_palace_addition
	end
	if not heroltCtrl.hero_palace_addition[heroType] then
		heroltCtrl = heroltCtrl.hero_palace_addition[heroType]
	end
	return heroltCtrl.hero_palace_addition[heroType]
end
function heroltCtrl:getHeroPalaceType(tag)
	_ENV = nil
	;(nil)[1] = gHeroType.INFANTRY
	;(nil)[2] = gHeroType.CAVALRY
	local (nil)[3], heroTypeTag = gHeroType.ARCHER, nil
	return heroTypeTag[tag]
end
function heroltCtrl:getHerosByPalaceType(palaceType)
	return heroltCtrl.hero_palace_herotype[palaceType]
end
function heroltCtrl:isScreenBuff(buffType)
	return heroltCtrl.hero_palace_buff_screen[buffType] or false
end
function heroltCtrl:getHeroAppointAttr(heroID)
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	local _ENV, attrTb = heroCtrl, heroCtrl
	local cfg = heroltCtrl.hero_appoint[heroID]
	if cfg then
		for k, v in ipairs(cfg.basicAttribute) do
			table.insert(attrTb, v + (heroInfo.level - 1) * cfg.perLevelAdd[k])
		end
	end
	return attrTb
end
function heroltCtrl:getReshapeBasicNum(heroRarity, sumPercent)
	for k, v in ipairs(heroltCtrl.hero_stuntskill_property[heroRarity]) do
		if sumPercent >= v.match[1] and sumPercent <= v.match[2] then
			return v.basicNum
		end
	end
	return 0
end
function heroltCtrl:getHeroAwakeStage(heroID)
	return heroltCtrl.sss_awake_stage[heroID]
end
function heroltCtrl:getHeroStageGiftCfg(rechargeID)
	return heroltCtrl.sss_awake_stage_gift[rechargeID]
end
function heroltCtrl:getHeroAwakeMaxQuality(heroID)
	local num = #heroltCtrl.heroRecruitInfo[heroID]
	return heroltCtrl.heroRecruitInfo[heroID][num].quality
end
function heroltCtrl:getHeroIdByHeroCard(itemID)
	return heroltCtrl.heroCradItemMap[itemID]
end
function heroltCtrl:getHeroIDAll()
	local _ENV, ret
	for k, v in pairs(heroltCtrl.herosInfo) do
		table.insert(ret, v.heroID)
	end
	return ret
end
function heroltCtrl:getHeroStuntSkills(heroID)
	local _ENV, ret
	for k, v in ipairs(heroltCtrl.heroStuntSkillConfig) do
		if v.heroID == heroID then
			table.insert(ret, v.skillID)
		end
	end
	return ret
end
function heroltCtrl:getHeroInheritAttrAwake()
	return heroltCtrl.hero_inherit_awake
end
return heroltCtrl
