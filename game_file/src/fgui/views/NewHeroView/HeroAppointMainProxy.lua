local baseProxy = require("fgui.base.baseProxy")
local HeroAppointMainProxy = class("HeroAppointMainProxy", baseProxy)
function HeroAppointMainProxy:onRegisterEvent()
	print("=======HeroAppointMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_APPOINT_UPDATE", handler(self, self.updateView))
end
function HeroAppointMainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return HeroAppointMainProxy
