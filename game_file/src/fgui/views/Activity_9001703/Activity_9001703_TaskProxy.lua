local baseProxy = require("fgui.base.baseProxy")
local Activity_9001703_TaskProxy = class("Activity_9001703_TaskProxy", baseProxy)
function Activity_9001703_TaskProxy:onRegisterEvent()
	print("=======Activity_9001703_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_UPDATE", handler(self, self.initView))
end
function Activity_9001703_TaskProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001703_TaskProxy
