local baseProxy = require("fgui.base.baseProxy")
local ForeignPGiftProxy = class("ForeignPGiftProxy", baseProxy)
function ForeignPGiftProxy:onRegisterEvent()
	print("=======ForeignPGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_DATA", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_CHAT_TO_INCR_INTIMACY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_SEND_GIFT_TO_INCR_INTIMACY", handler(self, self.onGetGift))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_UPGRADE_INTIMACY_LV", handler(self, self.updateView))
end
function ForeignPGiftProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		self.view:close()
	end
end
function ForeignPGiftProxy:updateView()
	self.view:updateView()
end
function ForeignPGiftProxy:onGetGift()
	self.view:onGetGift()
end
return ForeignPGiftProxy
