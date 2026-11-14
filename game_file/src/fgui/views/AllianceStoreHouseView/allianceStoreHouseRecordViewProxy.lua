local baseProxy = require("fgui.base.baseProxy")
local allianceStoreHouseRecordViewProxy = class("allianceStoreHouseRecordViewProxy", baseProxy)
function allianceStoreHouseRecordViewProxy:onRegisterEvent()
	print("=======allianceStoreHouseRecordViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TREASURE_REQ_INFO_BACK", handler(self, self.reqInfoBack))
end
function allianceStoreHouseRecordViewProxy:reqInfoBack(target, data)
	self.view:reqInfoBack(target, data)
end
return allianceStoreHouseRecordViewProxy
