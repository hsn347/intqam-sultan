local baseProxy = require("fgui.base.baseProxy")
local HeroKnowledgePopProxy = class("HeroKnowledgePopProxy", baseProxy)
function HeroKnowledgePopProxy:onRegisterEvent()
	print("=======HeroKnowledgePopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_HEROTASK_HERO_SELECT", handler(self, self.selectHeroBack))
end
function HeroKnowledgePopProxy:selectHeroBack(target, data)
	self.view:selectHeroBack(target, data)
end
return HeroKnowledgePopProxy
