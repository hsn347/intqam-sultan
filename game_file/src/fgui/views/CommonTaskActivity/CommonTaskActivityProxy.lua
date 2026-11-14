local baseProxy = require("fgui.base.baseProxy")
local CommonTaskActivityProxy = class("CommonTaskActivityProxy", baseProxy)
function CommonTaskActivityProxy:onRegisterEvent()
	print("=======CommonTaskActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.msgUpdateList))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.msgUpdateList))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.msgUpdateList))
	SoraDAddMessage(self, "MESSAGE_PLANTHOROUGH_INIT", handler(self, self.updatePlanthoroughView))
	SoraDAddMessage(self, "MESSAGE_PLANTHOROUGH_UPDATA", handler(self, self.updatePlanthoroughView))
	SoraDAddMessage(self, "MESSAGE_PLANTHOROUGH_CLAIM_REWARD", handler(self, self.updatePlanthoroughView))
	SoraDAddMessage(self, "MESSAGE_PLANTHOROUGH_CLOSE", handler(self, self.closeWindow))
	SoraDAddMessage(self, "MESSAGE_SERVER_SUN_SET_UPDATE_TASK", handler(self, self.updateSunsetView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_NOVICE_GIFT_REFRESH", handler(self, self.updateNoviceView))
end
function CommonTaskActivityProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		self.view:removeFromParent()
	end
end
function CommonTaskActivityProxy:msgUpdateList(target, data)
	if data.activityID == self.view.activityID then
		self.view:updateScrollView()
		SoraDCloseLoading(self.view)
	end
end
function CommonTaskActivityProxy:updatePlanthoroughView()
	if gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY == self.view.activityID then
		self.view:updateScrollView()
		SoraDCloseLoading(self.view)
	end
end
function CommonTaskActivityProxy:closeWindow()
	if gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY == self.view.activityID then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function CommonTaskActivityProxy:updateSunsetView()
end
function CommonTaskActivityProxy:updateNoviceView()
	if gActivityTimeActivityID.RECRUITMENT_MATERIALS == self.view.activityID then
		self.view:updateScrollView()
		SoraDCloseLoading(self.view)
	end
end
return CommonTaskActivityProxy
