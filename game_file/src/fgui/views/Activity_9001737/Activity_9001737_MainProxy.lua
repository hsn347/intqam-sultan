local baseProxy = require("fgui.base.baseProxy")
local Activity_9001737_MainProxy = class("Activity_9001737_MainProxy", baseProxy)
function Activity_9001737_MainProxy:onRegisterEvent()
	print("=======Activity_9001737_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001737_ASSIGN", handler(self, self.initAssign))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001737_UPDATE", handler(self, self.initView))
end
function Activity_9001737_MainProxy:initAssign(target, data)
	self.view:initAssign(target, data)
end
function Activity_9001737_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001737_MainProxy
