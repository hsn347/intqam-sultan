local baseProxy = require("fgui.base.baseProxy")
local Activity_9001734_AchiProxy = class("Activity_9001734_AchiProxy", baseProxy)
function Activity_9001734_AchiProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001734_ACHI", handler(self, self.onMsgUpdateData))
end
function Activity_9001734_AchiProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001734_AchiProxy
