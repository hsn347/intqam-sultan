local baseProxy = require("fgui.base.baseProxy")
local DeadlyHuntingProxy = class("DeadlyHuntingProxy", baseProxy)
function DeadlyHuntingProxy:onRegisterEvent()
	print("=======DeadlyHuntingProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
end
function DeadlyHuntingProxy:initData(target, data)
	if data.activityID == gActivityTimeActivityID.DEADLY_HUNTING_ACTIVITY and self.view then
		self.view:initData()
	end
end
function DeadlyHuntingProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DEADLY_HUNTING_ACTIVITY) and self.view then
		self.view:close()
	end
end
return DeadlyHuntingProxy
