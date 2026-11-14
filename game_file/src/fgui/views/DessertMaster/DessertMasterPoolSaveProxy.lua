local baseProxy = require("fgui.base.baseProxy")
local DessertMasterPoolSaveProxy = class("DessertMasterPoolSaveProxy", baseProxy)
function DessertMasterPoolSaveProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE", handler(self, self.onChoose))
end
function DessertMasterPoolSaveProxy:onChoose()
	self.view:close()
end
return DessertMasterPoolSaveProxy
