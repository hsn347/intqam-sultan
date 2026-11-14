local baseProxy = require("fgui.base.baseProxy")
local summerPrayersShopProxy = class("summerPrayersShopProxy", baseProxy)
function summerPrayersShopProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_EXCHANGE_REFRESH", handler(self, self.updateScroll))
end
function summerPrayersShopProxy:updateScroll()
	self.view:updateScroll()
end
return summerPrayersShopProxy
