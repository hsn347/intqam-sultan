local baseProxy = require("fgui.base.baseProxy")
local CommonSpeedUpBoxProxy = class("CommonSpeedUpBoxProxy", baseProxy)
function CommonSpeedUpBoxProxy:onRegisterEvent()
	print("=======CommonSpeedUpBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_QUEUE_MERGE_NOTIFY", handler(self, self.onMsgUpdateQueue))
end
function CommonSpeedUpBoxProxy:onMsgUpdateQueue(...)
	self.view:onMsgUpdateQueue(...)
end
return CommonSpeedUpBoxProxy
