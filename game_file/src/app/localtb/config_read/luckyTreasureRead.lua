local luckyTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "turntable_config"
	;(nil)[2] = true
	luckyTreasureRead:defineValue("tableTurnConfig", nil)
	luckyTreasureRead = nil
	;(nil)[1] = "turntable_view_config"
	luckyTreasureRead:defineValue("tableTurnViewConfig", nil)
	luckyTreasureRead:defineValue("config", function()
		luckyTreasureRead.config, luckyTreasureRead = nil, nil
		for k, v in pairs(luckyTreasureRead.tableTurnConfig) do
			luckyTreasureRead.config[v.TurntableID] = v
		end
		return luckyTreasureRead.config
	end)
end
init()
function luckyTreasureRead.getRewardListByIndex(curIndex)
	local luckyTreasureRead, data
	if luckyTreasureRead.config[curIndex] then
		local rewardList = luckyTreasureRead.config[curIndex].reward
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		data = serviceFunctions.tableFormat(rewardList, nil)
	end
	return data
end
function luckyTreasureRead.getImportantRewardByIndex(curIndex)
	if luckyTreasureRead.config[curIndex] then
		return luckyTreasureRead.config[curIndex].Important
	end
end
function luckyTreasureRead.getRewrarCostByIndex(index)
	local data.tenCost, luckyTreasureRead, data.oneCost, luckyTreasureRead, luckyTreasureRead, data
	if luckyTreasureRead.config[index] then
		local oneCost = luckyTreasureRead.config[index].Singlecos
		data.oneCost.id = oneCost[1]
		data.oneCost.count = oneCost[2]
		local tenCost = luckyTreasureRead.config[index].Tencost
		data.tenCost.id = tenCost[1]
		data.tenCost.count = tenCost[2]
	end
	return data
end
function luckyTreasureRead.getCurrentTurnBanner(index)
	local imageName, titleStr
	for k, v in pairs(luckyTreasureRead.tableTurnViewConfig) do
		if v.TurntableID == index then
			imageName = v.TurntableBanner
			titleStr = v.TurntableDes
			break
		end
	end
	return imageName, titleStr
end
return luckyTreasureRead
