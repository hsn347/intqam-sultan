local pickupStarsAgainRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "pickup_stars_again"
	;(nil)[2] = true
	pickupStarsAgainRead:defineValue("pickup_stars_again", nil)
	_ENV = nil
	;(nil)[1] = "desert_meteorites"
	;(nil)[2] = true
	pickupStarsAgainRead:defineValue("desert_meteorites", nil)
	_ENV = nil
	;(nil)[1] = "desert_meteorites_difficulty"
	;(nil)[2] = true
	pickupStarsAgainRead:defineValue("desert_meteorites_difficulty", nil)
	local createData = function(name)
		pickupStarsAgainRead.rewards, pickupStarsAgainRead, pickupStarsAgainRead.maxScores, pickupStarsAgainRead = nil, nil, nil, nil
		for i, v in ipairs(pickupStarsAgainRead.pickup_stars_again) do
			if pickupStarsAgainRead.rewards[v.Type] == nil then
				pickupStarsAgainRead.rewards[v.Type], pickupStarsAgainRead = nil, nil
			end
			if pickupStarsAgainRead.maxScores[v.Type] == nil or pickupStarsAgainRead.maxScores[v.Type] < v.NeedNum then
				pickupStarsAgainRead.maxScores[v.Type] = v.NeedNum
			end
			table.insert(pickupStarsAgainRead.rewards[v.Type], v)
		end
		for i, v in ipairs(pickupStarsAgainRead.rewards) do
			table.sort(v, function(l, r)
				return l.Rank < r.Rank
			end)
		end
		if name == "rewards" then
			return pickupStarsAgainRead.rewards
		elseif name == "maxScores" then
			return pickupStarsAgainRead.maxScores
		end
	end
	pickupStarsAgainRead:defineValue("rewards", createData)
	pickupStarsAgainRead:defineValue("maxScores", createData)
end
init()
function pickupStarsAgainRead:getBuildColossus()
	return pickupStarsAgainRead.pickup_stars_again
end
function pickupStarsAgainRead:getRewards(rType)
	return pickupStarsAgainRead.rewards[rType]
end
function pickupStarsAgainRead:getMaxScore(rType)
	return pickupStarsAgainRead.maxScores[rType]
end
function pickupStarsAgainRead:getCurGlobalRound(globalScore)
	local rewardCfgs = pickupStarsAgainRead:getRewards(2)
	local curIndex = 0
	for i, v in ipairs(rewardCfgs) do
		if globalScore >= v.NeedNum then
			curIndex = i
		end
	end
	local curCfg = rewardCfgs[curIndex + 1]
	return curCfg and curCfg or rewardCfgs[curIndex]
end
function pickupStarsAgainRead:getDesetMeteorites()
	return self.desert_meteorites
end
function pickupStarsAgainRead:getDesetMeteoritesLog(index)
	return self.desert_meteorites[index]
end
function pickupStarsAgainRead:getDesetMeteoritesDifficulty()
	return self.desert_meteorites_difficulty
end
return pickupStarsAgainRead
