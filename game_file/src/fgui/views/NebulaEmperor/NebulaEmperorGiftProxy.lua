local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorGiftProxy = class("NebulaEmperorGiftProxy", baseProxy)
function NebulaEmperorGiftProxy:onRegisterEvent()
	print("=======NebulaEmperorGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.onMsgRechargeUpdate))
end
function NebulaEmperorGiftProxy:onMsgRechargeUpdate(...)
	self.view:onMsgRechargeUpdate(...)
end
return NebulaEmperorGiftProxy
