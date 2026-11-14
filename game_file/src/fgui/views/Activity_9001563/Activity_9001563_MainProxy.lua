local baseProxy = require("fgui.base.baseProxy")
local Activity_9001563_MainProxy = class("Activity_9001563_MainProxy", baseProxy)
function Activity_9001563_MainProxy:onRegisterEvent()
	print("=======Activity_9001563_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001563_UPDATE", handler(self, self.onMsgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001563_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001563_MainProxy:onMsgUpdateView(...)
	self.view:onMsgUpdateView(...)
end
function Activity_9001563_MainProxy:onMsgUpdateItemCount(...)
	self.view:updateItemCount()
end
return Activity_9001563_MainProxy
