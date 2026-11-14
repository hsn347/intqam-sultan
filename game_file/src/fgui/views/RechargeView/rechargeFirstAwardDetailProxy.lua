local baseProxy = require("fgui.base.baseProxy")
local rechargeFirstAwardDetailProxy = class("rechargeFirstAwardDetailProxy", baseProxy)
function rechargeFirstAwardDetailProxy:onRegisterEvent()
	print("=======rechargeFirstAwardDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.sMsgReceiveNormal))
end
function rechargeFirstAwardDetailProxy:sMsgReceiveNormal()
	self.view:sMsgReceiveNormal()
end
return rechargeFirstAwardDetailProxy
