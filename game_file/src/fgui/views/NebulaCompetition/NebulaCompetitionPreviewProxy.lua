local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionPreviewProxy = class("NebulaCompetitionPreviewProxy", baseProxy)
function NebulaCompetitionPreviewProxy:onRegisterEvent()
	print("=======NebulaCompetitionPreviewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaCompetitionPreviewProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaCompetitionPreviewProxy
