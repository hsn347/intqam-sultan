local baseProxy = require("fgui.base.baseProxy")
local Activity_9001531_MainProxy = class("Activity_9001531_MainProxy", baseProxy)
function Activity_9001531_MainProxy:onRegisterEvent()
	print("=======Activity_9001531_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgItemCountChange))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001531_UPDATE", handler(self, self.onMsgUpdate))
end
function Activity_9001531_MainProxy:judgeClose(target, event)
	local activity_9001531_Ctrl = SoraDGetCtrl("activity_9001531_Ctrl")
	if not clientEventMgr.judgeIsOpen(activity_9001531_Ctrl:getActivityID()) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001531_MainProxy:onMsgItemCountChange(...)
	self.view:onMsgItemCountChange(...)
end
function Activity_9001531_MainProxy:onMsgUpdate(...)
	self.view:onMsgUpdate(...)
end
function Activity_9001531_MainProxy:showLoading(...)
	SoraDShowLoading(self.view:displayObject())
end
return Activity_9001531_MainProxy
