local everydayTaskRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "daily_reward_point_items"
	;(nil)[2] = true
	everydayTaskRead:defineValue("config2", nil)
	everydayTaskRead = nil
	;(nil)[1] = "daily_reward_data"
	everydayTaskRead:defineValue("dailRewardData", nil)
	local createData = function(name)
		everydayTaskRead.localRewardPoint, everydayTaskRead, everydayTaskRead.config1 = require_data("daily_reward_point_config", true, true).data, require_data("daily_reward_point_config", true, true).data, require_data("daily_reward_point_config", true, true).data
		for key, value in pairs(everydayTaskRead.config1) do
			value.picIndex = key
			everydayTaskRead.localRewardPoint[value.type] = value
		end
		return everydayTaskRead[name]
	end
	everydayTaskRead:defineValue("config1", createData)
	everydayTaskRead:defineValue("localRewardPoint", createData)
	everydayTaskRead:defineValue("dailyJumpData", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		_UPVALUE0_, (nil)[1], (nil).resid = nil, nil, 1002
		_UPVALUE0_, (nil)[2], (nil).resid = nil, nil, 1003
		_UPVALUE0_, (nil)[3], (nil).resid = nil, nil, 1004
		_UPVALUE0_, (nil)[4], (nil).resid = nil, nil, 1005
		_UPVALUE0_, (nil)[9], (nil).id = nil, nil, 1
		_UPVALUE0_, (nil)[10], (nil).id = nil, nil, 4
		_UPVALUE0_, (nil)[12], (nil).bid = nil, nil, 118
		_UPVALUE0_, (nil)[13], (nil).bid = nil, nil, 117
		_UPVALUE0_, (nil)[14], (nil).bid = nil, nil, 116
		_UPVALUE0_, (nil)[15], (nil).bid = nil, nil, 119
		;(nil)[16], (nil).bid = nil, 120
		return nil
	end)
end
init()
function everydayTaskRead.getEverydayRewardPointConfig()
	return everydayTaskRead.localRewardPoint
end
function everydayTaskRead.getEverydayRewardItemsConfig()
	return everydayTaskRead.config2
end
function everydayTaskRead.getDailyRewardData(taskId)
	for k, v in pairs(everydayTaskRead.dailRewardData) do
		if k == taskId then
			return v
		end
	end
end
function everydayTaskRead.getDailyRewardHidden(taskId)
	for k, v in pairs(everydayTaskRead.dailRewardData) do
		if k == taskId then
			return v.hidden
		end
	end
end
function everydayTaskRead.getJumpData(taskId)
	local everydayTaskRead, ret
	if everydayTaskRead.dailyJumpData and everydayTaskRead.dailyJumpData[taskId] then
		ret = everydayTaskRead.dailyJumpData[taskId]
	end
	return ret
end
return everydayTaskRead
