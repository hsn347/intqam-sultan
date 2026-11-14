local heroFestivalRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "hero_turntable_config"
	;(nil)[2] = true
	heroFestivalRead:defineValue("heroFestivalConfig", nil)
end
init()
function heroFestivalRead:getSingleCost()
	local singleGold = 0
	if heroFestivalRead.heroFestivalConfig[1] and heroFestivalRead.heroFestivalConfig[1].Singlecos then
		singleGold = heroFestivalRead.heroFestivalConfig[1].Singlecos[2]
	end
	return singleGold
end
function heroFestivalRead:getTenCost()
	local tenGold = 0
	if heroFestivalRead.heroFestivalConfig[1] and heroFestivalRead.heroFestivalConfig[1].Tencost then
		tenGold = heroFestivalRead.heroFestivalConfig[1].Tencost[2]
	end
	return tenGold
end
function heroFestivalRead:getRewardsInfo()
	local heroFestivalRead, rewards
	if heroFestivalRead.heroFestivalConfig[1] and heroFestivalRead.heroFestivalConfig[1].reward then
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "cost"
		rewards = serviceFunctions.tableFormat(heroFestivalRead.heroFestivalConfig[1].reward, nil)
	end
	return rewards
end
return heroFestivalRead
