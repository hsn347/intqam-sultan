local baseProxy = require("fgui.base.baseProxy")
local luckyFalconBuyPackageProxy = class("luckyFalconBuyPackageProxy", baseProxy)
function luckyFalconBuyPackageProxy:onRegisterEvent()
	print("=======luckyFalconBuyPackageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.updateScroll))
end
function luckyFalconBuyPackageProxy:updateScroll()
	self.view:updateScroll()
end
return luckyFalconBuyPackageProxy
