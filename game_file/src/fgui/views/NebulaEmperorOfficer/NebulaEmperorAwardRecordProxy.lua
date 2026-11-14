local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorAwardRecordProxy = class("NebulaEmperorAwardRecordProxy", baseProxy)
function NebulaEmperorAwardRecordProxy:onRegisterEvent()
	print("=======NebulaEmperorAwardRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_GIFT_RECORD", handler(self, self.onMsgReqGiftRecordRsp))
end
function NebulaEmperorAwardRecordProxy:onMsgReqGiftRecordRsp(...)
	self.view:onMsgReqGiftRecordRsp(...)
end
return NebulaEmperorAwardRecordProxy
