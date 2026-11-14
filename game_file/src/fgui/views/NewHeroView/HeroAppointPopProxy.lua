local baseProxy = require("fgui.base.baseProxy")
local HeroAppointPopProxy = class("HeroAppointPopProxy", baseProxy)
function HeroAppointPopProxy:onRegisterEvent()
	print("=======HeroAppointPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_HERO_APPOINT_SELECT", handler(self, self.selectBack))
end
function HeroAppointPopProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
return HeroAppointPopProxy
