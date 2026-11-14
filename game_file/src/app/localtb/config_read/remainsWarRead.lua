local remainsWarRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	remainsWarRead = nil
	;(nil)[1] = "ruins_building_config"
	remainsWarRead:defineValue("tableRemainsWarBuildingInfo", nil)
	remainsWarRead = nil
	;(nil)[1] = "segment_describe"
	remainsWarRead:defineValue("tableSegmentDescribe", nil)
	remainsWarRead:defineValue("remainsWarBuffTable", function()
		remainsWarRead.remainsWarBuffTable, remainsWarRead = nil, nil
		local remainsWarBuffInfo = require_once("app." .. _G.LocalTblPath .. ".config_client.ruinseffectinfo")
		for _, v in ipairs(remainsWarBuffInfo) do
			local bid = remainsWarRead.getBuffID(v.sourceid, v.effectType)
			remainsWarRead.remainsWarBuffTable[bid] = v
		end
		return remainsWarRead.remainsWarBuffTable
	end)
	remainsWarRead:defineValue("ruinsTitleReward", function()
		local ruinsTitleReward = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward", "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward"
		for _, v in ipairs(ruinsTitleReward) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.classType][v.title] then
				_ENV = ret[v.classType][v.title]
			end
			ret[v.classType][v.title] = ret[v.classType][v.title]
			table.insert(ret[v.classType][v.title], v)
		end
		remainsWarRead.ruinsTitleReward = ret
		return remainsWarRead.ruinsTitleReward
	end)
	function remainsWarRead()
		local ruinsTitleReward = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward", "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward"
		for _, v in ipairs(ruinsTitleReward) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.classType][v.title] then
				_ENV = ret[v.classType][v.title]
			end
			ret[v.classType][v.title] = ret[v.classType][v.title]
			table.insert(ret[v.classType][v.title], v)
		end
		remainsWarRead.ruinsTitleReward = ret
		return remainsWarRead.ruinsTitleReward
	end
	;(function()
		local ruinsTitleReward = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward", "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward"
		for _, v in ipairs(ruinsTitleReward) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.classType][v.title] then
				_ENV = ret[v.classType][v.title]
			end
			ret[v.classType][v.title] = ret[v.classType][v.title]
			table.insert(ret[v.classType][v.title], v)
		end
		remainsWarRead.ruinsTitleReward = ret
		return remainsWarRead.ruinsTitleReward
	end)[1] = "ruins_title_config"
	remainsWarRead:defineValue("ruinsTitleConfig", function()
		local ruinsTitleReward = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward", "app." .. _G.LocalTblPath .. ".config_server.ruins_title_reward"
		for _, v in ipairs(ruinsTitleReward) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.classType][v.title] then
				_ENV = ret[v.classType][v.title]
			end
			ret[v.classType][v.title] = ret[v.classType][v.title]
			table.insert(ret[v.classType][v.title], v)
		end
		remainsWarRead.ruinsTitleReward = ret
		return remainsWarRead.ruinsTitleReward
	end)
	remainsWarRead:defineValue("tbDanCfg", function()
		_ENV, _ENV = nil, nil
		_ENV, (nil)[1], (nil).color = nil, nil, cc.c3b(200, 150, 0)
		_ENV, (nil)[2], (nil).color = nil, nil, cc.c3b(185, 185, 185)
		_ENV, (nil)[3], (nil).color = nil, nil, cc.c3b(225, 175, 25)
		_ENV, (nil)[4], (nil).color = nil, nil, cc.c3b(76, 226, 226)
		_ENV, (nil)[5], (nil).color = nil, nil, cc.c3b(235, 165, 255)
		_ENV, (nil)[6], (nil).color = nil, nil, cc.c3b(255, 85, 175)
		_ENV, (nil)[7], (nil).color = nil, nil, cc.c3b(255, 235, 35)
		;(nil)[8], (nil).color = nil, cc.c3b(255, 200, 100)
		return nil
	end)
	remainsWarRead:defineValue("tbSourceCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "SS"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "S"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "A"
		_UPVALUE0_, (nil)[4], (nil).name = nil, nil, "B"
		_UPVALUE0_, (nil)[5], (nil).name = nil, nil, "C"
		_UPVALUE0_, (nil)[6], (nil).name = nil, nil, "D"
		;(nil)[7], (nil).name = nil, ""
		return nil
	end)
	function _ENV()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "SS"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "S"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "A"
		_UPVALUE0_, (nil)[4], (nil).name = nil, nil, "B"
		_UPVALUE0_, (nil)[5], (nil).name = nil, nil, "C"
		_UPVALUE0_, (nil)[6], (nil).name = nil, nil, "D"
		;(nil)[7], (nil).name = nil, ""
		return nil
	end
	;(function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "SS"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "S"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "A"
		_UPVALUE0_, (nil)[4], (nil).name = nil, nil, "B"
		_UPVALUE0_, (nil)[5], (nil).name = nil, nil, "C"
		_UPVALUE0_, (nil)[6], (nil).name = nil, nil, "D"
		;(nil)[7], (nil).name = nil, ""
		return nil
	end)[1] = "ruins_war_shop"
	;(function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "SS"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "S"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "A"
		_UPVALUE0_, (nil)[4], (nil).name = nil, nil, "B"
		_UPVALUE0_, (nil)[5], (nil).name = nil, nil, "C"
		_UPVALUE0_, (nil)[6], (nil).name = nil, nil, "D"
		;(nil)[7], (nil).name = nil, ""
		return nil
	end)[2] = true
	remainsWarRead:defineValue("remainsShop", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).name = nil, nil, "SS"
		_UPVALUE0_, (nil)[2], (nil).name = nil, nil, "S"
		_UPVALUE0_, (nil)[3], (nil).name = nil, nil, "A"
		_UPVALUE0_, (nil)[4], (nil).name = nil, nil, "B"
		_UPVALUE0_, (nil)[5], (nil).name = nil, nil, "C"
		_UPVALUE0_, (nil)[6], (nil).name = nil, nil, "D"
		;(nil)[7], (nil).name = nil, ""
		return nil
	end)
end
function remainsWarRead.getRuinsTitleReward()
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	return remainsWarRead.ruinsTitleReward[classType]
end
function remainsWarRead.getBuffID(sourceid, effectType)
	return sourceid * 1000 + effectType
end
function remainsWarRead.getBuffName(bid)
	bid = tonumber(bid)
	return i18n(remainsWarRead.remainsWarBuffTable[bid].name)
end
function remainsWarRead.getBuffDes(bid, value)
	bid = tonumber(bid)
	if "number" == type(value) then
		_ENV = nil
		;(nil).value = value / 10
		return i18n(remainsWarRead.remainsWarBuffTable[bid].describe, nil)
	end
	return i18n(remainsWarRead.remainsWarBuffTable[bid].describe)
end
function remainsWarRead.getBuffIcon(bid)
	bid = tonumber(bid)
	return remainsWarRead.remainsWarBuffTable[bid].icon
end
function remainsWarRead.getBuffQuaitly(bid)
	bid = tonumber(bid)
	return remainsWarRead.remainsWarBuffTable[bid].itemquality
end
function remainsWarRead.getBuildName(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return i18n(remainsWarRead.tableRemainsWarBuildingInfo[buildTypeID].name)
end
function remainsWarRead.getBuildIcon(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return remainsWarRead.tableRemainsWarBuildingInfo[buildTypeID].icon
end
function remainsWarRead.getBuildImage(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return remainsWarRead.tableRemainsWarBuildingInfo[buildTypeID].image
end
function remainsWarRead.getBuffShowData(buffData)
	local buffid = buffData.src
	local buffConfigID = remainsWarRead.getBuffID(buffData.src, buffData.effect)
	remainsWarRead = buffData.src
	buffData.src.bid = buffid
	buffData.src.buffname = remainsWarRead.getBuffName(buffConfigID)
	buffData.src.bufdes = remainsWarRead.getBuffDes(buffConfigID, buffData.value)
	buffData.src.icon = remainsWarRead.getBuffIcon(buffConfigID)
	local buffData.src.quaitly, tableBuff = remainsWarRead.getBuffQuaitly(buffConfigID), buffData.src
	return tableBuff
end
function remainsWarRead.getDanIcon(danID)
	local cfg = remainsWarRead.tableSegmentDescribe[danID]
	if cfg then
		return cfg.icon
	end
	return "icon_segment_01.png"
end
function remainsWarRead.getDanBgImage(danID)
	local cfg = remainsWarRead.tableSegmentDescribe[danID]
	if cfg then
		return cfg.image
	end
	return "frame_segment_01.png"
end
function remainsWarRead.getDanNameIcon(danID)
	local key
	if SoraDFIsRA() then
		key = "icon_segment_name_%02d.png"
	else
		key = "icon_segment_name_en_%02d.png"
	end
	local frameName = string.format(key, danID)
	print(frameName, "frameName")
	return frameName
end
function remainsWarRead.getDanName(danID)
	local cfg = remainsWarRead.tableSegmentDescribe[danID]
	if cfg then
		return i18n(cfg.name)
	end
	return "NA"
end
function remainsWarRead.getScoreName(sourceID)
	local cfg = remainsWarRead.tbSourceCfg[sourceID]
	if cfg then
		return cfg.name
	end
	return ""
end
function remainsWarRead.getDanColor(danID)
	local cfg = remainsWarRead.tbDanCfg[danID]
	if cfg then
		return cfg.color
	end
	return cc.c3b(255, 255, 255)
end
function remainsWarRead.getWarStatusColor(suc)
	if suc then
		return cc.c3b(215, 195, 155)
	else
		return cc.c3b(150, 150, 150)
	end
end
_ENV, _ENV, remainsWarRead.getShopItemList = nil, function(segment)
	local _ENV, shopList
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	for _, v in ipairs(remainsWarRead.remainsShop) do
		if v.classType == classType and tonumber(v.segment) == tonumber(segment) then
			table.insert(shopList, v)
		end
	end
	return shopList
end, function(segment)
	local _ENV, shopList
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	for _, v in ipairs(remainsWarRead.remainsShop) do
		if v.classType == classType and tonumber(v.segment) == tonumber(segment) then
			table.insert(shopList, v)
		end
	end
	return shopList
end
;(nil).name = "common_text_4454"
;(nil).icon = "icon_input_ruins.png"
_ENV, (function(segment)
	local _ENV, shopList
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	for _, v in ipairs(remainsWarRead.remainsShop) do
		if v.classType == classType and tonumber(v.segment) == tonumber(segment) then
			table.insert(shopList, v)
		end
	end
	return shopList
end)[1], (nil).color = nil, nil, cc.c3b(255, 65, 45)
;(nil).name = "common_text_4455"
;(nil).icon = "icon_yjzz_lf.png"
;(function(segment)
	local _ENV, shopList
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	for _, v in ipairs(remainsWarRead.remainsShop) do
		if v.classType == classType and tonumber(v.segment) == tonumber(segment) then
			table.insert(shopList, v)
		end
	end
	return shopList
end)[2], (nil).color = nil, cc.c3b(100, 180, 230)
local function campCfg(segment)
	local _ENV, shopList
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	for _, v in ipairs(remainsWarRead.remainsShop) do
		if v.classType == classType and tonumber(v.segment) == tonumber(segment) then
			table.insert(shopList, v)
		end
	end
	return shopList
end
function remainsWarRead.getCampColor(camp)
	local cfg = campCfg[camp]
	if cfg then
		return cfg.color
	end
	return cc.c3b(255, 255, 255)
end
function remainsWarRead.getCampName(camp)
	local cfg = campCfg[camp] or campCfg[1]
	if cfg then
		return i18n(cfg.name)
	end
	return "NA"
end
function remainsWarRead.getCampIcon(camp)
	local cfg = campCfg[camp] or campCfg[1]
	if cfg then
		return cfg.icon
	end
end
function remainsWarRead.getRuinsTitleConfig(titleType)
	if titleType then
		return remainsWarRead.ruinsTitleConfig[titleType]
	else
		return remainsWarRead.ruinsTitleConfig
	end
end
function remainsWarRead.getRuinsTitleName(titleType)
	local data = remainsWarRead.getRuinsTitleConfig(titleType)
	return i18n(data.name)
end
function remainsWarRead.getRuinsTitleDes(titleType)
	local data = remainsWarRead.getRuinsTitleConfig(titleType)
	return i18n(data.describe)
end
function remainsWarRead.getRuinsTitleIcon(titleType)
	local data = remainsWarRead.getRuinsTitleConfig(titleType)
	return data.icon
end
init()
return remainsWarRead
