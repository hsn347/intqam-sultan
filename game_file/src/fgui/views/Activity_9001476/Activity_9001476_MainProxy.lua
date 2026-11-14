local baseProxy = require("fgui.base.baseProxy")
local Activity_9001476_MainProxy = class("Activity_9001476_MainProxy", baseProxy)
function Activity_9001476_MainProxy:onRegisterEvent()
	print("=======Activity_9001476_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001476_UPDATE", handler(self, self.onMsgUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001476_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ONE_GOAL_TO_FAME_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001476_MainProxy:onMsgUpdate(target, event)
	self.view:updateInit(target, event)
end
function Activity_9001476_MainProxy:onMsgUpdateItemCount(...)
	self.view:updateItemCount()
end
function Activity_9001476_MainProxy:clickBtnDraw(count)
	self.view:onClickBtnDraw(count)
end
return Activity_9001476_MainProxy
