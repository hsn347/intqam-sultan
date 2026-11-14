local baseProxy = require("fgui.base.baseProxy")
local Activity_9001479_MainProxy = class("Activity_9001479_MainProxy", baseProxy)
function Activity_9001479_MainProxy:onRegisterEvent()
	print("=======Activity_9001479_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_CAMP_SCORE", handler(self, self.onMsgUpdateCampScore))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_RESULT", handler(self, self.onMsgUpdateResult))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_PROGRESS", handler(self, self.onMsgUpdateProgress))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_STAGE", handler(self, self.onMsgUpdateStage))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001479_UPDATE_SETTLE", handler(self, self.onMsgUpdateSettle))
end
function Activity_9001479_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001479_MainProxy:onMsgUpdateCampScore(target, event)
	self.view:onMsgUpdateCampScore(target, event)
end
function Activity_9001479_MainProxy:onMsgUpdateResult(target, event)
	self.view:onMsgUpdateResult(target, event)
end
function Activity_9001479_MainProxy:onMsgUpdateProgress(target, event)
	self.view:updateProgress()
	self.view:updateTextScore()
end
function Activity_9001479_MainProxy:onMsgUpdateStage(...)
	self.view:updateStage()
	self.view:updateProgress()
end
function Activity_9001479_MainProxy:onMsgUpdateSettle(...)
	self.view:onMsgUpdateSettle(...)
end
return Activity_9001479_MainProxy
