local baseProxy = require("fgui.base.baseProxy")
local badgeBourseViewProxy = class("badgeBourseViewProxy", baseProxy)
function badgeBourseViewProxy:onRegisterEvent()
	print("=======badgeBourseViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_BADGEBOURSE_RES_SELECT", handler(self, self.exchangeIDSelect))
	SoraDAddMessage(self, "MESSAGE_SERVER_BADGE_EXCHANGE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_BADGE_DAILY_REFRESH", handler(self, self.updateView))
end
function badgeBourseViewProxy:exchangeIDSelect(target, data)
	self.view:exchangeIDSelect(target, data)
end
function badgeBourseViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return badgeBourseViewProxy
