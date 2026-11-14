local caveExploreRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "caveexplore"
	;(nil)[2] = true
	caveExploreRead:defineValue("caveexplore", nil)
	caveExploreRead:defineValue("rewardGroups", function()
		caveExploreRead.rewardGroups, caveExploreRead = nil, nil
		for i, v in ipairs(caveExploreRead.caveexplore) do
			if caveExploreRead.rewardGroups[v.Group] == nil then
				caveExploreRead.rewardGroups[v.Group], caveExploreRead = nil, nil
			end
			table.insert(caveExploreRead.rewardGroups[v.Group], v)
		end
		return caveExploreRead.rewardGroups
	end)
end
init()
function caveExploreRead:getCaveexplore()
	return caveExploreRead.caveexplore
end
function caveExploreRead:getRewards(group)
	return caveExploreRead.rewardGroups[group]
end
return caveExploreRead
