local baseProxy = require("fgui.base.baseProxy")
local Activity_9001729_BuyGiftProxy = class("Activity_9001729_BuyGiftProxy", baseProxy)
function Activity_9001729_BuyGiftProxy:onRegisterEvent()
	print("=======Activity_9001729_BuyGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.onRechargeExchange))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onRecharge))
end
function Activity_9001729_BuyGiftProxy:onRechargeExchange(target, data)
	if data.rid == self.view.giftInfo.rechargeID then
		SoraDCloseLoading()
		self.view:close()
	end
end
function Activity_9001729_BuyGiftProxy:onRecharge(target, data)
	SoraDCloseLoading()
	self.view:close()
end
return Activity_9001729_BuyGiftProxy
