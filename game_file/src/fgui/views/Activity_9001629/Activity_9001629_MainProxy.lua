local baseProxy = require("fgui.base.baseProxy")
local Activity_9001629_MainProxy = class("Activity_9001629_MainProxy", baseProxy)
function Activity_9001629_MainProxy:onRegisterEvent()
	print("=======Activity_9001629_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001629_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001629_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgRefreshItemNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_STEP", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_USESTEP", handler(self, self.onUpdateTask))
end
function Activity_9001629_MainProxy:onUpdateView(target, data)
	self.view:updateView()
	if data.wish then
		self.view:playShowAni()
	end
end
function Activity_9001629_MainProxy:onUpdateTask()
	self.view:updateRedDot()
end
function Activity_9001629_MainProxy:msgRefreshItemNum(target, data)
	self.view:updateItem()
end
function Activity_9001629_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NORMAL_ACTIVITY_9001629) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001629_MainProxy
