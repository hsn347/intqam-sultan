local desertTreasureltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "desert_treasure_vault_config"
	;(nil)[2] = true
	desertTreasureltCtrl:defineValue("vaultConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "desert_treasure_vault_lock"
	;(nil)[2] = true
	desertTreasureltCtrl:defineValue("vaultLock", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "desert_treasur_extrareward"
	;(nil)[2] = true
	desertTreasureltCtrl:defineValue("extraReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "desert_treasur_luckyreward"
	;(nil)[2] = true
	desertTreasureltCtrl:defineValue("luckyreward", nil)
	desertTreasureltCtrl:defineValue("stagePos", function()
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
	local data = desertTreasureltCtrl.extraReward
	local size = table.nums(desertTreasureltCtrl.extraReward)
	local desertTreasureltCtrl, step = desertTreasureltCtrl.extraReward, desertTreasureltCtrl.extraReward
	step[1] = desertTreasureltCtrl.stagePos[1] / data[1].lotteryTime
	for i = 2, size do
		local offset = desertTreasureltCtrl.stagePos[i] - desertTreasureltCtrl.stagePos[i - 1]
		step[i] = offset / (data[i].lotteryTime - data[i - 1].lotteryTime)
	end
	return step
end
desertTreasureltCtrl.stageStep = calculateStageStep()
function desertTreasureltCtrl.hadStageReward()
	for i, v in pairs(desertTreasureltCtrl.extraReward) do
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
function desertTreasureltCtrl.hadLuckReward()
	for i, v in pairs(desertTreasureltCtrl.vaultLock) do
		if v.luckyPoint ~= 0 then
			return true
		end
	end
	return false
end
function desertTreasureltCtrl.hadLuckGearReward()
	for i, v in pairs(desertTreasureltCtrl.luckyreward) do
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
function desertTreasureltCtrl.getLuckyCfg()
	return desertTreasureltCtrl.luckyreward
end
function desertTreasureltCtrl.getStageRewardByIndex(index)
	for i, v in ipairs(desertTreasureltCtrl.extraReward) do
		if v.lotteryTime == tonumber(index) then
			return v.extraReward
		end
	end
	_ENV = (for generator)
	return ipairs(desertTreasureltCtrl.extraReward)
end
function desertTreasureltCtrl:getStagePercent(curTimes)
	if curTimes >= desertTreasureltCtrl.getLastStageTimes() then
		return 1
	end
	local data = desertTreasureltCtrl.extraReward
	for i = 1, desertTreasureltCtrl.getExtraNum() do
		if curTimes <= data[i].lotteryTime then
			local percent = i == 1 and curTimes * desertTreasureltCtrl.stageStep[i] or desertTreasureltCtrl.stagePos[i - 1] + (curTimes - data[i - 1].lotteryTime) * desertTreasureltCtrl.stageStep[i]
			print("percentage " .. percent)
			return percent
		end
	end
end
function desertTreasureltCtrl.getLastStageTimes()
	local num = desertTreasureltCtrl.getExtraNum()
	return desertTreasureltCtrl.extraReward[num].lotteryTime
end
function desertTreasureltCtrl:getLuckyPercent(luckyPoint)
	if 999 <= luckyPoint then
		return 1
	end
	return luckyPoint / 1000
end
function desertTreasureltCtrl.getLastLuckyPointGear()
	local num = desertTreasureltCtrl.getLuckyNum()
	return desertTreasureltCtrl.luckyreward[num].luckyPointGear[2]
end
function desertTreasureltCtrl.getExtraConfig()
	if not desertTreasureltCtrl.extraReward then
		desertTreasureltCtrl = desertTreasureltCtrl.extraReward
	end
	return desertTreasureltCtrl.extraReward
end
function desertTreasureltCtrl.getLockNum(index)
	return table.nums(desertTreasureltCtrl.vaultLock[index].cost)
end
function desertTreasureltCtrl.getLuckyNum()
	return table.nums(desertTreasureltCtrl.luckyreward)
end
function desertTreasureltCtrl.getConfigNum(group)
	local index = 0
	for _, v in ipairs(desertTreasureltCtrl.vaultConfig) do
		if v.group == group then
			index = index + 1
		end
	end
	return index
end
function desertTreasureltCtrl.getExtraNum()
	return table.nums(desertTreasureltCtrl.extraReward) or 0
end
function desertTreasureltCtrl.getCost(index)
	local itemInfo = desertTreasureltCtrl.vaultLock[index]
	if itemInfo then
		return itemInfo.cost
	end
	return 0
end
function desertTreasureltCtrl.getCostByRound(round)
	for i, v in ipairs(desertTreasureltCtrl.vaultLock) do
		if v.round == round then
			return v.cost
		end
	end
end
function desertTreasureltCtrl.getAward(group)
	local _ENV, backTbl
	local index = 1
	for _, v in ipairs(desertTreasureltCtrl.vaultConfig) do
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
function desertTreasureltCtrl.getAwardByValue(group)
	local desertTreasureltCtrl, backTbl
	local tmpTbl = desertTreasureltCtrl.vaultConfig
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
			desertTreasureltCtrl = v.group
			v.group.itemid = v.rewards[1]
			v.group.count = v.rewards[2]
			local v.group.position, single = v.position, v.group
			backTbl[j] = single
			j = j + 1
		end
	end
	return backTbl
end
return desertTreasureltCtrl
