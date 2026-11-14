local activityDropRead = include("aAReadClass").new()
activityDropRead:defineValue("common_activity_drop", function()
	local _ENV, config
	local cfg = require_data("common_activity_drop", true).data
	for i, v in ipairs(cfg) do
		if not config[v.ActivityID] then
			config[v.ActivityID], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType] then
			config[v.ActivityID][v.classType], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType][v.type] then
			config[v.ActivityID][v.classType][v.type], _ENV = nil, nil
		end
		if not SoraDisInList(v.drop[1], config[v.ActivityID][v.classType][v.type]) then
			table.insert(config[v.ActivityID][v.classType][v.type], v.drop[1])
		end
	end
	activityDropRead.common_activity_drop = config
	return activityDropRead.common_activity_drop
end)
function activityDropRead.getDropItems(activityID, classType, enumType)
	return activityDropRead.common_activity_drop[activityID][classType][enumType]
end
function _UPVALUE2_()
	local _ENV, config
	local cfg = require_data("common_activity_drop", true).data
	for i, v in ipairs(cfg) do
		if not config[v.ActivityID] then
			config[v.ActivityID], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType] then
			config[v.ActivityID][v.classType], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType][v.type] then
			config[v.ActivityID][v.classType][v.type], _ENV = nil, nil
		end
		if not SoraDisInList(v.drop[1], config[v.ActivityID][v.classType][v.type]) then
			table.insert(config[v.ActivityID][v.classType][v.type], v.drop[1])
		end
	end
	activityDropRead.common_activity_drop = config
	return activityDropRead.common_activity_drop
end
;(function()
	local _ENV, config
	local cfg = require_data("common_activity_drop", true).data
	for i, v in ipairs(cfg) do
		if not config[v.ActivityID] then
			config[v.ActivityID], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType] then
			config[v.ActivityID][v.classType], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType][v.type] then
			config[v.ActivityID][v.classType][v.type], _ENV = nil, nil
		end
		if not SoraDisInList(v.drop[1], config[v.ActivityID][v.classType][v.type]) then
			table.insert(config[v.ActivityID][v.classType][v.type], v.drop[1])
		end
	end
	activityDropRead.common_activity_drop = config
	return activityDropRead.common_activity_drop
end)[1] = "drop_type"
;(function()
	local _ENV, config
	local cfg = require_data("common_activity_drop", true).data
	for i, v in ipairs(cfg) do
		if not config[v.ActivityID] then
			config[v.ActivityID], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType] then
			config[v.ActivityID][v.classType], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType][v.type] then
			config[v.ActivityID][v.classType][v.type], _ENV = nil, nil
		end
		if not SoraDisInList(v.drop[1], config[v.ActivityID][v.classType][v.type]) then
			table.insert(config[v.ActivityID][v.classType][v.type], v.drop[1])
		end
	end
	activityDropRead.common_activity_drop = config
	return activityDropRead.common_activity_drop
end)[2] = true
activityDropRead:defineValue("drop_type", function()
	local _ENV, config
	local cfg = require_data("common_activity_drop", true).data
	for i, v in ipairs(cfg) do
		if not config[v.ActivityID] then
			config[v.ActivityID], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType] then
			config[v.ActivityID][v.classType], _ENV = nil, nil
		end
		if not config[v.ActivityID][v.classType][v.type] then
			config[v.ActivityID][v.classType][v.type], _ENV = nil, nil
		end
		if not SoraDisInList(v.drop[1], config[v.ActivityID][v.classType][v.type]) then
			table.insert(config[v.ActivityID][v.classType][v.type], v.drop[1])
		end
	end
	activityDropRead.common_activity_drop = config
	return activityDropRead.common_activity_drop
end)
function activityDropRead.getMaxDrop(activityID, enumType)
	local maxDrop = 0
	for k, v in ipairs(activityDropRead.drop_type) do
		if v.ActivityType == 1 then
			if v.ActivityID == activityID and v.type == enumType then
				maxDrop = v.maxDrop
				break
			end
		elseif v.ActivityID == activityID then
			maxDrop = v.maxDrop
			break
		end
	end
	return maxDrop
end
function activityDropRead.getDropTypeConfig(dropType)
	_ENV = nil
	_ENV = nil
	;(nil).name = i18n("common_text_3531")
	;(nil).des = i18n("droptaskdes01")
	;(nil)[gActivityDropType.KILL_MONSTER], (nil).icon = nil, "icon_building_arena.png"
	_ENV = nil
	;(nil).name = i18n("common_text_3532")
	;(nil).des = i18n("droptaskdes02")
	;(nil)[gActivityDropType.COLLECT_RES], (nil).icon = nil, "icon_map_operate_19.png"
	_ENV = nil
	;(nil).name = i18n("common_text_3533")
	;(nil).des = i18n("droptaskdes03")
	;(nil)[gActivityDropType.OUTCITY_RES], (nil).icon = nil, "icon_map_operate_18.png"
	_ENV = nil
	;(nil).name = i18n("common_text_3534")
	;(nil).des = i18n("droptaskdes04")
	;(nil)[gActivityDropType.TREVI_FOUNTAIN], (nil).icon = nil, "icon_building_life_water.png"
	local config
	if not config[dropType] then
		local _ENV, cfg = config[dropType], config[dropType]
	end
	cfg.dropType = dropType
	return cfg
end
function activityDropRead.getEventList(activityID)
	_UPVALUE4_, _ENV = nil, nil
	;(nil).default, (nil)[1] = nil, gActivityDropType.KILL_MONSTER
	;(nil).default, (nil)[2] = nil, gActivityDropType.COLLECT_RES
	;(nil).default, (nil)[3] = nil, gActivityDropType.OUTCITY_RES
	;(nil).default, (nil)[4] = nil, gActivityDropType.TREVI_FOUNTAIN
	_UPVALUE4_ = gActivityDropType.KILL_MONSTER
	;(nil)[gActivityTimeActivityID.NEBULA_SURPRISED_DROP], gActivityDropType.KILL_MONSTER[1] = gActivityDropType.KILL_MONSTER, gActivityDropType.KILL_MONSTER
	;(nil)[gActivityTimeActivityID.NEBULA_SURPRISED_DROP], gActivityDropType.KILL_MONSTER[2] = gActivityDropType.KILL_MONSTER, gActivityDropType.COLLECT_RES
	;(nil)[gActivityTimeActivityID.NEBULA_SURPRISED_DROP], gActivityDropType.KILL_MONSTER[3] = gActivityDropType.KILL_MONSTER, gActivityDropType.OUTCITY_RES
	;(nil)[gActivityTimeActivityID.NEBULA_SURPRISED_DROP], gActivityDropType.KILL_MONSTER[4] = gActivityDropType.KILL_MONSTER, gActivityDropType.TREVI_FOUNTAIN
	_UPVALUE4_ = gActivityDropType.KILL_MONSTER
	;(nil)[gActivityTimeActivityID.FROSTY_MARKET], gActivityDropType.KILL_MONSTER[1] = gActivityDropType.KILL_MONSTER, gActivityDropType.KILL_MONSTER
	;(nil)[gActivityTimeActivityID.FROSTY_MARKET], gActivityDropType.KILL_MONSTER[2] = gActivityDropType.KILL_MONSTER, gActivityDropType.COLLECT_RES
	;(nil)[gActivityTimeActivityID.FROSTY_MARKET], gActivityDropType.KILL_MONSTER[3] = gActivityDropType.KILL_MONSTER, gActivityDropType.OUTCITY_RES
	;(nil)[gActivityTimeActivityID.FROSTY_MARKET], gActivityDropType.KILL_MONSTER[4] = gActivityDropType.KILL_MONSTER, gActivityDropType.TREVI_FOUNTAIN
	local config
	local dropTypeList = config[activityID] or config.default
	local _ENV, eventList = gActivityDropType.KILL_MONSTER, gActivityDropType.KILL_MONSTER
	for __, dropType in ipairs(dropTypeList) do
		local cfg = activityDropRead.getDropTypeConfig(dropType)
		if dropType == gActivityDropType.TREVI_FOUNTAIN then
			local buildLogic = include("buildLogic")
			if buildLogic.isOwnBuildedBuilding(BUILDID.WISHING_WELL) then
				table.insert(eventList, cfg)
			end
		else
			table.insert(eventList, cfg)
		end
	end
	return eventList
end
function activityDropRead.clickBtnGo(dropType)
	SoraDRemoveAllPanelFromManager()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if dropType == gActivityDropType.KILL_MONSTER then
		_ENV = nil
		;(nil).chooseIndex = 1
		mildGuideManager:quickToWorldKillMonster(nil)
	elseif dropType == gActivityDropType.COLLECT_RES then
		_ENV = nil
		;(nil).chooseIndex = 3
		mildGuideManager:quickToWorldKillMonster(nil)
	elseif dropType == gActivityDropType.OUTCITY_RES then
		_ENV = nil
		mildGuideManager:startToHarvestResource(nil)
	elseif dropType == gActivityDropType.TREVI_FOUNTAIN then
		_ENV = nil
		mildGuideManager:starToWish(nil)
	end
end
return activityDropRead
