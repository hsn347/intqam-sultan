local annivColossusRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "buildcolossus"
	;(nil)[2] = true
	annivColossusRead:defineValue("buildcolossus", nil)
	local createData = function(name)
		annivColossusRead.rewards, annivColossusRead, annivColossusRead.maxScores, annivColossusRead = nil, nil, nil, nil
		for i, v in ipairs(annivColossusRead.buildcolossus) do
			if annivColossusRead.rewards[v.Type] == nil then
				annivColossusRead.rewards[v.Type], annivColossusRead = nil, nil
			end
			if annivColossusRead.maxScores[v.Type] == nil or annivColossusRead.maxScores[v.Type] < v.NeedNum then
				annivColossusRead.maxScores[v.Type] = v.NeedNum
			end
			table.insert(annivColossusRead.rewards[v.Type], v)
		end
		for i, v in ipairs(annivColossusRead.rewards) do
			table.sort(v, function(l, r)
				return l.Rank < r.Rank
			end)
		end
		if name == "rewards" then
			return annivColossusRead.rewards
		elseif name == "maxScores" then
			return annivColossusRead.maxScores
		end
	end
	annivColossusRead:defineValue("rewards", createData)
	annivColossusRead:defineValue("maxScores", createData)
end
init()
function annivColossusRead:getBuildColossus()
	return annivColossusRead.buildcolossus
end
function annivColossusRead:getRewards(rType)
	return annivColossusRead.rewards[rType]
end
function annivColossusRead:getMaxScore(rType)
	return annivColossusRead.maxScores[rType]
end
function annivColossusRead:getCurGlobalRound(globalScore)
	local rewardCfgs = annivColossusRead:getRewards(2)
	local curIndex = 0
	for i, v in ipairs(rewardCfgs) do
		if globalScore >= v.NeedNum then
			curIndex = i
		end
	end
	local curCfg = rewardCfgs[curIndex + 1]
	return curCfg and curCfg or rewardCfgs[curIndex]
end
return annivColossusRead
