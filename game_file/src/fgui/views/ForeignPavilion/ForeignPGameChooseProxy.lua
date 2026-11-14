local baseProxy = require("fgui.base.baseProxy")
local ForeignPGameChooseProxy = class("ForeignPGameChooseProxy", baseProxy)
function ForeignPGameChooseProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_DATA", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_PLAY_GAME_TO_INCR_INTIMACY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onGameResultClose))
end
function ForeignPGameChooseProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function ForeignPGameChooseProxy:updateView()
	self.view:updateView()
end
function ForeignPGameChooseProxy:onGameResultClose(target, data)
	if data.isWin then
		self.view:showWin()
	else
		self.view:showLose()
	end
end
return ForeignPGameChooseProxy
