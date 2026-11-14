local baseProxy = require("fgui.base.baseProxy")
local LegendOfPegasusMainProxy = class("LegendOfPegasusMainProxy", baseProxy)
function LegendOfPegasusMainProxy:onRegisterEvent()
	print("=======LegendOfPegasusMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LEGEND_OF_PEGASUS_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function LegendOfPegasusMainProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function LegendOfPegasusMainProxy:onUpdateView()
	self.view:updateView()
end
return LegendOfPegasusMainProxy
