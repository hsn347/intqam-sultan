local atlantisActivityRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "atlantiswar_constant"
;(nil)[2] = true
atlantisActivityRead:defineValue("constant", nil)
function atlantisActivityRead.getConstValue(key, defaultValue)
	local info = atlantisActivityRead.constant[key]
	if info and info.value then
		return info.value[1]
	end
	return defaultValue
end
function atlantisActivityRead.getConstValueArray(key, defaultValue)
	local info = atlantisActivityRead.constant[key]
	if info and info.value then
		return info.value
	end
	return defaultValue
end
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		atlantisActivityRead.personalOfficial, atlantisActivityRead, atlantisActivityRead.officer_config, atlantisActivityRead = nil, nil, nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.atlantiswar_officer_config")
		for i, v in ipairs(cfg) do
			if i ~= 1 then
				table.insert(atlantisActivityRead.personalOfficial, v)
			end
			atlantisActivityRead.officer_config[v.type] = v
		end
		if name == "officer_config" then
			return atlantisActivityRead.officer_config
		elseif name == "personalOfficial" then
			return atlantisActivityRead.personalOfficial
		end
	end
	atlantisActivityRead:defineValue("officer_config", createData)
	atlantisActivityRead:defineValue("personalOfficial", createData)
	_ENV = createData
	createData[1] = "atlantiswar_officer_award"
	createData[2] = true
	atlantisActivityRead:defineValue("officer_award", createData)
	atlantisActivityRead = createData
	createData[1] = "atlantiswar_title_config"
	atlantisActivityRead:defineValue("titleConfig", createData)
	atlantisActivityRead = createData
	createData[1] = "atlantiswar_officer_describe"
	atlantisActivityRead:defineValue("buffDesTable", createData)
	local createData2 = function(name)
		atlantisActivityRead.scrollHeight, atlantisActivityRead, atlantisActivityRead.title_Season_Reward, atlantisActivityRead, atlantisActivityRead.personal_Season_Reward, atlantisActivityRead, atlantisActivityRead.kingdon_Honor_Season_Reward, atlantisActivityRead, atlantisActivityRead.kingdon_Season_Reward, atlantisActivityRead, atlantisActivityRead.title_Single_Reward, atlantisActivityRead, atlantisActivityRead.personal_Single_Reward, atlantisActivityRead, atlantisActivityRead.kingdon_Single_Reward, atlantisActivityRead = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		local getSingleHeight = function(v)
			local singleHeight = 100
			if #v.award / 2 > 5 then
				singleHeight = singleHeight + 80 * math.ceil(#v.award / 2 / 5 - 1)
			end
			return singleHeight
		end
		local totalHeight = 0
		for i, v in ipairs(require_data("atlantiswar_rank_award", true).data) do
			if v.rank == 1 then
				local singleH = 45
				atlantisActivityRead = nil
				;(nil).isTitle = true
				;(nil).titleStr = v.type == 1 and "atlantiswar_text_0049" or "atlantiswar_text_0050"
				;(nil).singleH = singleH
				table.insert(atlantisActivityRead.kingdon_Single_Reward, nil)
				totalHeight = totalHeight + singleH
			end
			local singleH = getSingleHeight(v)
			totalHeight = totalHeight + singleH
			atlantisActivityRead = nil
			;(nil).rank = v.rank
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil).award = serviceFunctions.tableFormat(v.award, nil)
			;(nil).singleH = singleH
			table.insert(atlantisActivityRead.kingdon_Single_Reward, nil)
		end
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Kingdon_Single] = totalHeight
		local totalHeight = 0
		for i, v in ipairs(require_data("atlantiswar_season_rank_award", true).data) do
			local singleH = getSingleHeight(v)
			totalHeight = totalHeight + singleH
			atlantisActivityRead = serviceFunctions.tableFormat(v.award, nil)
			serviceFunctions.tableFormat(v.award, nil).isKNO1 = v.id == 1
			serviceFunctions.tableFormat(v.award, nil).rank = v.ranking
			_UPVALUE2_ = "id"
			;("id")[1] = "id"
			;("id")[2] = "count"
			serviceFunctions.tableFormat(v.award, nil).award = serviceFunctions.tableFormat(v.award, "id")
			serviceFunctions.tableFormat(v.award, nil).singleH = singleH
			table.insert(atlantisActivityRead.kingdon_Season_Reward, (serviceFunctions.tableFormat(v.award, nil)))
			if v.id == 1 then
				local singleH = 240
				totalHeight = totalHeight + singleH
				atlantisActivityRead = serviceFunctions.tableFormat(v.award, "id")
				serviceFunctions.tableFormat(v.award, "id").isKingdomNO1 = true
				serviceFunctions.tableFormat(v.award, "id").singleH = singleH
				table.insert(atlantisActivityRead.kingdon_Season_Reward, (serviceFunctions.tableFormat(v.award, "id")))
			end
		end
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Kingdon_Season] = totalHeight
		local totalHeight1, totalHeight2 = 0, 0
		for i, v in ipairs(require_data("atlantiswar_title_award", true).data) do
			local singleH = getSingleHeight(v)
			if v.type == 1 then
				totalHeight1 = totalHeight1 + singleH
				atlantisActivityRead = v.award
				v.award.titleStr = atlantisActivityRead.titleConfig[v.title].name
				v.award.titleIcon = atlantisActivityRead.titleConfig[v.title].icon
				_UPVALUE2_ = "count"
				;("count")[1] = "id"
				;("count")[2] = "count"
				v.award.award = serviceFunctions.tableFormat(v.award, "count")
				v.award.singleH = singleH
				table.insert(atlantisActivityRead.title_Single_Reward, v.award)
			else
				if v.ranking[1] == 1 then
					local singleH = 45
					totalHeight2 = totalHeight2 + singleH
					atlantisActivityRead = serviceFunctions.tableFormat(v.award, "count")
					serviceFunctions.tableFormat(v.award, "count").isTitle = true
					serviceFunctions.tableFormat(v.award, "count").titleStr = atlantisActivityRead.titleConfig[v.title].name
					serviceFunctions.tableFormat(v.award, "count").titleIcon = atlantisActivityRead.titleConfig[v.title].icon
					serviceFunctions.tableFormat(v.award, "count").singleH = singleH
					table.insert(atlantisActivityRead.title_Season_Reward, (serviceFunctions.tableFormat(v.award, "count")))
				end
				totalHeight2 = totalHeight2 + singleH
				atlantisActivityRead = atlantisActivityRead.title_Season_Reward
				atlantisActivityRead.title_Season_Reward.rank = v.ranking
				_UPVALUE2_ = v.title
				v.title[1] = "id"
				v.title[2] = "count"
				atlantisActivityRead.title_Season_Reward.award = serviceFunctions.tableFormat(v.award, v.title)
				atlantisActivityRead.title_Season_Reward.singleH = singleH
				table.insert(atlantisActivityRead.title_Season_Reward, atlantisActivityRead.title_Season_Reward)
			end
		end
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Title_Single] = totalHeight1
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Title_Season] = totalHeight2
		local totalHeight1, totalHeight2 = 0, 0
		for i, v in ipairs(require_data("atlantiswar_single_rank_award", true).data) do
			local singleH = getSingleHeight(v)
			if v.type == 1 then
				totalHeight1 = totalHeight1 + singleH
				atlantisActivityRead = v.award
				v.award.rank = v.ranking
				_UPVALUE2_ = "count"
				;("count")[1] = "id"
				;("count")[2] = "count"
				v.award.award = serviceFunctions.tableFormat(v.award, "count")
				v.award.singleH = singleH
				table.insert(atlantisActivityRead.personal_Single_Reward, v.award)
			else
				totalHeight2 = totalHeight2 + singleH
				atlantisActivityRead = v.award
				v.award.rank = v.ranking
				_UPVALUE2_ = "count"
				;("count")[1] = "id"
				;("count")[2] = "count"
				v.award.award = serviceFunctions.tableFormat(v.award, "count")
				v.award.singleH = singleH
				table.insert(atlantisActivityRead.personal_Season_Reward, v.award)
			end
		end
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Personal_Single] = totalHeight1
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Personal_Season] = totalHeight2
		local totalHeight = 0
		atlantisActivityRead = gAtlantisRewardType.Personal_Season
		gAtlantisRewardType.Personal_Season[1] = "atlantiswar_text_0037"
		gAtlantisRewardType.Personal_Season[2] = "atlantiswar_text_0038"
		local gAtlantisRewardType.Personal_Season[3], winTitle = "atlantiswar_text_0039", gAtlantisRewardType.Personal_Season
		for i, v in ipairs(require_data("atlantiswar_honor_award", true).data) do
			if v.playerranking[1] == 1 then
				local singleH = 45
				totalHeight = totalHeight + singleH
				atlantisActivityRead = v.award
				v.award.isTitle = true
				v.award.titleStr = winTitle[v.kingdomranking]
				v.award.singleH = singleH
				table.insert(atlantisActivityRead.kingdon_Honor_Season_Reward, v.award)
			end
			local singleH = getSingleHeight(v)
			totalHeight = totalHeight + singleH
			atlantisActivityRead = v.award
			v.award.rank = v.playerranking
			_UPVALUE2_ = "count"
			;("count")[1] = "id"
			;("count")[2] = "count"
			v.award.award = serviceFunctions.tableFormat(v.award, "count")
			v.award.singleH = singleH
			table.insert(atlantisActivityRead.kingdon_Honor_Season_Reward, v.award)
		end
		atlantisActivityRead.scrollHeight[gAtlantisRewardType.Kingdon_Honor_Season] = totalHeight
		if name == "kingdon_Single_Reward" then
			return atlantisActivityRead.kingdon_Single_Reward
		elseif name == "personal_Single_Reward" then
			return atlantisActivityRead.personal_Single_Reward
		elseif name == "title_Single_Reward" then
			return atlantisActivityRead.title_Single_Reward
		elseif name == "kingdon_Season_Reward" then
			return atlantisActivityRead.kingdon_Season_Reward
		elseif name == "kingdon_Honor_Season_Reward" then
			return atlantisActivityRead.kingdon_Honor_Season_Reward
		elseif name == "personal_Season_Reward" then
			return atlantisActivityRead.personal_Season_Reward
		elseif name == "title_Season_Reward" then
			return atlantisActivityRead.title_Season_Reward
		elseif name == "scrollHeight" then
			return atlantisActivityRead.scrollHeight
		end
	end
	atlantisActivityRead:defineValue("kingdon_Single_Reward", createData2)
	atlantisActivityRead:defineValue("personal_Single_Reward", createData2)
	atlantisActivityRead:defineValue("title_Single_Reward", createData2)
	atlantisActivityRead:defineValue("kingdon_Season_Reward", createData2)
	atlantisActivityRead:defineValue("kingdon_Honor_Season_Reward", createData2)
	atlantisActivityRead:defineValue("personal_Season_Reward", createData2)
	atlantisActivityRead:defineValue("title_Season_Reward", createData2)
	atlantisActivityRead:defineValue("scrollHeight", createData2)
end
function atlantisActivityRead.getOfficerAward()
	return atlantisActivityRead.officer_award
end
function atlantisActivityRead.getOfficerConfig()
	return atlantisActivityRead.officer_config
end
function atlantisActivityRead.getOfficialName(type)
	return atlantisActivityRead.officer_config[type].name
end
function atlantisActivityRead.getOfficialInfoByType(type)
	return atlantisActivityRead.officer_config[type]
end
function atlantisActivityRead.getPackageName(giftID)
	for i, v in ipairs(atlantisActivityRead.officer_award) do
		if v.treasureID == giftID then
			return i18n(v.name)
		end
	end
end
function atlantisActivityRead.getPackageLimit(giftID)
	for i, v in ipairs(atlantisActivityRead.officer_award) do
		if v.treasureID == giftID then
			return v.count
		end
	end
end
function atlantisActivityRead.getScrollHeight(rewardType)
	return atlantisActivityRead.scrollHeight[rewardType]
end
function atlantisActivityRead.getRewardList(rewardType)
	if rewardType == gAtlantisRewardType.Kingdon_Single then
		return atlantisActivityRead.kingdon_Single_Reward
	elseif rewardType == gAtlantisRewardType.Personal_Single then
		return atlantisActivityRead.personal_Single_Reward
	elseif rewardType == gAtlantisRewardType.Title_Single then
		return atlantisActivityRead.title_Single_Reward
	elseif rewardType == gAtlantisRewardType.Kingdon_Season then
		return atlantisActivityRead.kingdon_Season_Reward
	elseif rewardType == gAtlantisRewardType.Kingdon_Honor_Season then
		return atlantisActivityRead.kingdon_Honor_Season_Reward
	elseif rewardType == gAtlantisRewardType.Personal_Season then
		return atlantisActivityRead.personal_Season_Reward
	elseif rewardType == gAtlantisRewardType.Title_Season then
		return atlantisActivityRead.title_Season_Reward
	end
end
function atlantisActivityRead.getTitleConfig()
	return atlantisActivityRead.titleConfig
end
function atlantisActivityRead.getAllBuffList()
	local _ENV, officialList
	for type, v in pairs(atlantisActivityRead.officer_config) do
		officialList[type] = v.buff
	end
	return officialList
end
function atlantisActivityRead.getBufferName(bufferId)
	local buffItem = atlantisActivityRead.buffDesTable[bufferId]
	if buffItem then
		return i18n(buffItem.buffDes), buffItem.type
	end
end
function atlantisActivityRead.getBuildPointRule()
	local mapPointConfig = require_data("atlantiswar_map_build", true).data
	local mapConfig = require_data("atlantiswar_map_build_config", false).data
	local _ENV, ret = "atlantiswar_map_build_config", "atlantiswar_map_build_config"
	_UPVALUE4_ = nil
	;(nil)[1] = 901
	;(nil)[2] = 902
	;(nil)[3] = 903
	;(nil)[4] = 904
	for i, id in ipairs(nil) do
		_ENV = nil
		_ENV = nil
		;(nil).name = i18n(mapConfig[id].name)
		;(nil).time = mapPointConfig[id].actionInv
		;(nil).paramStr = i18n("atlantiswar_text_0240", nil)
		;(nil).value = mapPointConfig[id].point
		;(nil).isBgVisit = i % 2 == 0
		table.insert(ret, nil)
	end
	return ret
end
function atlantisActivityRead.getBossPointRule()
	local pointConfig = require_data("atlantiswar_boss_point", true).data
	local _ENV, ret = "atlantiswar_boss_point", "atlantiswar_boss_point"
	for i, v in ipairs(pointConfig) do
		if v.boss == 33 then
			break
		end
		if not v.ranking[2] then
			_ENV = nil
			_ENV = nil
			;(nil).var = v.ranking[1]
			;(nil).paramStr = i18n("atlantiswar_text_0133", nil)
			;(nil).value = v.point
			;(nil).isBgVisit = i % 2 == 0
			table.insert(ret, nil)
		else
			_ENV = nil
			_ENV = nil
			;(nil).var1 = v.ranking[1]
			;(nil).var2 = v.ranking[2]
			;(nil).paramStr = i18n("atlantiswar_text_0134", nil)
			;(nil).value = v.point
			;(nil).isBgVisit = i % 2 == 0
			table.insert(ret, nil)
		end
	end
	return ret
end
_UPVALUE2_ = true
;(true)[1] = "atlantiswar_map_build"
;(true)[2] = true
atlantisActivityRead:defineValue("atlantiswar_map_build", true)
function atlantisActivityRead.getMapBuildConfigs(...)
	return atlantisActivityRead.atlantiswar_map_build
end
function atlantisActivityRead.getMapBuildConfig(buildId)
	return atlantisActivityRead.atlantiswar_map_build[buildId]
end
function atlantisActivityRead.getMapBuildPos(buildId)
	local cfg = atlantisActivityRead.getMapBuildConfig(buildId)
	return cc.p(cfg.x, cfg.y)
end
function atlantisActivityRead.getMapBuildIdList(mapType, subType)
	local _ENV, ret
	for buildId, build in pairs(atlantisActivityRead.getMapBuildConfigs()) do
		if build.mapType == mapType and subType == build.type then
			table.insert(ret, buildId)
		end
	end
	return ret
end
_UPVALUE2_ = true
;(true)[1] = "atlantiswar_map_build_config"
;(true)[2] = false
atlantisActivityRead:defineValue("atlantiswar_map_build_config", true)
function atlantisActivityRead.getBuildClientConfig(buildId)
	return atlantisActivityRead.atlantiswar_map_build_config[buildId]
end
function atlantisActivityRead.getBuildName(buildId)
	local cfg = atlantisActivityRead.getBuildClientConfig(buildId)
	return cfg and i18n(cfg.name) or i18n("buildDes_name_101")
end
_UPVALUE2_ = true
;(true)[1] = "atlantiswar_skill_config"
;(true)[2] = true
atlantisActivityRead:defineValue("atlantiswar_skill_config", true)
atlantisActivityRead:defineValue("skillConfigMap", function()
	local _ENV, ret
	for i, v in ipairs(atlantisActivityRead.atlantiswar_skill_config) do
		ret[v.skillID] = i
	end
	return ret
end)
function atlantisActivityRead.getSkillConfig(skillID)
	local index = atlantisActivityRead.skillConfigMap[skillID]
	return atlantisActivityRead.atlantiswar_skill_config[index]
end
function atlantisActivityRead.getIsAddSkill(skillID)
	local cfg = atlantisActivityRead.getSkillConfig(skillID)
	local add_skill = cfg and cfg.add_skill or 0
	return add_skill == 1
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(atlantisActivityRead.atlantiswar_skill_config) do
		ret[v.skillID] = i
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(atlantisActivityRead.atlantiswar_skill_config) do
		ret[v.skillID] = i
	end
	return ret
end)[1] = "atlantiswar_skill_display"
;(function()
	local _ENV, ret
	for i, v in ipairs(atlantisActivityRead.atlantiswar_skill_config) do
		ret[v.skillID] = i
	end
	return ret
end)[2] = false
atlantisActivityRead:defineValue("atlantiswar_skill_display", function()
	local _ENV, ret
	for i, v in ipairs(atlantisActivityRead.atlantiswar_skill_config) do
		ret[v.skillID] = i
	end
	return ret
end)
function atlantisActivityRead.getSkillDisplay(...)
	return atlantisActivityRead.atlantiswar_skill_display
end
function atlantisActivityRead.getSkillDisplayConfig(skillId)
	return atlantisActivityRead.atlantiswar_skill_display[skillId]
end
function atlantisActivityRead.getSkillName(skillId)
	local cfg = atlantisActivityRead.getSkillDisplayConfig(skillId)
	return i18n(cfg.name)
end
function atlantisActivityRead.getSkillNameWithColor(skillId)
	local skillName = atlantisActivityRead.getSkillName(skillId)
	local skillColor = atlantisActivityRead.getSkillQualityColor(skillId)
	atlantisActivityRead = nil
	;(nil).color = skillColor
	return SoraDWrapHtmlTagByStyle(skillName, nil)
end
function atlantisActivityRead.getSkillQuality(skillId)
	local cfg = atlantisActivityRead.getSkillDisplayConfig(skillId)
	return cfg.quality
end
function atlantisActivityRead.getSkillQualityColor(skillId)
	local quality = atlantisActivityRead.getSkillQuality(skillId)
	local qConfig = gAtlantisQualityConfig[quality]
	return qConfig.color
end
init()
return atlantisActivityRead
