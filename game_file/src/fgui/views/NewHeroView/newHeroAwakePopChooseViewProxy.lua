local baseProxy = require("fgui.base.baseProxy")
local newHeroAwakePopChooseViewProxy = class("newHeroAwakePopChooseViewProxy", baseProxy)
function newHeroAwakePopChooseViewProxy:onRegisterEvent()
	print("=======newHeroAwakePopChooseViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STARTUPGRADE", handler(self, self.closeView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_DRESS_UPDATE", handler(self, self.updateView))
end
function newHeroAwakePopChooseViewProxy:closeView(target, data)
	self.view:close()
end
function newHeroAwakePopChooseViewProxy:updateView(target, data)
	self.view:updateView()
end
return newHeroAwakePopChooseViewProxy
