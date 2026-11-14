local baseProxy = require("fgui.base.baseProxy")
local Activity_9001573_TeamProxy = class("Activity_9001573_TeamProxy", baseProxy)
function Activity_9001573_TeamProxy:onRegisterEvent()
	print("=======Activity_9001573_TeamProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_COMMANDLIST", handler(self, self.updateData))
end
function Activity_9001573_TeamProxy:updateData(target, data)
	self.view:initData(data)
end
return Activity_9001573_TeamProxy
