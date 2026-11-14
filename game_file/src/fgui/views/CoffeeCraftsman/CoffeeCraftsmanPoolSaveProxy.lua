local baseProxy = require("fgui.base.baseProxy")
local CoffeeCraftsmanPoolSaveProxy = class("CoffeeCraftsmanPoolSaveProxy", baseProxy)
function CoffeeCraftsmanPoolSaveProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE", handler(self, self.onChoose))
end
function CoffeeCraftsmanPoolSaveProxy:onChoose()
	self.view:close()
end
return CoffeeCraftsmanPoolSaveProxy
