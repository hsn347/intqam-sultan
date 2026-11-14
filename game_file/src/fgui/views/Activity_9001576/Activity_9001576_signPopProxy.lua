local baseProxy = require("fgui.base.baseProxy")
local Activity_9001576_signPopProxy = class("Activity_9001576_signPopProxy", baseProxy)
function Activity_9001576_signPopProxy:onRegisterEvent()
	print("=======Activity_9001576_signPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SIGNREWARD_9001576_UPDATE", handler(self, self.initData))
end
function Activity_9001576_signPopProxy:initData()
	self.view:initData()
end
return Activity_9001576_signPopProxy
