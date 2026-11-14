local baseProxy = require("fgui.base.baseProxy")
local SpecializeCritProxy = class("SpecializeCritProxy", baseProxy)
function SpecializeCritProxy:onRegisterEvent()
	print("=======SpecializeCritProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SpecializeCritProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_ADVANCE_SKILL_CRIT_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return SpecializeCritProxy
