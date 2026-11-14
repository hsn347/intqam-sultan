local baseProxy = require("fgui.base.baseProxy")
local allianceWarehouseLogViewProxy = class("allianceWarehouseLogViewProxy", baseProxy)
function allianceWarehouseLogViewProxy:onRegisterEvent()
	print("=======allianceWarehouseLogViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS", handler(self, self.dataBack))
end
function allianceWarehouseLogViewProxy:dataBack(...)
	self.view:dataBack(...)
end
return allianceWarehouseLogViewProxy
