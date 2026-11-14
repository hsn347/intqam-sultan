local baseProxy = require("fgui.base.baseProxy")
local NebulaKingPreviewProxy = class("NebulaKingPreviewProxy", baseProxy)
function NebulaKingPreviewProxy:onRegisterEvent()
	print("=======NebulaKingPreviewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaKingPreviewProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_KING_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaKingPreviewProxy
