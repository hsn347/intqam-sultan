local baseProxy = require("fgui.base.baseProxy")
local BlackGhostProxy = class("BlackGhostProxy", baseProxy)
function BlackGhostProxy:onRegisterEvent()
	print("=======BlackGhostProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
end
function BlackGhostProxy:initData(target, data)
	if data.activityID == gActivityTimeActivityID.BLACK_GHOST_ACTIVITY and self.view then
		self.view:initData()
	end
end
function BlackGhostProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BLACK_GHOST_ACTIVITY) and self.view then
		self.view:close()
	end
end
return BlackGhostProxy
