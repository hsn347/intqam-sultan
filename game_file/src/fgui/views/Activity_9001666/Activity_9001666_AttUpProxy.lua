local baseProxy = require("fgui.base.baseProxy")
local Activity_9001666_AttUpProxy = class("Activity_9001666_AttUpProxy", baseProxy)
function Activity_9001666_AttUpProxy:onRegisterEvent()
	print("=======Activity_9001666_AttUpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001666_UPDATE", handler(self, self.updateView))
end
function Activity_9001666_AttUpProxy:updateView(target, data)
	self.view:updateView(data.msgType)
end
return Activity_9001666_AttUpProxy
