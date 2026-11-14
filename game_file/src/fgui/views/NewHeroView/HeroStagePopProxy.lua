local baseProxy = require("fgui.base.baseProxy")
local HeroStagePopProxy = class("HeroStagePopProxy", baseProxy)
function HeroStagePopProxy:onRegisterEvent()
	print("=======HeroStagePopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STAGE_GIFT", handler(self, self.initData))
end
function HeroStagePopProxy:initData()
	self.view:initData()
end
return HeroStagePopProxy
