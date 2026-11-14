local crazyShoppingRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "crazyshopping_config.lua"
	;(nil)[2] = true
	crazyShoppingRead:defineValue("shoppingConfig", nil)
end
function crazyShoppingRead.getInvestGold(day)
	init()
	return crazyShoppingRead.shoppingConfig[day] and crazyShoppingRead.shoppingConfig[day].priceAfter or 0
end
function crazyShoppingRead.showDiscount(day)
	init()
	if crazyShoppingRead.shoppingConfig[day] and crazyShoppingRead.shoppingConfig[day].showOff == 1 then
		return true
	else
		return false
	end
end
function crazyShoppingRead.getDiscount(day)
	init()
	local priceBefore = crazyShoppingRead.shoppingConfig[day] and crazyShoppingRead.shoppingConfig[day].priceBefore
	local priceAfter = crazyShoppingRead.shoppingConfig[day] and crazyShoppingRead.shoppingConfig[day].priceAfter
	if not priceAfter or priceAfter == 0 then
		return 99999
	end
	if not priceBefore or priceBefore == 0 then
		return 0
	end
	return priceBefore / priceAfter * 100
end
function crazyShoppingRead.getInvestRewards(day)
	init()
	if not crazyShoppingRead.shoppingConfig[day] or not crazyShoppingRead.shoppingConfig[day].rewards then
		init = crazyShoppingRead.shoppingConfig[day].rewards
	end
	return crazyShoppingRead.shoppingConfig[day].rewards
end
return crazyShoppingRead
