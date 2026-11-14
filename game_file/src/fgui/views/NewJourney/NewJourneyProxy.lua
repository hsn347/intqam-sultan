local baseProxy = require("fgui.base.baseProxy")
local NewJourneyProxy = class("NewJourneyProxy", baseProxy)
function NewJourneyProxy:onRegisterEvent()
	print("=======NewJourneyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onServerEventCenterCommonEventRefresh))
	SoraDAddMessage(self, "MESSAGE_REQ_NEW_PRINCE_GIFT_BUY_PACKAGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
end
function NewJourneyProxy:onServerEventCenterCommonEventRefresh()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_JOURNEY_ACTIVITY) then
		SoraDShowMsgTip(i18n("journey_text_1012"))
		self.view:close()
	end
end
function NewJourneyProxy:initData()
	self.view:initData()
end
return NewJourneyProxy
