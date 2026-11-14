local baseProxy = require("fgui.base.baseProxy")
local Activity_9001712_MainProxy = class("Activity_9001712_MainProxy", baseProxy)
function Activity_9001712_MainProxy:onRegisterEvent()
	print("=======Activity_9001712_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001712_UPDATE", handler(self, self.updateActivity))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001712_REQREWARD", handler(self, self.getReward))
end
function Activity_9001712_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001712_MainProxy:updateActivity()
	self.view:initData()
end
function Activity_9001712_MainProxy:getReward()
	self.view.selectedCard = nil
end
return Activity_9001712_MainProxy
