local baseProxy = require("fgui.base.baseProxy")
local Activity_9001657_ApplyProxy = class("Activity_9001657_ApplyProxy", baseProxy)
function Activity_9001657_ApplyProxy:onRegisterEvent()
	print("=======Activity_9001657_ApplyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001657_APPLY_LIST", handler(self, self.onMsgUpdateApplyList))
end
function Activity_9001657_ApplyProxy:onMsgUpdateApplyList(...)
	self.view:onMsgUpdateApplyList(...)
end
return Activity_9001657_ApplyProxy
