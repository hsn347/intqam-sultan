local anniversaryTreasureHuntRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_hunt_data"
	;(nil)[2] = true
	anniversaryTreasureHuntRead:defineValue("thd", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_treasure_hunt"
	;(nil)[2] = true
	anniversaryTreasureHuntRead:defineValue("rth", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_hunt_achievement"
	;(nil)[2] = true
	anniversaryTreasureHuntRead:defineValue("thga", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_hunt_map"
	;(nil)[2] = true
	anniversaryTreasureHuntRead:defineValue("thm", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_hunt_gift_merchant"
	;(nil)[2] = true
	anniversaryTreasureHuntRead:defineValue("thgm", nil)
end
function anniversaryTreasureHuntRead:getBuyThrowDiceNumLimit()
	init()
	return tonumber(anniversaryTreasureHuntRead.thd[1].limit) or 0
end
function anniversaryTreasureHuntRead:getBuySingleDiceCountCost()
	init()
	return tonumber(anniversaryTreasureHuntRead.thd[1].price) or 1
end
function anniversaryTreasureHuntRead:getTreasureHuntPackageInfo(packageID)
	init()
	if anniversaryTreasureHuntRead.rth[packageID] then
		return anniversaryTreasureHuntRead.rth[packageID]
	end
end
function anniversaryTreasureHuntRead:getTreasureHuntPackageInfoByPrice(price)
	init()
	local init, packageList = init, init
	for k, v in pairs(anniversaryTreasureHuntRead.rth) do
		if v.price == price then
			table.insert(packageList, v)
		end
	end
	return packageList
end
function anniversaryTreasureHuntRead:getTreasureHuntAchievementInfo()
	init()
	if not anniversaryTreasureHuntRead.thga then
		init = anniversaryTreasureHuntRead.thga
	end
	return anniversaryTreasureHuntRead.thga
end
function anniversaryTreasureHuntRead:getTreasureHuntMapInfo()
	init()
	if not anniversaryTreasureHuntRead.thm then
		init = anniversaryTreasureHuntRead.thm
	end
	return anniversaryTreasureHuntRead.thm
end
function anniversaryTreasureHuntRead:getMapRealType(index)
	init()
	if anniversaryTreasureHuntRead.thm[index] then
		return anniversaryTreasureHuntRead.thm[index].type
	end
end
function anniversaryTreasureHuntRead:getMerchantPackageInfoByID(packageID)
	init()
	local init, packageInfo = init, init
	print("sldkfjlskdjflskdjf", packageID)
	dump(anniversaryTreasureHuntRead.thgm, "sldkjfsldfklds")
	for i, v in ipairs(anniversaryTreasureHuntRead.thgm) do
		if packageID == v.packageId then
			packageInfo = v
		end
	end
	return packageInfo
end
return anniversaryTreasureHuntRead
