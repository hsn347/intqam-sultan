local loudlyDressRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "loudlydressed_reward"
	;(nil)[2] = true
	loudlyDressRead:defineValue("reward", nil)
end
init()
function loudlyDressRead.getRewardByTimes(times)
	local times = math.min(times, #loudlyDressRead.reward)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(loudlyDressRead.reward[times].dailyReward, nil)
end
function loudlyDressRead.getCumuReward()
	local _ENV, cumuRewards
	local index = 1
	for k, v in ipairs(loudlyDressRead.reward) do
		if v.accumulateRewards and next(v.accumulateRewards) then
			cumuRewards = v.accumulateRewards
			index = v.index
		end
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return index, serviceFunctions.tableFormat(cumuRewards, nil)
end
function loudlyDressRead.getCfgNum()
	return #loudlyDressRead.reward
end
return loudlyDressRead
