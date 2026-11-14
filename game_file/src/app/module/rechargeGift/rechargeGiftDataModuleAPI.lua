local _ENV, rechargeGiftDataModuleAPI
function rechargeGiftDataModuleAPI:buyRechargeGift(rid)
	self:getModuleCtrl():buyRechargeGift(rid)
end
function rechargeGiftDataModuleAPI:getGiftListOf7d()
	return self:getModuleCtrl():getGiftList(gRechargeGiftType.SEVEN_DAY_GIFT)
end
function rechargeGiftDataModuleAPI:get7DGiftAlreadyBuy(rid)
	return self:getModuleCtrl():get7DGiftAlreadyBuy(rid)
end
function rechargeGiftDataModuleAPI:get7DGiftCanBuy(rid)
	return self:getModuleCtrl():get7DGiftCanBuy(rid)
end
function rechargeGiftDataModuleAPI:get7DFinishTime()
	return self:getModuleCtrl():get7DFinishTime()
end
function rechargeGiftDataModuleAPI:get7DLeftTime()
	local finishTime = self:get7DFinishTime()
	if finishTime and 0 < finishTime then
		local leftTime = finishTime - serviceFunctions.systemTime()
		if 0 <= leftTime then
			return leftTime
		end
	end
	return 0
end
function rechargeGiftDataModuleAPI:isSevenDaysOpen()
	local leftTime = self:get7DLeftTime()
	return 0 < leftTime
end
function rechargeGiftDataModuleAPI:getRechargeInfo(rid)
	local rechargeGiftltCtrl = include("rechargeGiftltCtrl")
	if not rechargeGiftltCtrl:rechargeIDValid(rid) then
		return
	end
	_ENV = rechargeGiftltCtrl:rechargeIDValid(rid)
	rechargeGiftltCtrl:rechargeIDValid(rid).rid = rid
	rechargeGiftltCtrl:rechargeIDValid(rid).gift = rechargeGiftltCtrl:getResult(rid)
	rechargeGiftltCtrl:rechargeIDValid(rid).price = rechargeGiftltCtrl:getPrice(rid)
	rechargeGiftltCtrl:rechargeIDValid(rid).originalPrice = rechargeGiftltCtrl:getOriginalPrice(rid)
	rechargeGiftltCtrl:rechargeIDValid(rid).gold = rechargeGiftltCtrl:getGold(rid)
	rechargeGiftltCtrl:rechargeIDValid(rid).discount = rechargeGiftltCtrl:getDiscount(rid)
	local rechargeGiftltCtrl:rechargeIDValid(rid).refund, ret = rechargeGiftltCtrl:getRefund(rid), rechargeGiftltCtrl:rechargeIDValid(rid)
	return ret
end
function rechargeGiftDataModuleAPI:checkRedPoint()
	_ENV = nil
	;(nil).byUID = true
	local configTime = SoraDConfigGet("Game:eventSevenDays:saveTime~integer", nil)
	local nowTime = serviceFunctions.systemTime()
	if os.date("%d", nowTime) ~= os.date("%d", configTime) then
		local data = self:getGiftListOf7d()
		for k, v in pairs(data) do
			if v.canBuy and not v.alreadyBuy then
				return true
			end
		end
	end
end
function rechargeGiftDataModuleAPI:updateSaveTime()
	_ENV = nil
	;(nil).byUID = true
	local configTime = SoraDConfigGet("Game:eventSevenDays:saveTime~integer", nil)
	local nowTime = serviceFunctions.systemTime()
	if os.date("%d", nowTime) ~= os.date("%d", configTime) then
		local refresh = self:checkRedPoint()
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:eventSevenDays:saveTime~integer", nowTime, nil)
		if refresh then
			_ENV = "Game:eventSevenDays:saveTime~integer"
			;("Game:eventSevenDays:saveTime~integer").msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			SoraDSendMessage("Game:eventSevenDays:saveTime~integer")
		end
	end
end
function rechargeGiftDataModuleAPI:getModuleCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("rechargeGiftCtrl")
end
return rechargeGiftDataModuleAPI
