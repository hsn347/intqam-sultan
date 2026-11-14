local baseProxy = require("fgui.base.baseProxy")
local storageBoxInfoViewProxy = class("storageBoxInfoViewProxy", baseProxy)
function storageBoxInfoViewProxy:onRegisterEvent()
	print("=======storageBoxInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.closeView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.closeView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RECAST_BACK", handler(self, self.closeView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.wearBack))
end
function storageBoxInfoViewProxy:closeView(target, data)
	self.view:closeView(target, data)
end
function storageBoxInfoViewProxy:wearBack(target, data)
	self.view:wearBack(target, data)
end
return storageBoxInfoViewProxy
