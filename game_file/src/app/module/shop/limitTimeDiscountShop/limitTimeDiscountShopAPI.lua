local _ENV, limitTimeDiscountShopAPI
function limitTimeDiscountShopAPI:getActivityInfo()
	local activityShowCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("activityShowCtrl")
	local activityID = gActivityTimeActivityID.LIMITED_DISCOUNT_ACTIVITY
	local beginTime = activityShowCtrl:getBeginTimeSecond(activityID)
	local endTime = activityShowCtrl:getEndTimeSecond(activityID)
	local remainTime = 0
	local status = false
	if activityShowCtrl:isActivityOpen(activityID) then
		status = true
		remainTime = endTime - serviceFunctions.systemTime()
	else
		status = false
		if beginTime and endTime and 0 ~= beginTime and 0 ~= endTime and beginTime > serviceFunctions.systemTime() then
			remainTime = beginTime - serviceFunctions.systemTime()
		end
	end
	return status, remainTime
end
function limitTimeDiscountShopAPI:getShopItemList()
	return self:getLimitTimeDSCtrl():getShopItemList()
end
function limitTimeDiscountShopAPI:buy(shopItemID, count)
	self:getLimitTimeDSCtrl():buy(shopItemID, count)
end
function limitTimeDiscountShopAPI:getShopCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("shopCtrl")
end
function limitTimeDiscountShopAPI:getLimitTimeDSCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	local shopCtrl = gametop.playertop_:getModule("shopCtrl")
	return shopCtrl:getLimitTimeDSCtrl()
end
return limitTimeDiscountShopAPI
