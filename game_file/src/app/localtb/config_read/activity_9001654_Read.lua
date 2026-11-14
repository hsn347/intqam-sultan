local activity_9001654_Read = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "flower_bloom_vault_config"
	;(nil)[2] = true
	activity_9001654_Read:defineValue("vaultConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "flower_bloom_vault_lock"
	;(nil)[2] = true
	activity_9001654_Read:defineValue("vaultLock", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "flower_bloom_extrareward"
	;(nil)[2] = true
	activity_9001654_Read:defineValue("extraReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "flower_bloom_luckyreward"
	;(nil)[2] = true
	activity_9001654_Read:defineValue("luckyreward", nil)
	activity_9001654_Read:defineValue("stagePos", function()
		_UPVALUE0_ = nil
		;(nil)[1] = 0.2
		;(nil)[2] = 0.45
		;(nil)[3] = 0.7
		;(nil)[4] = 1
		return nil
	end)
end
init()
local calculateStageStep = function()
	local data = activity_9001654_Read.extraReward
	local size = table.nums(activity_9001654_Read.extraReward)
	local activity_9001654_Read, step = activity_9001654_Read.extraReward, activity_9001654_Read.extraReward
	step[1] = activity_9001654_Read.stagePos[1] / data[1].lotteryTime
	for i = 2, size do
		local offset = activity_9001654_Read.stagePos[i] - activity_9001654_Read.stagePos[i - 1]
		step[i] = offset / (data[i].lotteryTime - data[i - 1].lotteryTime)
	end
	return step
end
activity_9001654_Read.stageStep = calculateStageStep()
function activity_9001654_Read.hadStageReward()
	for i, v in pairs(activity_9001654_Read.extraReward) do
		if v.extraReward then
			for _, t in pairs(v.extraReward) do
				if t and t ~= 0 then
					return true
				end
			end
		end
	end
	return false
end
function activity_9001654_Read.hadLuckReward()
	for i, v in pairs(activity_9001654_Read.vaultLock) do
		if v.luckyPoint ~= 0 then
			return true
		end
	end
	return false
end
function activity_9001654_Read.hadLuckGearReward()
	for i, v in pairs(activity_9001654_Read.luckyreward) do
		if v.gearReward then
			for _, t in pairs(v.gearReward) do
				if t and t ~= 0 then
					return true
				end
			end
		end
	end
	return false
end
function activity_9001654_Read.getLuckyCfg()
	return activity_9001654_Read.luckyreward
end
function activity_9001654_Read.getStageRewardByIndex(index)
	for i, v in ipairs(activity_9001654_Read.extraReward) do
		if v.lotteryTime == tonumber(index) then
			return v.extraReward
		end
	end
	_ENV = (for generator)
	return ipairs(activity_9001654_Read.extraReward)
end
function activity_9001654_Read:getStagePercent(curTimes)
	if curTimes >= activity_9001654_Read.getLastStageTimes() then
		return 1
	end
	local data = activity_9001654_Read.extraReward
	for i = 1, activity_9001654_Read.getExtraNum() do
		if curTimes <= data[i].lotteryTime then
			local percent = i == 1 and curTimes * activity_9001654_Read.stageStep[i] or activity_9001654_Read.stagePos[i - 1] + (curTimes - data[i - 1].lotteryTime) * activity_9001654_Read.stageStep[i]
			print("percentage " .. percent)
			return percent
		end
	end
end
function activity_9001654_Read.getLastStageTimes()
	local num = activity_9001654_Read.getExtraNum()
	return activity_9001654_Read.extraReward[num].lotteryTime
end
function activity_9001654_Read:getLuckyPercent(luckyPoint)
	if 999 <= luckyPoint then
		return 1
	end
	return luckyPoint / 1000
end
function activity_9001654_Read.getLastLuckyPointGear()
	local num = activity_9001654_Read.getLuckyNum()
	return activity_9001654_Read.luckyreward[num].luckyPointGear[2]
end
function activity_9001654_Read.getExtraConfig()
	if not activity_9001654_Read.extraReward then
		activity_9001654_Read = activity_9001654_Read.extraReward
	end
	return activity_9001654_Read.extraReward
end
function activity_9001654_Read.getLockNum(index)
	return table.nums(activity_9001654_Read.vaultLock[index].cost)
end
function activity_9001654_Read.getLuckyNum()
	return table.nums(activity_9001654_Read.luckyreward)
end
function activity_9001654_Read.getConfigNum(group)
	local index = 0
	for _, v in ipairs(activity_9001654_Read.vaultConfig) do
		if v.group == group then
			index = index + 1
		end
	end
	return index
end
function activity_9001654_Read.getExtraNum()
	return table.nums(activity_9001654_Read.extraReward) or 0
end
function activity_9001654_Read.getCost(index)
	local itemInfo = activity_9001654_Read.vaultLock[index]
	if itemInfo then
		return itemInfo.cost
	end
	return 0
end
function activity_9001654_Read.getCostByRound(round)
	for i, v in ipairs(activity_9001654_Read.vaultLock) do
		if v.round == round then
			return v.cost
		end
	end
end
function activity_9001654_Read.getAward(group)
	local _ENV, backTbl
	local index = 1
	for _, v in ipairs(activity_9001654_Read.vaultConfig) do
		if v.group == group then
			_ENV = v.group
			v.group.itemid = v.rewards[1]
			v.group.count = v.rewards[2]
			v.group.rare = v.rare
			local v.group.index, single = index, v.group
			backTbl[v.position] = single
			index = index + 1
		end
	end
	return backTbl
end
function activity_9001654_Read.getAwardByValue(group)
	local activity_9001654_Read, backTbl
	local tmpTbl = activity_9001654_Read.vaultConfig
	table.sort(tmpTbl, function(l, r)
		if l.Value < r.Value then
			return true
		elseif l.Value > r.Value then
			return false
		else
			return l.position < r.position
		end
	end)
	local j = 1
	for i, v in ipairs(tmpTbl) do
		if v.group == group then
			activity_9001654_Read = v.group
			v.group.itemid = v.rewards[1]
			v.group.count = v.rewards[2]
			local v.group.position, single = v.position, v.group
			backTbl[j] = single
			j = j + 1
		end
	end
	return backTbl
end
return activity_9001654_Read
