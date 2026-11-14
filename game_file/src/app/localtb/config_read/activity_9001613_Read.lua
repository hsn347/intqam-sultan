local activity_9001613_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "back_privileges_reward"
;(nil)[2] = true
activity_9001613_Read:defineValue("back_privileges_reward", nil)
activity_9001613_Read:defineValue("reward", function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "back_privileges_buff"
;(function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
activity_9001613_Read:defineValue("back_privileges_buff", function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "back_privileges_buff_des"
;(function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = false
activity_9001613_Read:defineValue("back_privileges_buff_des", function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.backReward = serviceFunctions.tableFormat(v.backReward, nil)
		table.insert(ret, v)
	end
	return ret
end)
activity_9001613_Read:defineValue("buffDes", function()
	local _ENV, ret
	for _, v in ipairs(activity_9001613_Read.back_privileges_buff_des) do
		ret[v.buffType] = v
	end
	return ret
end)
function activity_9001613_Read.getRewardCfg(lossDay)
	for i, v in ipairs(activity_9001613_Read.reward) do
		if lossDay >= v.lossDays[1] and lossDay <= v.lossDays[2] then
			return v
		end
	end
	return activity_9001613_Read.reward[#activity_9001613_Read.reward]
end
function activity_9001613_Read.getBuffCfg(backDay)
	for i, v in ipairs(activity_9001613_Read.back_privileges_buff) do
		if backDay >= v.backDays[1] and backDay <= v.backDays[2] then
			return v
		end
	end
	return nil
end
function activity_9001613_Read.getBuffDesCfg(buffType)
	return activity_9001613_Read.buffDes[buffType]
end
return activity_9001613_Read
