local activity_9001597_Read = include("aAReadClass").new()
activity_9001597_Read:defineValue("salvoalliancesreward", function()
	local _ENV, ret
	local oriData = require_data("salvoalliancesreward", true, true).data
	for i, v in ipairs(oriData) do
		local classType = v.classType
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		table.insert(ret[classType], v)
	end
	return ret
end)
activity_9001597_Read:defineValue("salvorankreward", function()
	local _ENV, ret
	local oriData = require_data("salvorankreward", true, true).data
	for i, v in ipairs(oriData) do
		local classType = v.classType
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		table.insert(ret[classType], v)
	end
	return ret
end)
activity_9001597_Read:defineValue("salvorewardscan", function()
	local _ENV, ret
	local oriData = require_data("salvorewardscan", true, true).data
	for i, v in ipairs(oriData) do
		local classType = v.classType
		_UPVALUE1_ = nil
		;(nil)[1] = "id"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "itemNum"
		;(nil)[2] = "times"
		v.EffectTimes = serviceFunctions.tableFormat(v.EffectTimes, nil)
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.Uitype] = v
	end
	return ret
end)
function activity_9001597_Read.getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local group = activityShowCtrl:getParamClassType(gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597)
	return group
end
function activity_9001597_Read.getBoxCfgs()
	local group = activity_9001597_Read.getGroup()
	return activity_9001597_Read.salvoalliancesreward[group]
end
function activity_9001597_Read.getShowReward(uiType)
	local group = activity_9001597_Read.getGroup()
	return activity_9001597_Read.salvorewardscan[group][uiType].reward
end
function activity_9001597_Read.getRankRewards()
	local group = activity_9001597_Read.getGroup()
	return activity_9001597_Read.salvorankreward[group]
end
function activity_9001597_Read.getPlayTimes(itemID, count)
	if activity_9001597_Read.itemID1 == nil then
		local constantRead = include("constantRead")
		activity_9001597_Read.itemID1 = constantRead.getConstValue("RAMADAN_2024_ORDINARY_SALUTE", 867701)
	end
	local group = activity_9001597_Read.getGroup()
	local effectTimes
	local effectType = activity_9001597_Read.itemID1 == itemID and 1 or 2
	effectTimes = activity_9001597_Read.salvorewardscan[group][effectType + 1].EffectTimes
	for i, v in ipairs(effectTimes) do
		if count <= v.itemNum then
			return v.times, effectType
		end
	end
	return effectTimes[#effectTimes].times, effectType
end
return activity_9001597_Read
