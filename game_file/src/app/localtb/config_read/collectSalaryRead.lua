local collectSalaryRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "collectsalary_rewards"
	;(nil)[2] = true
	collectSalaryRead:defineValue("rankAward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_map_compose"
	;(nil)[2] = true
	collectSalaryRead:defineValue("treasureMapCompose", nil)
end
init()
function collectSalaryRead.getRankAward(rankType)
	local _ENV, tmp
	for i, v in ipairs(collectSalaryRead.rankAward) do
		if v.type == rankType then
			table.insert(tmp, v)
		end
	end
	return tmp
end
function collectSalaryRead.getFirstRankAward(rankType)
	for i, v in ipairs(collectSalaryRead.rankAward) do
		if v.type == rankType and v.rank[1] == 1 then
			return v.rewards
		end
	end
	_ENV = (for generator)
	return ipairs(collectSalaryRead.rankAward)
end
function collectSalaryRead.getTreasureMapInfo(...)
	local nums = table.nums(collectSalaryRead.treasureMapCompose)
	return nums, collectSalaryRead.treasureMapCompose
end
function collectSalaryRead.getTreasureMapIndexById(id)
	for i, v in ipairs(collectSalaryRead.treasureMapCompose) do
		for _, value in ipairs(v.fragment) do
			if id == value then
				return v.id
			end
		end
	end
end
function collectSalaryRead.getFragmentNumsByID(id)
	for i, v in ipairs(collectSalaryRead.treasureMapCompose) do
		if id == v.treasureMapID then
			return table.nums(v.fragment)
		end
	end
end
function collectSalaryRead.getPropertyByID(id, property)
	for i, v in ipairs(collectSalaryRead.treasureMapCompose) do
		if id == v.treasureMapID then
			return v[property]
		end
	end
end
return collectSalaryRead
