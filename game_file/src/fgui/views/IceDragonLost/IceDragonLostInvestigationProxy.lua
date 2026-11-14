local baseProxy = require("fgui.base.baseProxy")
local IceDragonLostInvestigationProxy = class("IceDragonLostInvestigationProxy", baseProxy)
function IceDragonLostInvestigationProxy:onRegisterEvent()
	print("=======IceDragonLostInvestigationProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function IceDragonLostInvestigationProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.ICE_DRAGON_LOST)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return IceDragonLostInvestigationProxy
