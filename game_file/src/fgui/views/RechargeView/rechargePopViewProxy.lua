local baseProxy = require("fgui.base.baseProxy")
local rechargePopViewProxy = class("rechargePopViewProxy", baseProxy)
function rechargePopViewProxy:onRegisterEvent()
	print("=======rechargePopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE", handler(self, self.doubleClose))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_BUY_PACKAGE", handler(self, self.forceClose))
end
function rechargePopViewProxy:doubleClose()
	self.view:doubleClose()
end
function rechargePopViewProxy:initView()
	self.view:initView()
end
function rechargePopViewProxy:forceClose()
	self.view:forceClose()
end
return rechargePopViewProxy
