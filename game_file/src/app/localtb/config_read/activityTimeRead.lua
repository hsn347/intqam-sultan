local activityTimeRead = include("aAReadClass").new()
local getKey = function(activityID, atype)
	return tostring(activityID) .. tostring(atype)
end
function activityTimeRead.init()
	getKey = nil
	;(nil)[1] = "activitytime"
	;(nil)[2] = true
	activityTimeRead:defineValue("activitytime", nil)
	activityTimeRead:defineValue("activitymap", function()
		activityTimeRead.activitymap, activityTimeRead = nil, nil
		for i, v in ipairs(activityTimeRead.activitytime) do
			activityTimeRead.activitymap[getKey(v.ID, v.type)] = v
		end
		return activityTimeRead.activitymap
	end)
	function _ENV()
		activityTimeRead.activitymap, activityTimeRead = nil, nil
		for i, v in ipairs(activityTimeRead.activitytime) do
			activityTimeRead.activitymap[getKey(v.ID, v.type)] = v
		end
		return activityTimeRead.activitymap
	end
	;(function()
		activityTimeRead.activitymap, activityTimeRead = nil, nil
		for i, v in ipairs(activityTimeRead.activitytime) do
			activityTimeRead.activitymap[getKey(v.ID, v.type)] = v
		end
		return activityTimeRead.activitymap
	end)[1] = "activityconfig"
	activityTimeRead:defineValue("activityconfig", function()
		activityTimeRead.activitymap, activityTimeRead = nil, nil
		for i, v in ipairs(activityTimeRead.activitytime) do
			activityTimeRead.activitymap[getKey(v.ID, v.type)] = v
		end
		return activityTimeRead.activitymap
	end)
	activityTimeRead:defineValue("activityconfigmap", function()
		activityTimeRead.activityconfigmap, activityTimeRead = nil, nil
		for i, v in ipairs(activityTimeRead.activityconfig) do
			activityTimeRead.activityconfigmap[getKey(v.ID, v.type)] = v
		end
		return activityTimeRead.activityconfigmap
	end)
end
function activityTimeRead.getActivityShowByID(activityID, type)
	local ret = false
	if activityID == nil then
		return ret
	end
	type = type or 0
	local activityIDStr = getKey(activityID, type)
	if activityTimeRead.activitymap[activityIDStr] then
		ret = activityTimeRead.activitymap[activityIDStr].show == 1
	elseif type == 0 then
		return activityTimeRead.getActivityShowByID(activityID, 1)
	end
	return ret
end
function activityTimeRead.getActivityEnemyShowByID(activityID, type)
	local ret = true
	if activityID == nil then
		return ret
	end
	type = type or 0
	local activityIDStr = getKey(activityID, type)
	if activityTimeRead.activitymap[activityIDStr] then
		ret = activityTimeRead.activitymap[activityIDStr].enemyshow == 1
	elseif type == 0 then
		return activityTimeRead.getActivityEnemyShowByID(activityID, 1)
	end
	return ret
end
function activityTimeRead.getActivityReward(activityID, type)
	type = type or 0
	local activityIDStr = getKey(activityID, type)
	local cfg = activityTimeRead.activitymap[activityIDStr]
	if cfg then
		_ENV = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		return serviceFunctions.tableFormat(cfg.reward, nil)
	elseif type == 0 then
		return activityTimeRead.getActivityReward(activityID, 1)
	end
	getKey = activityTimeRead.getActivityReward
	return activityTimeRead.getActivityReward
end
function activityTimeRead.getActivityID(rechargeId)
	for k, v in pairs(activityTimeRead.activitymap) do
		if table.keyof(v.rechargeId, rechargeId) then
			return v.ID
		end
	end
end
function activityTimeRead.getRechargeId(activityID, classtype)
	for k, v in ipairs(activityTimeRead.activitytime) do
		if v.ID == activityID then
			if classtype == nil then
				return v.rechargeId
			elseif v.type == classtype then
				return v.rechargeId
			end
		end
	end
end
function activityTimeRead.getShowUnlockLv(activityID)
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	local config = activityTimeRead.getActivityTimeConfigByID(activityID, param.classtype)
	if config and (config.showLevel > 0 or 0 < config.unlockLevel) then
		return true, config.showLevel, config.unlockLevel
	else
		print("活动未配置activityID=====", activityID)
	end
end
function activityTimeRead.getBuildType(activityID)
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	local config = activityTimeRead.getActivityTimeConfigByID(activityID, param.classtype)
	if config and config.buildType and next(config.buildType) then
		return config.buildType
	end
end
function activityTimeRead.getActivityNameByID(activityID, type)
	local activityname = ""
	if activityID == nil then
		return activityname
	end
	local config = activityTimeRead.getActivityConfigByID(activityID, type)
	if config then
		activityname = config.activityname
		if activityname == "" then
			activityname = string.format("activity_name_%s", activityID)
		end
	elseif type == 0 then
		return activityTimeRead.getActivityNameByID(activityID, 1)
	else
		activityname = string.format("activity_name_%s", activityID)
	end
	return activityname
end
function activityTimeRead.getActivityShowName(activityID, classType)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	classType = classType or activityShowCtrl:getParamClassType(activityID)
	return i18n(activityTimeRead.getActivityNameByID(activityID, classType))
end
function activityTimeRead.getActivityDesByID(activityID, type)
	local activitydes = ""
	if activityID == nil then
		return activitydes
	end
	local config = activityTimeRead.getActivityConfigByID(activityID, type)
	if config then
		activitydes = config.activitydes
	end
	return activitydes
end
function activityTimeRead.getActivityIconByID(activityID, type)
	local activity_icon = "icon_activity_match.png"
	if activityID == nil then
		return activity_icon
	end
	local config = activityTimeRead.getActivityConfigByID(activityID, type)
	if config then
		activity_icon = config.activity_icon
		if activity_icon == "" then
			activity_icon = string.format("icon_activity_%s.png", tostring(activityID))
		end
		if config.activity_icon_en and config.activity_icon_en ~= "" then
			activity_icon = SoraDFIsRA() and config.activity_icon or config.activity_icon_en
		end
	else
		activity_icon = string.format("icon_activity_%s.png", tostring(activityID))
	end
	return activity_icon
end
function activityTimeRead.getActivityBgByID(activityID, type)
	local activity_bg = "bg_activity_03.png"
	if activityID == nil then
		return activity_bg
	end
	local config = activityTimeRead.getActivityConfigByID(activityID, type)
	if config then
		activity_bg = config.activity_bg
		if activity_bg == "" then
			activity_bg = string.format("bg_activity_%s.png", tostring(activityID))
		end
		if config.activity_bg_en and config.activity_bg_en ~= "" then
			activity_bg = SoraDFIsRA() and config.activity_bg or config.activity_bg_en
		end
	else
		activity_bg = string.format("bg_activity_%s.png", tostring(activityID))
	end
	return activity_bg
end
function activityTimeRead.getActivityBgShow(activityID, type)
	if activityID == nil then
		return false
	end
	local config = activityTimeRead.getActivityConfigByID(activityID, type)
	if config and config.bg_show == 1 then
		return false
	end
	return true
end
function activityTimeRead.getActivityShowReward(activityID, type)
	local config = activityTimeRead.getActivityConfigByID(activityID, type)
	if not config or not config.show_reward then
		activityTimeRead = config.show_reward
	end
	return config.show_reward
end
function activityTimeRead.getActivityConfigByID(activityID, type)
	local activityIDStr = getKey(activityID, 0)
	local config = activityTimeRead.activityconfigmap[activityIDStr]
	if not config then
		if not type or type == 0 then
			type = 1
		end
		activityIDStr = getKey(activityID, type)
		config = activityTimeRead.activityconfigmap[activityIDStr]
	end
	return config
end
function activityTimeRead.getActivityTimeConfigByID(activityID, type)
	local activityIDStr = getKey(activityID, 0)
	local config = activityTimeRead.activitymap[activityIDStr]
	if not config then
		if not type or type == 0 then
			type = 1
		end
		activityIDStr = getKey(activityID, type)
		config = activityTimeRead.activitymap[activityIDStr]
	end
	return config
end
function activityTimeRead.checkActivityShowLevel(activityID)
	local isCfg, showLevel, unlockLevel = activityTimeRead.getShowUnlockLv(activityID)
	if isCfg and showLevel > SoraDGetCastleLv() then
		return false
	else
		return true
	end
end
function activityTimeRead.getNormalEventConfig(activityID, classType)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	_ENV, classType = activityShowCtrl:getParamClassType(activityID), classType or activityShowCtrl:getParamClassType(activityID)
	activityShowCtrl:getParamClassType(activityID).name = i18n(activityTimeRead.getActivityNameByID(activityID, classType))
	activityShowCtrl:getParamClassType(activityID).icon = activityTimeRead.getActivityIconByID(activityID, classType)
	activityShowCtrl:getParamClassType(activityID).bg = activityTimeRead.getActivityBgByID(activityID, classType)
	local activityShowCtrl:getParamClassType(activityID).noPage, config = not activityTimeRead.getActivityBgShow(activityID, classType), activityShowCtrl:getParamClassType(activityID)
	return config
end
activityTimeRead.init()
return activityTimeRead
