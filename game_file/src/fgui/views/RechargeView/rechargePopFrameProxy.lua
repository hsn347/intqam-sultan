local baseProxy = require("fgui.base.baseProxy")
local rechargePopFrameProxy = class("rechargePopFrameProxy", baseProxy)
function rechargePopFrameProxy:onRegisterEvent()
	print("=======rechargePopFrameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.reInitData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWFRAMECLOSE", handler(self, self.reInitData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.reInitData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH", handler(self, self.reInitData))
	SoraDAddMessage(self, "MESSAGE_MAIN_BREAKICE_UPDATE", handler(self, self.reInitData))
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_BUY_PACKAGE", handler(self, self.doubleClose))
	SoraDAddMessage(self, "MESSAGE_REQ_NEW_PRINCE_GIFT_BUY_PACKAGE", handler(self, self.doubleClose))
end
function rechargePopFrameProxy:reInitDataEx(target, data)
	self.view:reInitDataEx(target, data)
end
function rechargePopFrameProxy:reInitData(target, data)
	self.view:reInitData(target, data)
end
function rechargePopFrameProxy:doubleClose(target, data)
	self.view:doubleClose(target, data)
end
return rechargePopFrameProxy
