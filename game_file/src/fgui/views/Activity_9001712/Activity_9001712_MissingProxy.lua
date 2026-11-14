local baseProxy = require("fgui.base.baseProxy")
local Activity_9001712_MissingProxy = class("Activity_9001712_MissingProxy", baseProxy)
function Activity_9001712_MissingProxy:onRegisterEvent()
	print("=======Activity_9001712_MissingProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001712_BUYTIME", handler(self, self.onBuyTime))
end
function Activity_9001712_MissingProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001712_MissingProxy:onBuyTime(target, event)
	self.view:close()
end
return Activity_9001712_MissingProxy
