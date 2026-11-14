local earthTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "lucky_package"
	;(nil)[2] = true
	earthTreasureRead:defineValue("lucky_package", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "universe_startreward"
	;(nil)[2] = true
	earthTreasureRead:defineValue("universe_startreward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "universe_reward_pool"
	;(nil)[2] = true
	earthTreasureRead:defineValue("universe_reward_pool", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "universe_lock"
	;(nil)[2] = true
	earthTreasureRead:defineValue("universe_lock", nil)
end
init()
function earthTreasureRead.getGiftInfoByIndex(index)
	return earthTreasureRead.lucky_package[index]
end
function earthTreasureRead.getGiftID(index)
	return earthTreasureRead.lucky_package[index].package
end
function earthTreasureRead.getStarReward()
	return earthTreasureRead.universe_startreward
end
function earthTreasureRead.getRewardList(group)
	local _ENV, ret
	for i, v in ipairs(earthTreasureRead.universe_reward_pool) do
		if v.group == group then
			_ENV = nil
			;(nil).rewards = v.rewards
			;(nil).rare = v.rare
			table.insert(ret, nil)
		end
	end
	return ret
end
function earthTreasureRead.getCostByRound(round)
	if earthTreasureRead.universe_lock[round] then
		return earthTreasureRead.universe_lock[round].cost
	else
		return nil
	end
end
return earthTreasureRead
