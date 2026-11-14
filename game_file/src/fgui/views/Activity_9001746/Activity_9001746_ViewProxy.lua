local baseProxy = require("fgui.base.baseProxy")
local Activity_9001746_ViewProxy = class("Activity_9001746_ViewProxy", baseProxy)
function Activity_9001746_ViewProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001746_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.onRedDotRefresh))
	self:registerActivityCloseEvent(gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY)
end
function Activity_9001746_ViewProxy:onUpdateView(target, data)
	if self.view then
		self.view:updateView(data)
	end
end
function Activity_9001746_ViewProxy:onRedDotRefresh(target, data)
	if self.view and data and data.eventID == self.view.activityID then
		self.view:updatRed()
	end
	return data
end
return Activity_9001746_ViewProxy
