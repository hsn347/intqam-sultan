local baseProxy = require("fgui.base.baseProxy")
local Activity_9001714_HelpProxy = class("Activity_9001714_HelpProxy", baseProxy)
function Activity_9001714_HelpProxy:onRegisterEvent()
	print("=======Activity_9001714_HelpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001678_UPDATE", handler(self, self.updateView))
end
function Activity_9001714_HelpProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001714_HelpProxy
