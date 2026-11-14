local baseProxy = require("fgui.base.baseProxy")
local LegendOfPegasusInvestigationProxy = class("LegendOfPegasusInvestigationProxy", baseProxy)
function LegendOfPegasusInvestigationProxy:onRegisterEvent()
	print("=======LegendOfPegasusInvestigationProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function LegendOfPegasusInvestigationProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return LegendOfPegasusInvestigationProxy
