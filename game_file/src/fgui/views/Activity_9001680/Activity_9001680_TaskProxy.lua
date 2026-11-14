local baseProxy = require("fgui.base.baseProxy")
local Activity_9001680_TaskProxy = class("Activity_9001680_TaskProxy", baseProxy)
function Activity_9001680_TaskProxy:onRegisterEvent()
	print("=======Activity_9001680_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001680_UPDATE", handler(self, self.onMsg_ACTIVITY_9001680_UPDATE))
end
function Activity_9001680_TaskProxy:onMsg_ACTIVITY_9001680_UPDATE(target, data)
	self.view:initData()
end
return Activity_9001680_TaskProxy
