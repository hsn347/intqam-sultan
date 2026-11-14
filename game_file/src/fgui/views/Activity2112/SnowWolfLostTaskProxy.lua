local baseProxy = require("fgui.base.baseProxy")
local SnowWolfLostTaskProxy = class("SnowWolfLostTaskProxy", baseProxy)
function SnowWolfLostTaskProxy:onRegisterEvent()
	print("=======SnowWolfLostTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SNOWWOLF_LOST_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SnowWolfLostTaskProxy:onUpdateView()
	self.view:updateView()
end
function SnowWolfLostTaskProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
return SnowWolfLostTaskProxy
