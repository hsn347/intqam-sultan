local baseProxy = require("fgui.base.baseProxy")
local BagItemRecoveryProxy = class("BagItemRecoveryProxy", baseProxy)
function BagItemRecoveryProxy:onRegisterEvent()
	print("=======BagItemRecoveryProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, data)
		self.view:stopActionByTag(996)
		local action = ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(function()
			self.view:updateView()
		end))
		action:setTag(996)
		self.view:runAction(action)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		if data.name == "remind" then
			self.view:updateRedDot()
		else
			self:updateView()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH", handler(self, self.updateView))
end
function BagItemRecoveryProxy:updateView()
	self.view:updateView()
end
return BagItemRecoveryProxy
