local baseProxy = require("fgui.base.baseProxy")
local allianceWarehouseViewProxy = class("allianceWarehouseViewProxy", baseProxy)
function allianceWarehouseViewProxy:onRegisterEvent()
	print("=======allianceWarehouseViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GIVETAX_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COST_RECORD_BACK", handler(self, self.initData))
end
function allianceWarehouseViewProxy:initData(...)
	self.view:initData(...)
end
return allianceWarehouseViewProxy
