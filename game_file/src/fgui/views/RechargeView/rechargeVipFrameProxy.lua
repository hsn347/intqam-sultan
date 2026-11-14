local baseProxy = require("fgui.base.baseProxy")
local rechargeVipFrameProxy = class("rechargeVipFrameProxy", baseProxy)
function rechargeVipFrameProxy:onRegisterEvent()
	print("=======rechargeVipFrameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH", handler(self, self.msgBackData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_BUYONE", handler(self, self.msgBackData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_SHOWPWD", handler(self, self.pwdBack))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.updateView))
end
function rechargeVipFrameProxy:msgBackData(target, data)
	self.view:msgBackData(target, data)
end
function rechargeVipFrameProxy:pwdBack(target, data)
	self.view:pwdBack(target, data)
end
function rechargeVipFrameProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return rechargeVipFrameProxy
