local baseProxy = require("fgui.base.baseProxy")
local SnowmanGiftBoxRewardProxy = class("SnowmanGiftBoxRewardProxy", baseProxy)
function SnowmanGiftBoxRewardProxy:onRegisterEvent()
	print("=======SnowmanGiftBoxRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SnowmanGiftBoxRewardProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SNOW_MAN_GIFT_ACTIVITY) then
		self.view:close()
	end
end
return SnowmanGiftBoxRewardProxy
