local baseProxy = require("fgui.base.baseProxy")
local Activity_9001594_MembersProxy = class("Activity_9001594_MembersProxy", baseProxy)
function Activity_9001594_MembersProxy:onRegisterEvent()
	print("=======Activity_9001594_MembersProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001594_UPDATE", handler(self, self.onMsgUpdateData))
end
function Activity_9001594_MembersProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001594_MembersProxy
