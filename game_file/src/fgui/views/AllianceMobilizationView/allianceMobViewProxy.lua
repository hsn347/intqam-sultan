local baseProxy = require("fgui.base.baseProxy")
local allianceMobViewProxy = class("allianceMobViewProxy", baseProxy)
function allianceMobViewProxy:onRegisterEvent()
	print("=======allianceMobViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_COMMIT_BACK", handler(self, self.initGeneralView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_REFRESH", handler(self, self.initGeneralView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_USER_INFO_BACK", handler(self, self.initAMRankView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_RANK_INFO_BACK", handler(self, self.initAGRankView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function allianceMobViewProxy:initGeneralView(target, data)
	self.view:initGeneralView(target, data)
end
function allianceMobViewProxy:initAMRankView(target, data)
	self.view:initAMRankView(target, data)
end
function allianceMobViewProxy:initAGRankView(target, data)
	self.view:initAGRankView(target, data)
end
function allianceMobViewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return allianceMobViewProxy
