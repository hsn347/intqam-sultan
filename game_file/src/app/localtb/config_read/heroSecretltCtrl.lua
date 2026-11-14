local heroSecretltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_vault_config"
	;(nil)[2] = true
	heroSecretltCtrl:defineValue("vaultConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_vault_lock"
	;(nil)[2] = true
	heroSecretltCtrl:defineValue("vaultLock", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_extrareward"
	;(nil)[2] = true
	heroSecretltCtrl:defineValue("extraReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_luckyreward"
	;(nil)[2] = true
	heroSecretltCtrl:defineValue("luckyreward", nil)
end
_ENV = nil
;(nil)[1] = 1
;(nil)[2] = 2
;(nil)[3] = 4
;(nil)[4] = 6
;(nil)[5] = 8
;(nil)[6] = 10
;(nil)[7] = 12
;(nil)[8] = 11
;(nil)[9] = 9
;(nil)[10] = 7
;(nil)[11] = 5
local (nil)[12], indexToPosition = 3, nil
init()
function heroSecretltCtrl.getLuckyCfg()
	return heroSecretltCtrl.luckyreward
end
function heroSecretltCtrl.getStageRewardByIndex(index)
	for i, v in ipairs(heroSecretltCtrl.extraReward) do
		if v.lotteryTime == tonumber(index) then
			return v.extraReward
		end
	end
	_ENV = (for generator)
	return ipairs(heroSecretltCtrl.extraReward)
end
function heroSecretltCtrl.getExtraConfig()
	if not heroSecretltCtrl.extraReward then
		heroSecretltCtrl = heroSecretltCtrl.extraReward
	end
	return heroSecretltCtrl.extraReward
end
function heroSecretltCtrl.getLockNum()
	return table.nums(heroSecretltCtrl.vaultLock)
end
function heroSecretltCtrl.getConfigNum()
	return table.nums(heroSecretltCtrl.vaultConfig)
end
function heroSecretltCtrl.getCost(index)
	local itemInfo = heroSecretltCtrl.vaultLock[index]
	if itemInfo then
		return itemInfo.cost
	end
	return 0
end
function heroSecretltCtrl.getCostByRound(round)
	for i, v in ipairs(heroSecretltCtrl.vaultLock) do
		if v.round == round then
			return v.cost
		end
	end
end
function heroSecretltCtrl.getAwardByIndex(group, index)
	for i, v in ipairs(heroSecretltCtrl.vaultConfig) do
		if v.position == indexToPosition[index] and v.group == group then
			return v.rewards
		end
	end
	_ENV = (for generator)
	return ipairs(heroSecretltCtrl.vaultConfig)
end
function heroSecretltCtrl.getIsRare(group, index)
	for i, v in ipairs(heroSecretltCtrl.vaultConfig) do
		if v.position == indexToPosition[index] and v.group == group then
			return v.rare
		end
	end
end
function heroSecretltCtrl.getAward(group)
	local _ENV, backTbl
	for _, v in ipairs(heroSecretltCtrl.vaultConfig) do
		if v.group == group then
			_ENV = v.group
			v.group.itemid = v.rewards[1]
			local v.group.count, single = v.rewards[2], v.group
			backTbl[v.position] = single
		end
	end
	return backTbl
end
function heroSecretltCtrl.getAwardByValue(group)
	local heroSecretltCtrl, backTbl
	local tmpTbl = heroSecretltCtrl.vaultConfig
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
			heroSecretltCtrl = v.group
			v.group.itemid = v.rewards[1]
			v.group.count = v.rewards[2]
			local v.group.position, single = v.position, v.group
			backTbl[j] = single
			j = j + 1
		end
	end
	return backTbl
end
function heroSecretltCtrl.getPositionByIndex(index)
	return indexToPosition[index] or 1
end
return heroSecretltCtrl
