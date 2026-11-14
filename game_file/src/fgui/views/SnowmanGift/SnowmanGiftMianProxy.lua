local baseProxy = require("fgui.base.baseProxy")
local SnowmanGiftMianProxy = class("SnowmanGiftMianProxy", baseProxy)
function SnowmanGiftMianProxy:onRegisterEvent()
	print("=======SnowmanGiftMianProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SNOWMAN_GIFT_SIGN", handler(self, self.msgUpdateView))
end
function SnowmanGiftMianProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		self.view:close()
	end
end
function SnowmanGiftMianProxy:msgUpdateView(target, data)
	self.view:updateView()
	self.view:playSuccessAnimation(data.blockDay)
end
return SnowmanGiftMianProxy
