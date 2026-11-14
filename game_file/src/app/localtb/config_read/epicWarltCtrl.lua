local epicWarltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "epic_war_event_param_config"
	;(nil)[2] = true
	epicWarltCtrl:defineValue("eventParamConfig", nil)
	_ENV = nil
	;(nil)[1] = "epic_war_explore_point_config"
	;(nil)[2] = true
	epicWarltCtrl:defineValue("explorePointConfig", nil)
	epicWarltCtrl:defineValue("chapterConfig", function()
		epicWarltCtrl.chapterConfig, epicWarltCtrl = nil, nil
		local chapterConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_name_view")
		for k, v in ipairs(chapterConfig) do
			epicWarltCtrl.chapterConfig[v.chapterID] = v
		end
		return epicWarltCtrl.chapterConfig
	end)
	epicWarltCtrl:defineValue("checkPointConfig", function()
		epicWarltCtrl.checkPointConfig, epicWarltCtrl = nil, nil
		local checkPointConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_show_view")
		for k, v in ipairs(checkPointConfig) do
			epicWarltCtrl.checkPointConfig[v.stageID] = v
		end
		return epicWarltCtrl.checkPointConfig
	end)
	epicWarltCtrl:defineValue("dropConfig", function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)
	function _ENV()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[1] = "epic_war_chapter_config"
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[2] = true
	epicWarltCtrl:defineValue("checkStarConfig", function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)
	function _ENV()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[1] = "epic_war_challenge_buy"
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[2] = true
	epicWarltCtrl:defineValue("checkChallenge", function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)
	function _ENV()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[1] = "epic_war_action_buy"
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[2] = true
	epicWarltCtrl:defineValue("checkAction", function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)
	function _ENV()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[1] = "epic_war_stage_config"
	;(function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)[2] = true
	epicWarltCtrl:defineValue("stageConfig", function()
		epicWarltCtrl.dropConfig, epicWarltCtrl = nil, nil
		local dropConfig = require_once("app." .. LocalTblPath .. ".config_client.epic_war_drop_show")
		for k, v in ipairs(dropConfig) do
			epicWarltCtrl.dropConfig[v.stageID] = v
		end
		return epicWarltCtrl.dropConfig
	end)
	local createData = function(name)
		epicWarltCtrl.chapterCondition, epicWarltCtrl, epicWarltCtrl.stageCondition, epicWarltCtrl = nil, nil, nil, nil
		for k, v in ipairs(epicWarltCtrl.stageConfig) do
			epicWarltCtrl.stageCondition[v.stageID] = v
			if not epicWarltCtrl.chapterCondition[v.chapterID] and v.lastChapterID ~= 0 then
				epicWarltCtrl.chapterCondition[v.chapterID], epicWarltCtrl = nil, nil
				epicWarltCtrl.chapterCondition[v.chapterID].condition = v.condition
				epicWarltCtrl.chapterCondition[v.chapterID].lastChapterID = v.lastChapterID
				epicWarltCtrl.chapterCondition[v.chapterID].stageID = v.stageID
			end
		end
		if name == "stageCondition" then
			return epicWarltCtrl.stageCondition
		elseif name == "chapterCondition" then
			return epicWarltCtrl.chapterCondition
		end
	end
	epicWarltCtrl:defineValue("stageCondition", createData)
	epicWarltCtrl:defineValue("chapterCondition", createData)
	_ENV = createData
	createData[1] = "epic_war_battle_param_config"
	createData[2] = true
	epicWarltCtrl:defineValue("battleConfig", createData)
	epicWarltCtrl = createData
	createData[1] = "hero_view_info"
	epicWarltCtrl:defineValue("heroConfig", createData)
	epicWarltCtrl:defineValue("chapterGuideConfig", function()
		epicWarltCtrl.chapterGuideConfig, epicWarltCtrl = nil, nil
		local chapterGuideConfig = require_once("app." .. LocalTblPath .. ".config_client.guide_chapter_view")
		for k, v in ipairs(chapterGuideConfig) do
			if epicWarltCtrl.chapterGuideConfig[v.chapterID] == nil then
				epicWarltCtrl.chapterGuideConfig[v.chapterID], epicWarltCtrl = nil, nil
			end
			epicWarltCtrl = nil
			;(nil).figure = v.figure
			epicWarltCtrl.chapterGuideConfig[v.chapterID][v.order], (nil).content = nil, v.content
		end
		return epicWarltCtrl.chapterGuideConfig
	end)
	epicWarltCtrl:defineValue("stageGuideConfig", function()
		epicWarltCtrl.stageGuideConfig, epicWarltCtrl = nil, nil
		local stageGuideConfig = require_once("app." .. LocalTblPath .. ".config_client.guide_level_view")
		for k, v in ipairs(stageGuideConfig) do
			if epicWarltCtrl.stageGuideConfig[v.stageID] == nil then
				epicWarltCtrl.stageGuideConfig[v.stageID], epicWarltCtrl = nil, nil
			end
			epicWarltCtrl = nil
			;(nil).figure = v.figure
			epicWarltCtrl.stageGuideConfig[v.stageID][v.order], (nil).content = nil, v.content
		end
		return epicWarltCtrl.stageGuideConfig
	end)
	epicWarltCtrl:defineValue("tacticsConfig", function()
		epicWarltCtrl.tacticsConfig, epicWarltCtrl = nil, nil
		local tacticsConfig = require_once("app." .. LocalTblPath .. ".config_server.epic_war_tactics_shop")
		for k, v in ipairs(tacticsConfig) do
			epicWarltCtrl.tacticsConfig[v.tacticsId] = v
		end
		return epicWarltCtrl.tacticsConfig
	end)
	epicWarltCtrl:defineValue("soldiersBlessConfig", function()
		epicWarltCtrl.soldiersBlessConfig, epicWarltCtrl = nil, nil
		local soldiersBlessConfig = require_once("app." .. LocalTblPath .. ".config_server.epic_war_soldier_bless")
		for k, v in ipairs(soldiersBlessConfig) do
			epicWarltCtrl.soldiersBlessConfig[v.tacticsId] = v
		end
		return epicWarltCtrl.soldiersBlessConfig
	end)
	epicWarltCtrl:defineValue("bossBonusKeys", function()
		_ENV, _ENV = nil, nil
		;(nil).lang = "common_text_1313"
		;(nil).lordKey = "infantryAkAddPercent"
		;(nil).buff = gBuffEffect.INFANTRY_ATTACK_BOOST
		_ENV, (nil)[1], (nil).own = nil, nil, gBuffEffect.TROOP_ATTACK_BOOST
		;(nil).lang = "common_text_1317"
		;(nil).lordKey = "infantryDfAddPercent"
		;(nil).buff = gBuffEffect.INFANTRY_DEFENSE_BOOST
		_ENV, (nil)[2], (nil).own = nil, nil, gBuffEffect.TROOP_DEFENSE_BOOST
		;(nil).lang = "common_text_1321"
		;(nil).lordKey = "infantryHpAddPercent"
		;(nil).buff = gBuffEffect.INFANTRY_HP_BOOST
		_ENV, (nil)[3], (nil).own = nil, nil, gBuffEffect.TROOP_HP_BOOST
		;(nil).lang = "common_text_1314"
		;(nil).lordKey = "cavalryAkAddPercent"
		;(nil).buff = gBuffEffect.CAVALRY_ATTACK_BOOST
		_ENV, (nil)[4], (nil).own = nil, nil, gBuffEffect.TROOP_ATTACK_BOOST
		;(nil).lang = "common_text_1318"
		;(nil).lordKey = "cavalryDfAddPercent"
		;(nil).buff = gBuffEffect.CAVALRY_DEFENSE_BOOST
		_ENV, (nil)[5], (nil).own = nil, nil, gBuffEffect.TROOP_DEFENSE_BOOST
		;(nil).lang = "common_text_1322"
		;(nil).lordKey = "cavalryHpAddPercent"
		;(nil).buff = gBuffEffect.CAVALRY_HP_BOOST
		_ENV, (nil)[6], (nil).own = nil, nil, gBuffEffect.TROOP_HP_BOOST
		;(nil).lang = "common_text_1315"
		;(nil).lordKey = "archerAkAddPercent"
		;(nil).buff = gBuffEffect.ARCHER_ATTACK_BOOST
		_ENV, (nil)[7], (nil).own = nil, nil, gBuffEffect.TROOP_ATTACK_BOOST
		;(nil).lang = "common_text_1319"
		;(nil).lordKey = "archerDfAddPercent"
		;(nil).buff = gBuffEffect.ARCHER_DEFENSE_BOOST
		_ENV, (nil)[8], (nil).own = nil, nil, gBuffEffect.TROOP_DEFENSE_BOOST
		;(nil).lang = "common_text_1323"
		;(nil).lordKey = "archerHpAddPercent"
		;(nil).buff = gBuffEffect.ARCHER_HP_BOOST
		_ENV, (nil)[9], (nil).own = nil, nil, gBuffEffect.TROOP_HP_BOOST
		;(nil).lang = "common_text_1316"
		;(nil).lordKey = "charistsAkAddPercent"
		;(nil).buff = gBuffEffect.SIEGE_VEHICLES_ATTACK_BOOST
		_ENV, (nil)[10], (nil).own = nil, nil, gBuffEffect.TROOP_ATTACK_BOOST
		;(nil).lang = "common_text_1320"
		;(nil).lordKey = "charistsDfAddPercent"
		;(nil).buff = gBuffEffect.SIEGE_VEHICLES_DEFENSE_BOOST
		_ENV, (nil)[11], (nil).own = nil, nil, gBuffEffect.TROOP_DEFENSE_BOOST
		;(nil).lang = "common_text_1324"
		;(nil).lordKey = "charistsHpAddPercent"
		;(nil).buff = gBuffEffect.SIEGE_VEHICLES_HP_BOOST
		_ENV, (nil)[12], (nil).own = nil, nil, gBuffEffect.TROOP_HP_BOOST
		;(nil).lang = "common_text_3238"
		;(nil).lordKey = "eliteAkAddPercent"
		;(nil).buff = gBuffEffect.ELITE_SOLDIER_ATTACK_BOOST
		_ENV, (nil)[13], (nil).own = nil, nil, gBuffEffect.TROOP_ATTACK_BOOST
		;(nil).lang = "common_text_3239"
		;(nil).lordKey = "eliteDfAddPercent"
		;(nil).buff = gBuffEffect.ELITE_SOLDIER_DEFENSE_BOOST
		_ENV, (nil)[14], (nil).own = nil, nil, gBuffEffect.TROOP_DEFENSE_BOOST
		;(nil).lang = "common_text_3240"
		;(nil).lordKey = "eliteHpAddPercent"
		;(nil).buff = gBuffEffect.ELITE_SOLDIER_HP_BOOST
		_ENV, (nil)[15], (nil).own = nil, nil, gBuffEffect.TROOP_HP_BOOST
		;(nil).lang = "heroskill_des_08"
		;(nil).lordKey = ""
		;(nil).buff = gBuffEffect.CAVALRY_ARCHER
		_ENV, (nil)[16], (nil).own = nil, nil, 0
		;(nil).lang = "heroskill_des_09"
		;(nil).lordKey = ""
		;(nil).buff = gBuffEffect.ARCHER_INFANTRY
		_ENV, (nil)[17], (nil).own = nil, nil, 0
		;(nil).lang = "heroskill_des_10"
		;(nil).lordKey = ""
		;(nil).buff = gBuffEffect.INFANTRY_CAVALRY
		_ENV, (nil)[18], (nil).own = nil, nil, 0
		;(nil).lang = "heroskill_des_11"
		;(nil).lordKey = ""
		;(nil).buff = gBuffEffect.INFANTRY_CRIT_PLUS
		;(nil)[19], (nil).own = nil, 0
		return nil
	end)
end
init()
function epicWarltCtrl.getExplorePointOnceBuy()
	return epicWarltCtrl.explorePointConfig[1].pointOfOnceBuy
end
function epicWarltCtrl.getTowerDamage()
	local ret = 0
	local epicBattleDef = include("epicBattleDef")
	for k, v in ipairs(epicWarltCtrl.eventParamConfig) do
		if v.eventType == epicBattleDef.gEpicWarBoardPointTypeEnum.BARTIZAN then
			ret = tostring(v.param[1] / 10) .. "%"
			break
		end
	end
	return ret
end
function epicWarltCtrl.getMutBuffArray(effectType)
	local _ENV, idArray
	for k, v in pairs(epicWarltCtrl.soldiersBlessConfig) do
		if v.effectType == effectType then
			_ENV = nil
			;(nil).tacticsId = v.tacticsId
			;(nil).value = v.value
			table.insert(idArray, nil)
		end
	end
	return idArray
end
function epicWarltCtrl.getGateHeadInfo(stageID)
	local stageIcon = epicWarltCtrl.checkPointConfig[stageID].stageIcon
	if next(stageIcon) then
		return "icon_epicWar_stagebox.png" == stageIcon[1], stageIcon
	else
		return false
	end
end
function epicWarltCtrl.getGateBoxCfg(stageID)
	return epicWarltCtrl.stageCondition[stageID].stageBox
end
function epicWarltCtrl.getDailyBox(stageID)
	return epicWarltCtrl.stageCondition[stageID].dailyBox
end
function epicWarltCtrl.getGatePreNextID(stageID)
	local preID = 0
	local nextID = 0
	local index = 0
	for k, v in ipairs(epicWarltCtrl.stageConfig) do
		if v.stageID == stageID then
			index = v.Index
			break
		end
	end
	if index ~= 0 then
		preIndex = index - 1
		nextIndex = index + 1
	end
	return 0 < preIndex and epicWarltCtrl.stageConfig[preIndex].stageID or nil, 0 < nextIndex and nextIndex <= #epicWarltCtrl.stageConfig and epicWarltCtrl.stageConfig[nextIndex].stageID or nil
end
function epicWarltCtrl.getTacticsIcon(id)
	return epicWarltCtrl.tacticsConfig[id].icon
end
function epicWarltCtrl.getTacticsIconBase(id)
	local iconBase = "base_blue.png"
	local cfgBase = epicWarltCtrl.tacticsConfig[id].iconBase
	if cfgBase ~= "" then
		iconBase = cfgBase
	end
	return iconBase
end
function epicWarltCtrl.getTacticsDes(id)
	local desc = epicWarltCtrl.tacticsConfig[id].desc
	local value = epicWarltCtrl.tacticsConfig[id].value
	local useType = epicWarltCtrl.getTacticsUseType(id)
	local epicBattleDef = include("epicBattleDef")
	local varStr = ""
	if useType == epicBattleDef.gTacticsEffectType.BOSS_ARMY_REDUCE or useType == epicBattleDef.gTacticsEffectType.DAMAGE_REDUCE or useType == epicBattleDef.gTacticsEffectType.CURY_ARMY then
		varStr = tostring(value / 10) .. "%"
	else
		varStr = value / 10
	end
	epicWarltCtrl = nil
	;(nil).var1 = varStr
	return i18n(desc, nil)
end
function epicWarltCtrl.getTacticsPrice(id)
	return epicWarltCtrl.tacticsConfig[id].price
end
function epicWarltCtrl.getTacticsName(id)
	return epicWarltCtrl.tacticsConfig[id].name
end
function epicWarltCtrl.getTacticsUseType(id)
	return epicWarltCtrl.tacticsConfig[id].useType
end
function epicWarltCtrl.getBlessTacticsIcon(id)
	return epicWarltCtrl.soldiersBlessConfig[id].icon
end
function epicWarltCtrl.getBlessTacticsBase(id)
	local iconBase = "base_blue.png"
	local cfgBase = epicWarltCtrl.soldiersBlessConfig[id].iconBase
	local quality = epicWarltCtrl.soldiersBlessConfig[id].quality
	epicWarltCtrl = nil
	;(nil)[1] = "base_blue.png"
	;(nil)[2] = "base_purple.png"
	local (nil)[3], baseCfg = "base_orange.png", nil
	if cfgBase ~= "" then
		iconBase = cfgBase
	else
		iconBase = baseCfg[quality]
	end
	return iconBase
end
function epicWarltCtrl.getBlessTacticsName(id)
	return epicWarltCtrl.soldiersBlessConfig[id].name
end
function epicWarltCtrl.getBlessTacticsDes(id)
	local epicBattleDef = include("epicBattleDef")
	local desc = epicWarltCtrl.soldiersBlessConfig[id].desc
	local value = epicWarltCtrl.soldiersBlessConfig[id].value
	local effectType = epicWarltCtrl.soldiersBlessConfig[id].effectType
	local varStr = tostring(value / 10) .. "%"
	if effectType == epicBattleDef.gBlessEffctType.EXPLORE_ARMY_NUM_RECOVER then
		local triggerProbability = epicWarltCtrl.soldiersBlessConfig[id].triggerProbability
		_ENV = nil
		;(nil).var1 = tostring(triggerProbability / 10) .. "%"
		;(nil).var2 = tostring(value / 10) .. "%"
		return i18n(desc, nil)
	end
	if effectType == epicBattleDef.gBlessEffctType.BOSS_ARMY_REDUCE then
		local triggerProbability = epicWarltCtrl.soldiersBlessConfig[id].triggerProbability
		_ENV = nil
		;(nil).var1 = tostring(triggerProbability / 10) .. "%"
		;(nil).var2 = tostring(value / 10) .. "%"
		return i18n(desc, nil)
	end
	_ENV = desc
	desc.num = value / 10
	desc.var1 = varStr
	return i18n(desc, desc)
end
function epicWarltCtrl.getBlessTacticsPrice(id)
	return epicWarltCtrl.soldiersBlessConfig[id].price
end
function epicWarltCtrl.getBlessTacticsQuality(id)
	return epicWarltCtrl.soldiersBlessConfig[id].quality
end
function epicWarltCtrl.getChapterGuideInfo(chapter)
	local epicWarltCtrl, ret
	if epicWarltCtrl.chapterGuideConfig[chapter] then
		for i, v in ipairs(epicWarltCtrl.chapterGuideConfig[chapter]) do
			local str = i18n(v.content)
			local img = "lord"
			if v.figure == 2 then
				img = "girl"
			end
			epicWarltCtrl = nil
			;(nil).img = img
			;(nil).str = str
			table.insert(ret, nil)
		end
		return ret
	else
		return nil
	end
end
function epicWarltCtrl.getStageGuideInfo(stage)
	local epicWarltCtrl, ret
	if epicWarltCtrl.stageGuideConfig[stage] then
		for i, v in ipairs(epicWarltCtrl.stageGuideConfig[stage]) do
			local str = i18n(v.content)
			local img = "lord"
			local spos, ap
			if v.figure == 2 then
				img = "girl"
			elseif v.figure == 3 then
				img = epicWarltCtrl.getBossHeroMiddleIcon(epicWarltCtrl.getStageHeroID(stage))
				ap = cc.p(0, 0)
				spos = SoraDFIsRA() and cc.p(-180, -193) or cc.p(180, -193)
			end
			epicWarltCtrl = -193
			;(-193).img = img
			;(-193).str = str
			;(-193).spos = spos
			;(-193).ap = ap
			table.insert(ret, -193)
		end
		return ret
	else
		return nil
	end
end
function epicWarltCtrl.getStageDropInfo(stage, index)
	if not index or index == 3 then
		return epicWarltCtrl.dropConfig[stage].Dropout3
	else
		return epicWarltCtrl.dropConfig[stage].Dropout1
	end
end
function epicWarltCtrl.getAllChapter()
	return epicWarltCtrl.chapterConfig
end
function epicWarltCtrl.getChapterCondition(chapter)
	local chapter = chapter or 2
	local lastChapterID = 0
	local epicWarltCtrl, condition
	local conditionConfig = epicWarltCtrl.chapterCondition[chapter]
	if conditionConfig then
		lastChapterID = conditionConfig.lastChapterID
		condition = conditionConfig.condition
	end
	return lastChapterID, condition
end
function epicWarltCtrl.getChapterFinalStage(chapter)
	local stageID = 0
	for k, v in ipairs(epicWarltCtrl.stageConfig) do
		if v.chapterID == chapter then
			stageID = math.max(stageID, v.stageID)
		end
	end
	return stageID
end
function epicWarltCtrl.getStageLimitArmy(stage)
	return epicWarltCtrl.stageCondition[stage].troopLimit
end
function epicWarltCtrl.getStageCondition(stage)
	if not epicWarltCtrl.stageCondition[stage].condition then
		epicWarltCtrl = epicWarltCtrl.stageCondition[stage].condition
	end
	return epicWarltCtrl.stageCondition[stage].lastStageID, epicWarltCtrl.stageCondition[stage].condition
end
function epicWarltCtrl.getPreStageInfo(stage)
	local chapterID = 1
	local lastStageID = epicWarltCtrl.stageCondition[stage].lastStageID
	if lastStageID ~= 0 then
		chapterID = epicWarltCtrl.stageCondition[lastStageID].chapterID
	end
	return chapterID, lastStageID % 10 == 0 and 10 or lastStageID % 10
end
function epicWarltCtrl.getStageMaxChallengeCount(stage)
	local gametop = gModuleMgr.getObject("gametop")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local techFree = technologyCtrl:getTechnologyPower(gTechnologyType.EPIC_WAR_FREE_CHALLENGE_COUNT_ADD) or 0
	return epicWarltCtrl.stageCondition[stage].initialChallengeCount + techFree
end
function epicWarltCtrl.getChapterLimitArmy(chapterID)
	return epicWarltCtrl.checkStarConfig[chapterID].troopLimit
end
function epicWarltCtrl.getChapterCastleLimit(chapterID)
	return epicWarltCtrl.checkStarConfig[chapterID].condition[2]
end
function epicWarltCtrl.getStages(index)
	return epicWarltCtrl.checkStarConfig[index].stageArray
end
function epicWarltCtrl.getStagesID(chapterID, index)
	return epicWarltCtrl.checkStarConfig[chapterID].stageArray[index]
end
function epicWarltCtrl.getChapterLastGateID(chapterID)
	return epicWarltCtrl.checkStarConfig[chapterID].stageArray[#epicWarltCtrl.checkStarConfig[chapterID].stageArray]
end
function epicWarltCtrl:getChapterID(stage)
	stage = stage or 1500101
	return epicWarltCtrl.stageCondition[stage].chapterID
end
function epicWarltCtrl.isStageBorder(stage)
	return epicWarltCtrl.checkPointConfig[stage].border > 0
end
function epicWarltCtrl.getStagePicture(stage)
	return epicWarltCtrl.checkPointConfig[stage].picture
end
function epicWarltCtrl.getChapNumAndStageNum(stage)
	return epicWarltCtrl.checkPointConfig[stage].chapterNum, epicWarltCtrl.checkPointConfig[stage].stageNum
end
function epicWarltCtrl.getStageName(stage)
	return i18n(epicWarltCtrl.checkPointConfig[stage].Checkpointname)
end
function epicWarltCtrl.getStageDes(stage)
	return i18n(epicWarltCtrl.checkPointConfig[stage].describe)
end
function epicWarltCtrl.getStageDrop(stage)
	return epicWarltCtrl.checkPointConfig[stage].drop
end
function epicWarltCtrl.getStageHeroID(stage)
	return tonumber(epicWarltCtrl.checkPointConfig[stage].bossId)
end
function epicWarltCtrl.getChapterName(index)
	return i18n(epicWarltCtrl.chapterConfig[index].Chaptername)
end
function epicWarltCtrl.getChapterBg(index)
	return epicWarltCtrl.chapterConfig[index].icon
end
function epicWarltCtrl.getChapterMaxStars(index)
	return epicWarltCtrl.checkStarConfig[index].star or 3
end
function epicWarltCtrl.getStageIndex(stage)
	return stage % 100
end
function epicWarltCtrl.getStageMaxStars(stage)
	return epicWarltCtrl.stageCondition[stage].star
end
function epicWarltCtrl.getChapterAward(index)
	if not epicWarltCtrl.checkStarConfig[index].ratingAward then
		local epicWarltCtrl, award = epicWarltCtrl.checkStarConfig[index].ratingAward, epicWarltCtrl.checkStarConfig[index].ratingAward
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(award, nil)
end
function epicWarltCtrl.getBuyChallengeGold(boughtCount, count)
	local gold = 0
	for k = boughtCount + 1, boughtCount + count do
		if epicWarltCtrl.checkChallenge[k] then
			gold = gold + epicWarltCtrl.checkChallenge[k].gold
		end
	end
	return gold
end
function epicWarltCtrl.getMaxChallengeBuyCount()
	local gametop = gModuleMgr.getObject("gametop")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local realBuyCount = technologyCtrl:getTechnologyPower(gTechnologyType.EPIC_WAR_BUY_CHALLENGE_COUNT_ADD) or 0
	return math.min(#epicWarltCtrl.checkChallenge, realBuyCount)
end
function epicWarltCtrl.getBuyActionGold(count)
	local count = math.min(count, #epicWarltCtrl.checkAction)
	return epicWarltCtrl.checkAction[count].gold
end
function epicWarltCtrl.getActionMaxBuyCount()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local vipLocalData = include("vipLocalData")
	local vipInfo = lordInfoCtrl:getVipDetails()
	local buffRet, buffRetKey = vipLocalData.queryVipBuffData(vipInfo.level)
	local extraAddCount = buffRetKey[7233] and buffRetKey[7233].value or 0
	return extraAddCount
end
function epicWarltCtrl.getBossHeroName(heroID)
	return epicWarltCtrl.heroConfig[heroID].herName
end
function epicWarltCtrl.getBossHeroTalk(heroID)
	return epicWarltCtrl.heroConfig[heroID].heroDes
end
function epicWarltCtrl.getBossHeroIcon(heroID)
	return epicWarltCtrl.heroConfig[heroID].herIcon
end
function epicWarltCtrl.getBossHeroMiddleIcon(heroID)
	return epicWarltCtrl.heroConfig[heroID].herMiddle
end
function epicWarltCtrl.getBossHeroHerIcon(heroID)
	return epicWarltCtrl.heroConfig[heroID].herImage
end
function epicWarltCtrl.getBossHeroID(index)
	return epicWarltCtrl.battleConfig[index].heroShow
end
function epicWarltCtrl.getBossHeroList(index)
	local index = index or 1
	local heroList = epicWarltCtrl.battleConfig[index].heroList
	_UPVALUE3_ = nil
	;(nil)[1] = "heroID"
	;(nil)[2] = "quality"
	;(nil)[3] = "level"
	return serviceFunctions.tableFormat(heroList, nil)
end
function epicWarltCtrl.getBossArmyList(index)
	local soldier = epicWarltCtrl.battleConfig[index].soldier
	local totalNum = 0
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "num"
	local armyList = serviceFunctions.tableFormat(soldier, nil)
	for k, v in ipairs(armyList) do
		totalNum = totalNum + v.num
	end
	return armyList, totalNum
end
function epicWarltCtrl.getBossBonus(index)
	local bonus = epicWarltCtrl.battleConfig[index].bonus
	local heroList = epicWarltCtrl.getBossHeroList(index)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local buffArray = heroltCtrl:getSomeUnknowHerosSkillValue(heroList)
	local epicWarltCtrl, bonusArray = heroltCtrl, heroltCtrl
	local keys = epicWarltCtrl.bossBonusKeys
	for i = 1, #keys do
		local value = bonus
		if buffArray[keys[i].buff] then
			value = value + buffArray[keys[i].buff]
		end
		epicWarltCtrl = nil
		;(nil).key = keys[i].lang
		;(nil).value = value
		;(nil).lordKey = keys[i].lordKey
		;(nil).buff = keys[i].buff
		;(nil).own = keys[i].own
		table.insert(bonusArray, nil)
	end
	return bonus, bonusArray
end
return epicWarltCtrl
