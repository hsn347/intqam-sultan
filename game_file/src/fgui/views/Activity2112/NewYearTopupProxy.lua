local baseProxy = require("fgui.base.baseProxy")
local NewYearTopupProxy = class("NewYearTopupProxy", baseProxy)
local cumulativeRecharge2021Ctrl = SoraDGetCtrl("cumulativeRecharge2021Ctrl")
function NewYearTopupProxy:onRegisterEvent()
	print("=======NewYearTopupProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_CUMULATIVE_RECHARGE_2021_INIT", handler(self, self.updateView))
end
function NewYearTopupProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.CUMULATIVE_RECHARGE_2021)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function NewYearTopupProxy:updateView()
	self.view:updateView()
end
return NewYearTopupProxy
