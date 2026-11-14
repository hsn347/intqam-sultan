local baseProxy = require("fgui.base.baseProxy")
local Activity_9001651_TaskProxy = class("Activity_9001651_TaskProxy", baseProxy)
function Activity_9001651_TaskProxy:onRegisterEvent()
	print("=======Activity_9001651_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001651_UPDATE", handler(self, self.updateView))
end
function Activity_9001651_TaskProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001651_TaskProxy
