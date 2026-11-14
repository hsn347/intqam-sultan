local baseProxy = require("fgui.base.baseProxy")
local rechargeVipSpecialViewProxy = class("rechargeVipSpecialViewProxy", baseProxy)
function rechargeVipSpecialViewProxy:onRegisterEvent()
	print("=======rechargeVipSpecialViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_BUYONE", handler(self, self.msgBackData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH", handler(self, self.msgBackData))
end
function rechargeVipSpecialViewProxy:msgBackData(target, data)
	self.view:msgBackData(target, data)
end
return rechargeVipSpecialViewProxy
