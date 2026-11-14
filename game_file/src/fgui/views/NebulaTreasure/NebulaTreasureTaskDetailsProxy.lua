local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasureTaskDetailsProxy = class("NebulaTreasureTaskDetailsProxy", baseProxy)
function NebulaTreasureTaskDetailsProxy:onRegisterEvent()
	print("=======NebulaTreasureTaskDetailsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_NEBULA_TREASURE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaTreasureTaskDetailsProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function NebulaTreasureTaskDetailsProxy:updateView(target, data)
	print("=======NebulaTreasureTaskDetailsProxy:updateView")
	self.view:updateView()
end
return NebulaTreasureTaskDetailsProxy
