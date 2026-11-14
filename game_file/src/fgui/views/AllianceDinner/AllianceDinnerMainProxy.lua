local baseProxy = require("fgui.base.baseProxy")
local AllianceDinnerMainProxy = class("AllianceDinnerMainProxy", baseProxy)
function AllianceDinnerMainProxy:onRegisterEvent()
	print("=======AllianceDinnerMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DINNER_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTaskRedDot))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateTaskRedDot))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", function(...)
		self.view:close()
	end)
end
function AllianceDinnerMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ALLIANCE_DINNER_ACTIVITY) then
		self.view:close()
	end
end
function AllianceDinnerMainProxy:updateView()
	if self.view then
		self.view:updateView()
	end
end
function AllianceDinnerMainProxy:updateTaskRedDot()
	self.view:updateTaskRedDot()
end
return AllianceDinnerMainProxy
