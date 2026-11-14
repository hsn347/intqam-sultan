local baseProxy = require("fgui.base.baseProxy")
local DessertMasterPoolProxy = class("DessertMasterPoolProxy", baseProxy)
function DessertMasterPoolProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE", handler(self, self.onChoose))
end
function DessertMasterPoolProxy:onChoose()
	self.view:updateView()
end
return DessertMasterPoolProxy
