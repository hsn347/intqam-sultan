local baseProxy = require("fgui.base.baseProxy")
local NebulaCompetitionMainProxy = class("NebulaCompetitionMainProxy", baseProxy)
function NebulaCompetitionMainProxy:onRegisterEvent()
	print("=======NebulaCompetitionMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_INIT", handler(self, self.onNebulaKingInit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onNebulaKingInit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onNebulaKingInit))
end
function NebulaCompetitionMainProxy:onNebulaKingInit()
	self.view:updateUI()
end
function NebulaCompetitionMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaCompetitionMainProxy
