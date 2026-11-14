local treasurePackageRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_package"
	;(nil)[2] = true
	treasurePackageRead:defineValue("tp", nil)
	treasurePackageRead = nil
	;(nil)[1] = "treasure_package_client"
	treasurePackageRead:defineValue("tpc", nil)
end
function treasurePackageRead:getPackageNameByIndex(index)
	local packageName = ""
	if treasurePackageRead.tpc[index] then
		packageName = treasurePackageRead.tpc[index].name
	end
	return packageName
end
function treasurePackageRead:getPackageOriginalPriceByIndex(index)
	local packagePrice = 0
	if treasurePackageRead.tpc[index] then
		packagePrice = treasurePackageRead.tpc[index].originalprice
	end
	return packagePrice
end
function treasurePackageRead:getPackageNum()
	local totalNum = 0
	if treasurePackageRead.tpc then
		totalNum = #treasurePackageRead.tpc
	end
	return totalNum
end
function treasurePackageRead:getPackageSoldPriceByIndex(index)
	local packagePrice = 0
	if treasurePackageRead.tp then
		packagePrice = treasurePackageRead.tp[index].price
	end
	return packagePrice
end
function treasurePackageRead:getVipPointsByIndex(index)
	local point = 0
	if treasurePackageRead.tp then
		point = treasurePackageRead.tp[index].vippoint
	end
	return point
end
function treasurePackageRead:getRewardByIndex(index)
	local treasurePackageRead, reward
	if treasurePackageRead.tp then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		reward = serviceFunctions.tableFormat(treasurePackageRead.tp[index].reward, nil)
	end
	return reward
end
init()
return treasurePackageRead
