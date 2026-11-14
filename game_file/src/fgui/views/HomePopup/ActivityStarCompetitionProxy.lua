local baseProxy = require("fgui.base.baseProxy")
local ActivityStarCompetitionProxy = class("ActivityStarCompetitionProxy", baseProxy)
function ActivityStarCompetitionProxy:onRegisterEvent()
	print("=======ActivityStarCompetitionProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_STARCMP_ACTIVITY_REFRESH", function(target, redata)
		SoraDCloseLoading()
		self.view:refreshData(target, redata)
	end)
end
function ActivityStarCompetitionProxy:judgeClose(target, redata)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GLORIOUS_CONTEST) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return ActivityStarCompetitionProxy
