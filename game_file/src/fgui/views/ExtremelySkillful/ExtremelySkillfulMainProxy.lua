local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulMainProxy = class("ExtremelySkillfulMainProxy", baseProxy)
function ExtremelySkillfulMainProxy:onRegisterEvent()
	print("=======ExtremelySkillfulMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_EXTREMELY_SKILLFUL_REFRESH", handler(self, self.onUpdateRewardView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.onUpdateTips))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ExtremelySkillfulMainProxy:onUpdateTask(target, data)
	if data.activityID == self.view.activityID then
		SoraDCloseLoading(self.view)
		self.view:updateTask()
		self.view:updatRed()
	end
end
function ExtremelySkillfulMainProxy:onUpdateTips(target, data)
	self.view:updateView()
end
function ExtremelySkillfulMainProxy:onUpdateRewardView(target, data)
	SoraDCloseLoading(self.view)
	self.view:updateReward()
	self.view:updatRed()
	self.view:updateView()
end
function ExtremelySkillfulMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return ExtremelySkillfulMainProxy
