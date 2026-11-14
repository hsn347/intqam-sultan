local baseProxy = require("fgui.base.baseProxy")
local Activity_9001642_MainProxy = class("Activity_9001642_MainProxy", baseProxy)
function Activity_9001642_MainProxy:onRegisterEvent()
	print("=======Activity_9001642_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001642_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", handler(self, self.beKicked))
end
function Activity_9001642_MainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function Activity_9001642_MainProxy:beKicked(target, data)
	SoraDRemoveAllAfterPanelFromManager(self.view)
end
return Activity_9001642_MainProxy
