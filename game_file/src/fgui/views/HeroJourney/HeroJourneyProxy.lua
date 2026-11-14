local baseProxy = require("fgui.base.baseProxy")
local HeroJourneyProxy = class("HeroJourneyProxy", baseProxy)
function HeroJourneyProxy:onRegisterEvent()
	print("=======HeroJourneyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_HERO_JOURNEY_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function HeroJourneyProxy:initData()
	if self.view then
		self.view:initData()
	end
end
function HeroJourneyProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_DIARY_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return HeroJourneyProxy
