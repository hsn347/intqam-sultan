local baseProxy = require("fgui.base.baseProxy")
local Activity_9001496_MainProxy = class("Activity_9001496_MainProxy", baseProxy)
function Activity_9001496_MainProxy:onRegisterEvent()
	print("=======Activity_9001496_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001496_UPDATE", handler(self, self.onMsgUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateGift))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001496_JUMP_GIFT", handler(self, self.onMsgJumpToGift))
end
function Activity_9001496_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001496_MainProxy:onMsgUpdate(target, event)
	local key = event.key
	if key == "rechargePrice" then
		self.view:onMsgUpdateRechargePrice()
	else
		self.view:updateTaskList()
		SoraDCloseLoading(self.view:displayObject())
	end
end
function Activity_9001496_MainProxy:showLoading(...)
	SoraDShowLoading(self.view:displayObject())
end
function Activity_9001496_MainProxy:updateGift(target, data)
	self.view:updateGift(target, data)
end
function Activity_9001496_MainProxy:onMsgJumpToGift(...)
	self.view:onMsgJumpToGift(...)
end
return Activity_9001496_MainProxy
