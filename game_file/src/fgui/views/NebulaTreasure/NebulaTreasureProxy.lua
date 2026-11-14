local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasureProxy = class("NebulaTreasureProxy", baseProxy)
function NebulaTreasureProxy:onRegisterEvent()
	print("=======NebulaTreasureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_NEBULA_TREASURE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaTreasureProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaTreasureProxy:updateView(target, data)
	self.view:updateView()
end
return NebulaTreasureProxy
