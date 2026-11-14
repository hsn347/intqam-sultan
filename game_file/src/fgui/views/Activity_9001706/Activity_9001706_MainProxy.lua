local baseProxy = require("fgui.base.baseProxy")
local Activity_9001706_MainProxy = class("Activity_9001706_MainProxy", baseProxy)
function Activity_9001706_MainProxy:onRegisterEvent()
	print("=======Activity_9001706_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001706_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.initView))
end
function Activity_9001706_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001706_MainProxy
