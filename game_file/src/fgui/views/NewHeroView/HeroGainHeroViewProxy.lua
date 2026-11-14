local baseProxy = require("fgui.base.baseProxy")
local HeroGainHeroViewProxy = class("HeroGainHeroViewProxy", baseProxy)
function HeroGainHeroViewProxy:onRegisterEvent()
	print("=======HeroGainHeroViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STORYTASK_UPDATE", handler(self, self.updateStoryRedStatus))
end
function HeroGainHeroViewProxy:updateStoryRedStatus(...)
	self.view:updateStoryRedStatus(...)
end
return HeroGainHeroViewProxy
