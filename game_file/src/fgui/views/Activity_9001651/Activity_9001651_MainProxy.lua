local baseProxy = require("fgui.base.baseProxy")
local Activity_9001651_MainProxy = class("Activity_9001651_MainProxy", baseProxy)
function Activity_9001651_MainProxy:onRegisterEvent()
	print("=======Activity_9001651_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001651_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function Activity_9001651_MainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001651_MainProxy
