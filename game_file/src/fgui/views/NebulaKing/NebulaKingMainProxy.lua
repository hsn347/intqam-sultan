local baseProxy = require("fgui.base.baseProxy")
local NebulaKingMainProxy = class("NebulaKingMainProxy", baseProxy)
function NebulaKingMainProxy:onRegisterEvent()
	print("=======NebulaKingMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_INIT", handler(self, self.onNebulaKingInit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onNebulaKingInit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onNebulaKingInit))
end
function NebulaKingMainProxy:onNebulaKingInit()
	self.view:updateUI()
end
function NebulaKingMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_KING_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaKingMainProxy
