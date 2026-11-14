local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulBuffPopProxy = class("ExtremelySkillfulBuffPopProxy", baseProxy)
function ExtremelySkillfulBuffPopProxy:onRegisterEvent()
	print("=======ExtremelySkillfulBuffPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ExtremelySkillfulBuffPopProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXTREMELY_SKILLFUIL) and self.view then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	elseif self.view then
		self.view:initData()
	end
end
return ExtremelySkillfulBuffPopProxy
