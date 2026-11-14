local activity_9001700_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "eid_fireworks_2025"
;(nil)[2] = true
activity_9001700_Read:defineValue("eid_fireworks_2025", nil)
activity_9001700_Read:defineValue("fireworksIDList", function()
	local _ENV, ret
	for __, v in ipairs(activity_9001700_Read.eid_fireworks_2025) do
		table.insert(ret, v.fireWorksID)
	end
	return ret
end)
function activity_9001700_Read.getFireworksIDList()
	return activity_9001700_Read.fireworksIDList
end
function activity_9001700_Read.getFireworksIDListByFireType(fireType)
	local _ENV, ret
	for __, fireWorksID in ipairs(activity_9001700_Read.fireworksIDList) do
		local _fireType = activity_9001700_Read.getFireWorksType(fireWorksID)
		if _fireType == fireType then
			table.insert(ret, fireWorksID)
		end
	end
	return ret
end
activity_9001700_Read:defineValue("fireworksIDConfig", function()
	local _ENV, ret
	for __, v in ipairs(activity_9001700_Read.eid_fireworks_2025) do
		if not ret[v.fireWorksType] then
			_ENV = ret[v.fireWorksType]
		end
		ret[v.fireWorksType] = ret[v.fireWorksType]
		local temp = ret[v.fireWorksType]
		for __, value in ipairs(v.fireWorksNeeds) do
			if not temp[value] then
				_ENV = temp[value]
			end
			temp[value] = temp[value]
			temp = temp[value]
		end
		table.insert(temp, v.fireWorksID)
	end
	return ret
end)
function activity_9001700_Read.getFireWorksID(fireType, select1, select2, select3)
	local config = activity_9001700_Read.fireworksIDConfig
	return config[fireType][select1][select2][select3][1]
end
activity_9001700_Read:defineValue("fireworksConfig", function()
	local _ENV, ret
	for __, v in ipairs(activity_9001700_Read.eid_fireworks_2025) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.material = serviceFunctions.tableFormat(v.material, nil)
		ret[v.fireWorksID] = v
	end
	return ret
end)
function activity_9001700_Read.getFireWorksType(fireWorksID)
	local cfg = activity_9001700_Read.fireworksConfig[fireWorksID]
	return cfg.fireWorksType
end
function activity_9001700_Read.getFireWorksMaterial(fireWorksID)
	local cfg = activity_9001700_Read.fireworksConfig[fireWorksID]
	return cfg.material
end
function activity_9001700_Read.getFireWorksNeeds(fireWorksID)
	local cfg = activity_9001700_Read.fireworksConfig[fireWorksID]
	return cfg.fireWorksNeeds
end
activity_9001700_Read:defineValue("fireworksRewardConfig", function()
	local _ENV, ret
	local baseConfig = require_data("eid_fireworks_reward_2025", true).data
	for __, v in ipairs(baseConfig) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.fireWorksReward = serviceFunctions.tableFormat(v.fireWorksReward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		ret[v.classType][v.fireWorksID] = v
	end
	return ret
end)
function activity_9001700_Read.getFireWorksReward(fireWorksID)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.NORMAL_ACTIVITY_9001700)
	local config = activity_9001700_Read.fireworksRewardConfig[classType]
	local cfg = config[fireWorksID]
	return cfg.fireWorksReward
end
activity_9001700_Read:defineValue("materialIDList", function()
	local _ENV, map
	for __, v in pairs(activity_9001700_Read.fireworksConfig) do
		for __, w in ipairs(v.material) do
			map[w.id] = true
		end
	end
	local ret = table.keys(map)
	table.sort(ret)
	return ret
end)
function activity_9001700_Read.getMaterialIDList(...)
	return activity_9001700_Read.materialIDList
end
activity_9001700_Read:defineValue("drawingCostConfig", function()
	local _ENV, ret
	for __, v in ipairs(activity_9001700_Read.eid_fireworks_2025) do
		if not ret[v.fireWorksType] then
			ret[v.fireWorksType] = v.drawingCost[1]
		end
	end
	return ret
end)
function activity_9001700_Read.getDrawingCostConfig(...)
	return activity_9001700_Read.drawingCostConfig
end
function activity_9001700_Read.getDrawingCostItemID(fireType)
	return activity_9001700_Read.drawingCostConfig[fireType]
end
activity_9001700_Read:defineValue("fireworksShowConfig", function()
	local _ENV, ret
	local baseConfig = require_data("eid_fireworks_show_2025", false).data
	for __, v in ipairs(baseConfig) do
		local fireWorksType = v.fireWorksType
		if not ret[fireWorksType] then
			_ENV = ret[fireWorksType]
		end
		ret[fireWorksType] = ret[fireWorksType]
		local moduleType = v.moduleType[1]
		if not ret[fireWorksType][moduleType] then
			_ENV = ret[fireWorksType][moduleType]
		end
		ret[fireWorksType][moduleType] = ret[fireWorksType][moduleType]
		_ENV = nil
		;(nil).resourceAr = v.resourceAr
		;(nil).resourceEn = v.resourceEn
		table.insert(ret[fireWorksType][moduleType], nil)
	end
	return ret
end)
function activity_9001700_Read.getFireworksShowConfig(fireType, selectType)
	if not activity_9001700_Read.fireworksShowConfig[fireType] then
		local activity_9001700_Read, config = activity_9001700_Read.fireworksShowConfig[fireType], activity_9001700_Read.fireworksShowConfig[fireType]
	end
	if not config[selectType] then
		activity_9001700_Read = config[selectType]
	end
	return config[selectType]
end
function activity_9001700_Read.getFireworkResource(fireType, selectType, selectValue)
	local config = activity_9001700_Read.getFireworksShowConfig(fireType, selectType)
	local cfg = config[selectValue]
	if SoraDFIsRA() then
		return cfg.resourceAr
	else
		return cfg.resourceEn
	end
end
activity_9001700_Read:defineValue("fireworksTaskConfig", function()
	local baseConfig = require_data("eid_fireworks_task_2025", true).data
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activity_9001700_Read.getKeyListConfig(baseConfig, nil, "taskID")
end)
function activity_9001700_Read.getTaskIDList(taskType)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.NORMAL_ACTIVITY_9001700)
	if not activity_9001700_Read.fireworksTaskConfig[classType][taskType] then
		_ENV = activity_9001700_Read.fireworksTaskConfig[classType][taskType]
	end
	return activity_9001700_Read.fireworksTaskConfig[classType][taskType]
end
function activity_9001700_Read.getConstValueArray(valueType, defaultValue)
	local constantRead = include("constantRead")
	_UPVALUE4_ = nil
	;(nil)[1] = 16
	;(nil)[2] = 7200
	;(nil)[3] = 5
	;(nil)[4] = 999
	local valueArray = constantRead.getConstValueArray("EID_FIREWORKS_2025_TIME", nil)
	return valueArray[valueType] or defaultValue or 0
end
function activity_9001700_Read.getLetOffBeginTime(...)
	local beginTime = activity_9001700_Read.getConstValueArray(1, 16)
	return serviceFunctions.getTodayZeroHourUTC() + beginTime * 3600
end
function activity_9001700_Read.getLetOffRemainTime(...)
	local beginTime = activity_9001700_Read.getLetOffBeginTime()
	local remainTime = beginTime - serviceFunctions.systemTime()
	return remainTime
end
function activity_9001700_Read.checkInLetOffTime(...)
	local curTime = serviceFunctions.systemTime()
	local beginTime = activity_9001700_Read.getLetOffBeginTime()
	local duration = activity_9001700_Read.getLetOffDuration()
	if curTime >= beginTime and curTime < beginTime + duration then
		return true
	else
		return false
	end
end
function activity_9001700_Read.singleClickEvent(...)
	local curTime = serviceFunctions.systemTime()
	local beginTime = activity_9001700_Read.getLetOffBeginTime()
	local duration = activity_9001700_Read.getLetOffDuration()
	if curTime < beginTime - 1800 or curTime > beginTime + duration then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.NORMAL_ACTIVITY_9001700)
	else
		uiManager:show("Activity_9001700_LetOff")
	end
end
function activity_9001700_Read.getLetOffDuration(...)
	return activity_9001700_Read.getConstValueArray(2, 7200)
end
function activity_9001700_Read.getFireWorksDuration(...)
	return activity_9001700_Read.getConstValueArray(3, 5)
end
function activity_9001700_Read.getFireWorksActionConfig()
	local constantRead = include("constantRead")
	_UPVALUE4_ = nil
	;(nil)[1] = 0.5
	;(nil)[2] = 0.5
	;(nil)[3] = 2
	;(nil)[4] = 0.5
	local valueArray = constantRead.getConstValueArray("EID_FIREWORKS_2025_SHOW", nil)
	return valueArray
end
return activity_9001700_Read
