local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorAwardProxy = class("NebulaEmperorAwardProxy", baseProxy)
function NebulaEmperorAwardProxy:onRegisterEvent()
	print("=======NebulaEmperorAwardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_GIFT_INFO", handler(self, self.onMsgReqGiftInfoRsp))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_AWARD_GIFT", handler(self, self.onMsgReqAwardGiftRsp))
end
function NebulaEmperorAwardProxy:onMsgReqGiftInfoRsp(...)
	self.view:onMsgReqGiftInfoRsp(...)
end
function NebulaEmperorAwardProxy:onMsgReqAwardGiftRsp(...)
	self.view:onMsgReqAwardGiftRsp(...)
end
return NebulaEmperorAwardProxy
