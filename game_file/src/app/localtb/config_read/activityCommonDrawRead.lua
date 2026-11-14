local activityCommonDrawRead = include("aAReadClass").new()
activityCommonDrawRead:defineValue("activity_9001640_config", function()
	local config = require_data("phoenix_arrival_stage_reward", true).data
	return activityCommonDrawRead.getClassTypeConfig(config, "classType")
end)
function activityCommonDrawRead.activity_9001640_getBoxConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.PHOENIX_ARRIVAL)
	return activityCommonDrawRead.activity_9001640_config[classType] or activityCommonDrawRead.activity_9001640_config[1]
end
function activityCommonDrawRead.activity_9001640_getScoreList()
	local activityCommonDrawRead, ret
	local boxConfig = activityCommonDrawRead.activity_9001640_getBoxConfig()
	for i, cfg in ipairs(boxConfig) do
		local point = activityCommonDrawRead.activity_9001640_getPoint(cfg)
		table.insert(ret, point)
	end
	return ret
end
function activityCommonDrawRead.activity_9001640_getPoint(cfg)
	return cfg and cfg.rankNum or 0
end
function activityCommonDrawRead.activity_9001640_getReward(cfg)
	if not cfg or not cfg.reward then
		_UPVALUE0_ = cfg.reward
	end
	return cfg.reward
end
activityCommonDrawRead:defineValue("prayer_lamp_2025_random", function()
	local config = require_data("prayer_lamp_2025_random", true).data
	return activityCommonDrawRead.getClassTypeConfig(config, "classType")
end)
activityCommonDrawRead:defineValue("prayer_lamp_2025_stage", function()
	local config = require_data("prayer_lamp_2025_stage", true).data
	return activityCommonDrawRead.getClassTypeConfig(config, "classType")
end)
function activityCommonDrawRead.activity_9001718_getDrawCost()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.LAMP_WISH_ACTIVITY)
	return activityCommonDrawRead.prayer_lamp_2025_random[classType][1].drawCost
end
function activityCommonDrawRead.activity_9001718_getMayReward()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.LAMP_WISH_ACTIVITY)
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "weight"
	local normalReward = serviceFunctions.tableFormat(activityCommonDrawRead.prayer_lamp_2025_random[classType][1].normalReward, nil)
	_UPVALUE3_ = "id"
	;("id")[1] = "id"
	;("id")[2] = "count"
	;("id")[3] = "weight"
	local superReward = serviceFunctions.tableFormat(activityCommonDrawRead.prayer_lamp_2025_random[classType][1].superReward, "id")
	local _ENV, ret = activityCommonDrawRead.prayer_lamp_2025_random[classType][1].superReward, activityCommonDrawRead.prayer_lamp_2025_random[classType][1].superReward
	for _, v in ipairs(superReward) do
		v.effect = 2
		table.insert(ret, v)
	end
	for _, v in ipairs(normalReward) do
		table.insert(ret, v)
	end
	return ret
end
function activityCommonDrawRead.isSuperReward(id, count)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.LAMP_WISH_ACTIVITY)
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "weight"
	local superReward = serviceFunctions.tableFormat(activityCommonDrawRead.prayer_lamp_2025_random[classType][1].superReward, nil)
	return id == superReward[1].id and count == superReward[1].count
end
function activityCommonDrawRead.activity_9001718_getStageCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.LAMP_WISH_ACTIVITY)
	return activityCommonDrawRead.prayer_lamp_2025_stage[classType]
end
return activityCommonDrawRead
