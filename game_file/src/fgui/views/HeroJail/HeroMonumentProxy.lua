local baseProxy = require("fgui.base.baseProxy")
local HeroMonumentProxy = class("HeroMonumentProxy", baseProxy)
function HeroMonumentProxy:onRegisterEvent()
	print("=======HeroMonumentProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MONUMENT_VIEW", handler(self, self.initData))
end
function HeroMonumentProxy:initData()
	self.view:initData()
end
return HeroMonumentProxy
