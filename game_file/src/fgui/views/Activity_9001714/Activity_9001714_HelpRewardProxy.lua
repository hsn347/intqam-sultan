local baseProxy = require("fgui.base.baseProxy")
local Activity_9001714_HelpRewardProxy = class("Activity_9001714_HelpRewardProxy", baseProxy)
function Activity_9001714_HelpRewardProxy:onRegisterEvent()
	print("=======Activity_9001714_HelpRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001678_UPDATE", handler(self, self.updateView))
end
function Activity_9001714_HelpRewardProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001714_HelpRewardProxy
