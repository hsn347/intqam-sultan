local baseProxy = require("fgui.base.baseProxy")
local Activity_9001577_MainProxy = class("Activity_9001577_MainProxy", baseProxy)
function Activity_9001577_MainProxy:onRegisterEvent()
	print("=======Activity_9001577_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_INIT", handler(self, self.onNebulaKingInit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_STAGE_RANK", handler(self, self.onNebulaKingInit))
	SoraDAddMessage(self, "MESSAGE_NEBULA_KING_TOTAL_RANK", handler(self, self.onNebulaKingInit))
end
function Activity_9001577_MainProxy:onNebulaKingInit()
	self.view:updateUI()
end
function Activity_9001577_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001577_MainProxy
