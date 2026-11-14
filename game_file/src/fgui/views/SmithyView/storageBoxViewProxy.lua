local baseProxy = require("fgui.base.baseProxy")
local storageBoxViewProxy = class("storageBoxViewProxy", baseProxy)
function storageBoxViewProxy:onRegisterEvent()
	print("=======storageBoxViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateSteel))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_COMMON_FILER_SETTING_SYNC", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LEGEND_LEVELUP", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RECAST_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIPMENT_LOCK_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_MATERIAL_SELECT", handler(self, self.materialSelect))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_SELECT", handler(self, self.equipSelect))
end
function storageBoxViewProxy:updateSteel(target, data)
	self.view:updateSteel(target, data)
end
function storageBoxViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function storageBoxViewProxy:materialSelect(target, data)
	self.view:materialSelect(target, data)
end
function storageBoxViewProxy:equipSelect(target, data)
	self.view:equipSelect(target, data)
end
return storageBoxViewProxy
