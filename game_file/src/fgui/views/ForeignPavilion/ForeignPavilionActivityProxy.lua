local baseProxy = require("fgui.base.baseProxy")
local ForeignPavilionActivityProxy = class("ForeignPavilionActivityProxy", baseProxy)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function ForeignPavilionActivityProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_DATA", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_FINISH_STEP", handler(self, self.onFinishStep))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.playGameToIncrIntimacy))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_PLAY_GAME_TO_INCR_INTIMACY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_CHAT_TO_INCR_INTIMACY", handler(self, self.onChatAddIntimacy))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_SEND_GIFT_TO_INCR_INTIMACY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_UPGRADE_INTIMACY_LV", handler(self, self.onIntimacyLvUp))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_CHANGE_DRESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GET_DAILY_REWARD", handler(self, self.updateView))
end
function ForeignPavilionActivityProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function ForeignPavilionActivityProxy:onFinishStep()
	self.view:setStageAndStep()
end
function ForeignPavilionActivityProxy:updateView()
	self.view:updateView()
end
function ForeignPavilionActivityProxy:playGameToIncrIntimacy(target, data)
	if data.isInStory and data.isWin then
		SoraDShowLoading()
		exoticPavilionCtrl:reqEPFinshStep()
	elseif not data.isInStory then
		exoticPavilionCtrl:reqEPPlayGameToIncrIntimacy(data.gameType, data.isWin)
	end
end
function ForeignPavilionActivityProxy:onIntimacyLvUp()
	_ENV = nil
	;(nil).showType = 1
	uiManager:show("Foreignsublimation", nil)
	self:updateView()
end
function ForeignPavilionActivityProxy:onChatAddIntimacy()
	self.view.fields.mainView:onChatAddIntimacy()
end
return ForeignPavilionActivityProxy
