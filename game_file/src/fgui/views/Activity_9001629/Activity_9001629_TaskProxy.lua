local baseProxy = require("fgui.base.baseProxy")
local Activity_9001629_TaskProxy = class("Activity_9001629_TaskProxy", baseProxy)
function Activity_9001629_TaskProxy:onRegisterEvent()
	print("=======Activity_9001629_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001629_TASK", handler(self, self.onUpdateView))
end
function Activity_9001629_TaskProxy:onUpdateView()
	self.view:updateView()
end
return Activity_9001629_TaskProxy
