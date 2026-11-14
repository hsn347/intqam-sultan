local castleSkinRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	castleSkinRead:defineValue("data", function()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end)
	function _ENV()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end
	;(function()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end)[1] = "castle_illustrated"
	;(function()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end)[2] = true
	castleSkinRead:defineValue("illustratedConfig", function()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end)
	function castleSkinRead()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end
	;(function()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end)[1] = "dress_type_group"
	castleSkinRead:defineValue("dressTypeGroup", function()
		local data = require_data("castleskin", false, true).data
		local popData = require_data("chatskin", false, true).data
		for k, v in pairs(popData) do
			data[k] = clone(v)
		end
		return data
	end)
	castleSkinRead:defineValue("skinQualityConfig", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).ar = "frame_skin_holiday_ar.png"
		_UPVALUE0_, (nil)[1], (nil).en = nil, nil, "frame_skin_holiday_en.png"
		;(nil).ar = "frame_skin_limit_ar.png"
		_UPVALUE0_, (nil)[2], (nil).en = nil, nil, "frame_skin_limit_en.png"
		;(nil).ar = "frame_skin_supreme_ar.png"
		;(nil)[3], (nil).en = nil, "frame_skin_supreme_en.png"
		return nil
	end)
	castleSkinRead:defineValue("desData", function()
		local desData = require_once("app." .. LocalTblPath .. ".config_server.dress_type_config")
		for _, v in pairs(desData) do
			_UPVALUE2_ = nil
			;(nil)[1] = "attrID"
			;(nil)[2] = "attrValue"
			v.ownAttribute = serviceFunctions.tableFormat(v.ownAttribute, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "attrID"
			;(nil)[2] = "attrValue"
			v.useAttribute = serviceFunctions.tableFormat(v.useAttribute, nil)
		end
		return desData
	end)
	castleSkinRead:defineValue("specialIllustrated", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.special_illustrated")
		local _ENV, specialCastleConfig = "app." .. LocalTblPath .. ".config_server.special_illustrated", "app." .. LocalTblPath .. ".config_server.special_illustrated"
		for i, v in ipairs(cfg) do
			specialCastleConfig[v.special_skin] = true
		end
		return specialCastleConfig
	end)
end
init()
function castleSkinRead.isSpecailCastel(dressID)
	return castleSkinRead.specialIllustrated[dressID]
end
function castleSkinRead.getName(sid)
	sid = tonumber(sid)
	return castleSkinRead.data[sid] and i18n(castleSkinRead.data[sid].name) or "???"
end
function castleSkinRead.getDes(sid)
	sid = tonumber(sid)
	if not castleSkinRead.data[sid] or not i18n(castleSkinRead.data[sid].des) then
		_ENV = nil
		;(nil).des = "??????"
	end
	return (i18n("common_text_1437", nil))
end
function castleSkinRead.getIcon(sid, fromMemory)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] and fromMemory then
		return "#" .. castleSkinRead.data[sid].icon
	end
	return castleSkinRead.data[sid] and castleSkinRead.data[sid].icon
end
function castleSkinRead.getSkinQuality(sid)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] then
		return castleSkinRead.data[sid].skinQuality
	end
end
function castleSkinRead.getSubType(sid)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] then
		return castleSkinRead.data[sid].subType
	end
end
function castleSkinRead.getSkinQualityBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.skinQuality
	end
	return 0
end
function castleSkinRead.getDressTypeBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.dType
	end
	return 0
end
function castleSkinRead.getSortIndexBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.sortIndex
	end
	return 0
end
function castleSkinRead.isAvailableBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.isAvailable
	end
	return 0
end
function castleSkinRead.getNameBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		if type(cfg.name) == "string" then
			return i18n(cfg.name)
		else
			return cfg.name and next(cfg.name) ~= nil and i18n(cfg.name) or ""
		end
	end
	return ""
end
function castleSkinRead.getIconBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.icon
	end
	return "icon_skin_selce_04.png"
end
function castleSkinRead.getSourceBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.sourceid
	end
	castleSkinRead = cfg.sourceid
	return cfg.sourceid
end
function castleSkinRead.getDressGroupBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.group
	end
	return 0
end
function castleSkinRead.getNameFloor(sid, fromMemory)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] and fromMemory then
		return "#" .. castleSkinRead.data[sid].namefloor
	end
	return castleSkinRead.data[sid] and castleSkinRead.data[sid].namefloor
end
function castleSkinRead.getValueByKey(sid, key)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] == nil or castleSkinRead.data[sid][key] == nil then
		return ""
	else
		return castleSkinRead.data[sid][key]
	end
end
function castleSkinRead.getMapImage(sid, fromMemory)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] and castleSkinRead.data[sid].mapimage == "" then
		return nil
	end
	if castleSkinRead.data[sid] and fromMemory then
		return "#" .. castleSkinRead.data[sid].mapimage
	end
	return castleSkinRead.data[sid] and castleSkinRead.data[sid].mapimage
end
function castleSkinRead.isWorldDress(sid)
	sid = tonumber(sid)
	if castleSkinRead.data[sid] and castleSkinRead.data[sid].mapimage ~= "" or sid == 9002100 then
		return true
	else
		return false
	end
end
function castleSkinRead.getCastleType(sid)
	sid = tonumber(sid)
	local castleType = 1
	if castleSkinRead.data[sid] and castleSkinRead.data[sid].Type then
		castleType = castleSkinRead.data[sid].Type
	end
	return castleType
end
function castleSkinRead.getMarchType(sid)
	sid = tonumber(sid)
	local marchType = 0
	if castleSkinRead.data[sid] and castleSkinRead.data[sid].subType then
		marchType = castleSkinRead.data[sid].subType
	end
	return marchType
end
function castleSkinRead.getChatFrameType(sid)
	sid = tonumber(sid)
	local fType = 1
	if castleSkinRead.data[sid] and castleSkinRead.data[sid].Type then
		fType = castleSkinRead.data[sid].Type
	end
	return fType
end
function castleSkinRead.getSkinQualityCfg(skinQuality)
	return castleSkinRead.skinQualityConfig[skinQuality]
end
function castleSkinRead.getOwnAttrBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.ownAttribute
	end
	castleSkinRead = cfg.ownAttribute
	return cfg.ownAttribute
end
function castleSkinRead.getUseAttrBySubType(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.useAttribute
	end
	castleSkinRead = cfg.useAttribute
	return cfg.useAttribute
end
function castleSkinRead.getSortIndex(subType)
	local cfg = castleSkinRead.desData[subType]
	if cfg then
		return cfg.sortIndex
	end
	return 0
end
function castleSkinRead.getIllustratedConfig()
	if not castleSkinRead.illustratedConfig then
		castleSkinRead = castleSkinRead.illustratedConfig
	end
	return castleSkinRead.illustratedConfig
end
function castleSkinRead.getStageInfo(stage)
	local stage = math.min(stage, table.nums(castleSkinRead.illustratedConfig))
	if not castleSkinRead.illustratedConfig[stage].stage_reward then
		_ENV = castleSkinRead.illustratedConfig[stage].stage_reward
	end
	return castleSkinRead.illustratedConfig[stage].stage_reward
end
function castleSkinRead.getGroupCfg(cType)
	local _ENV, ret
	for k, v in ipairs(castleSkinRead.dressTypeGroup) do
		if v.type == cType then
			table.insert(ret, v)
		end
	end
	return ret
end
return castleSkinRead
