local baseProxy = require("fgui.base.baseProxy")
local Activity_9001573_BuildsProxy = class("Activity_9001573_BuildsProxy", baseProxy)
function Activity_9001573_BuildsProxy:onRegisterEvent()
	print("=======Activity_9001573_BuildsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_UPDATE", handler(self, self.updateView))
end
function Activity_9001573_BuildsProxy:updateView(...)
	self.view:initData()
end
return Activity_9001573_BuildsProxy
