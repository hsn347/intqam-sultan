local baseProxy = require("fgui.base.baseProxy")
local Activity_9001695_MainProxy = class("Activity_9001695_MainProxy", baseProxy)
function Activity_9001695_MainProxy:onRegisterEvent()
	print("=======Activity_9001695_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_TASKRUSH_UPDATE", handler(self, self.updateView))
end
function Activity_9001695_MainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001695_MainProxy
