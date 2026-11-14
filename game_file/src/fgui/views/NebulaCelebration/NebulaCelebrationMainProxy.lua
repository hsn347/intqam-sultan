local baseProxy = require("fgui.base.baseProxy")
local NebulaCelebrationMainProxy = class("NebulaCelebrationMainProxy", baseProxy)
function NebulaCelebrationMainProxy:onRegisterEvent()
	print("=======NebulaCelebrationMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_INIT", handler(self, self.updateUI))
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_CLAIM_REWARD", handler(self, self.updateUI))
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_BUY_STARLIGHT", handler(self, self.updateUI))
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_CLAIM_ALL_REWARD", handler(self, self.updateUI))
	SoraDAddMessage(self, "MESSAGE_NEBULA_CELEBRATION_BUY_GIFT_SUCCESS", handler(self, self.updateUI))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaCelebrationMainProxy:updateUI()
	self.view:updateUI()
end
function NebulaCelebrationMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_CELEBRATION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaCelebrationMainProxy
