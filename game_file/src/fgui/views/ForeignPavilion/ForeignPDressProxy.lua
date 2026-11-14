local baseProxy = require("fgui.base.baseProxy")
local ForeignPDressProxy = class("ForeignPDressProxy", baseProxy)
function ForeignPDressProxy:onRegisterEvent()
	print("=======ForeignPDressProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_DATA", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_UPGRADE_INTIMACY_LV", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_CHANGE_DRESS", handler(self, self.onDressChanged))
end
function ForeignPDressProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function ForeignPDressProxy:updateView()
	self.view:updateView()
end
function ForeignPDressProxy:onDressChanged()
	self.view:onDressChanged()
end
return ForeignPDressProxy
