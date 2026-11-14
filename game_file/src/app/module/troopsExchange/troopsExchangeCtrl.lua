local gamemodulec = include("GameModule")
local troopsExchangeCtrl = class("troopsExchangeCtrl", gamemodulec)
function troopsExchangeCtrl:ctor(properties)
	troopsExchangeCtrl.super.ctor(self, properties)
	self:resetData()
end
function troopsExchangeCtrl:EnterGame()
end
function troopsExchangeCtrl:Logout()
	troopsExchangeCtrl.super.Logout(self)
	self:resetData()
end
function troopsExchangeCtrl:resetData()
end
function troopsExchangeCtrl:getReddotNum(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	_ENV = "activityShowCtrl"
	;("activityShowCtrl")[gActivityTimeActivityID.BATTLEFIELD_TRAINING] = "troopsExchangeTaskCtrl"
	;("activityShowCtrl")[gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY] = "gemExchangeCtrl"
	local ("activityShowCtrl")[gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY], activityCtrl = "activityExchangeMallCtrl", "activityShowCtrl"
	if activityCtrl[activityID] then
		local tmpCtl = SoraDGetCtrl(activityCtrl[activityID])
		if activityShowCtrl:isActivityOpen(activityID) then
			return tmpCtl:getReceiveStatusAndNum(activityID)
		end
	end
	return false, 0
end
function troopsExchangeCtrl:getReceiveStatusAndNum()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local num = 0
	for activityID, _ in pairs(activityShowCtrl:getActivityGroup(gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY)) do
		local _, redNum = self:getReddotNum(activityID)
		print("troopsExchangeCtrl:getReceiveStatusAndNum", redNum, activityID)
		num = num + redNum
	end
	return 0 < num, num
end
return troopsExchangeCtrl
