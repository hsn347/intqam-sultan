local baseProxy = require("fgui.base.baseProxy")
local SnowWolfLostInvestigationProxy = class("SnowWolfLostInvestigationProxy", baseProxy)
function SnowWolfLostInvestigationProxy:onRegisterEvent()
	print("=======SnowWolfLostInvestigationProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SnowWolfLostInvestigationProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return SnowWolfLostInvestigationProxy
