local baseProxy = require("fgui.base.baseProxy")
local CoffeeCraftsmanPoolProxy = class("CoffeeCraftsmanPoolProxy", baseProxy)
function CoffeeCraftsmanPoolProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE", handler(self, self.onChoose))
end
function CoffeeCraftsmanPoolProxy:onChoose()
	self.view:updateView()
end
return CoffeeCraftsmanPoolProxy
