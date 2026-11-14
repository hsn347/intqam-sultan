local baseProxy = require("fgui.base.baseProxy")
local HeroStageGiftProxy = class("HeroStageGiftProxy", baseProxy)
function HeroStageGiftProxy:onRegisterEvent()
	print("=======HeroStageGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STAGE_GIFT", handler(self, self.initData))
end
function HeroStageGiftProxy:initData()
	self.view:initData()
end
return HeroStageGiftProxy
