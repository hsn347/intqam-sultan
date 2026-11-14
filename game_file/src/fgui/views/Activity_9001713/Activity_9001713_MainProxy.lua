local baseProxy = require("fgui.base.baseProxy")
local Activity_9001713_MainProxy = class("Activity_9001713_MainProxy", baseProxy)
function Activity_9001713_MainProxy:onRegisterEvent()
	print("=======Activity_9001713_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001713_UPDATE", handler(self, self.initView))
end
function Activity_9001713_MainProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001713_MainProxy
