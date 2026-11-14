local baseProxy = require("fgui.base.baseProxy")
local HeroKnowledgeMainProxy = class("HeroKnowledgeMainProxy", baseProxy)
function HeroKnowledgeMainProxy:onRegisterEvent()
	print("=======HeroKnowledgeMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_TASK_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateView))
end
function HeroKnowledgeMainProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return HeroKnowledgeMainProxy
