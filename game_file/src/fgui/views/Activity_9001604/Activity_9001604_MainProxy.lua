local baseProxy = require("fgui.base.baseProxy")
local Activity_9001604_MainProxy = class("Activity_9001604_MainProxy", baseProxy)
function Activity_9001604_MainProxy:onRegisterEvent()
	print("=======Activity_9001604_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001604_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001604_RANK", handler(self, self.onMsgUpdateRank))
end
function Activity_9001604_MainProxy:onMsgUpdateRank(target, event)
	print("Activity_9001597_RankProxy:onMsgUpdateRank")
	self.view:onMsgUpdateRank(target, event)
end
function Activity_9001604_MainProxy:updateView()
	self.view:updateView()
end
function Activity_9001604_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	elseif data.activityID == gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604 then
		self:updateView()
	end
end
return Activity_9001604_MainProxy
