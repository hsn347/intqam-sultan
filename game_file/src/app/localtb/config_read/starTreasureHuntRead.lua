local starTreasureHuntRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "ramadanstar_treasure_config"
	;(nil)[2] = true
	starTreasureHuntRead:defineValue("vaultConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ramadanstar_treasure_lock"
	;(nil)[2] = true
	starTreasureHuntRead:defineValue("vaultLock", nil)
end
function starTreasureHuntRead.getCostByRound(round)
	local maxRound = #starTreasureHuntRead.vaultLock
	for i, v in ipairs(starTreasureHuntRead.vaultLock) do
		if v.round == math.min(round, maxRound) then
			return v.cost
		end
	end
end
function starTreasureHuntRead.getAwardByValue(group)
	local starTreasureHuntRead, backTbl
	local tmpTbl = starTreasureHuntRead.vaultConfig
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
		starTreasureHuntRead = nil
		;(nil).itemid = v.rewards[1]
		;(nil).count = v.rewards[2]
		local (nil).position, single = v.position, nil
		backTbl[j] = single
		j = j + 1
	end
	return backTbl
end
function starTreasureHuntRead.getConfigNum()
	return table.nums(starTreasureHuntRead.vaultConfig)
end
function starTreasureHuntRead.getPosByReward(reward)
	for i, v in ipairs(starTreasureHuntRead.vaultConfig) do
		if v.rewards[1] == reward.id and v.rewards[2] == reward.count then
			return v.position
		end
	end
end
function starTreasureHuntRead.isRare(position)
	for i, v in ipairs(starTreasureHuntRead.vaultConfig) do
		if v.position == position and v.rare == 1 then
			return true
		end
	end
end
init()
return starTreasureHuntRead
