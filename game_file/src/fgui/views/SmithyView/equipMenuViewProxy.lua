local baseProxy = require("fgui.base.baseProxy")
local equipMenuViewProxy = class("equipMenuViewProxy", baseProxy)
function equipMenuViewProxy:onRegisterEvent()
	print("=======equipMenuViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RECAST_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_MENU_PART_SELECT", handler(self, self.partSelect))
end
function equipMenuViewProxy:refreshData(target, data)
	self.view:refreshData(target, data)
end
function equipMenuViewProxy:partSelect(target, data)
	self.view:partSelect(target, data)
end
return equipMenuViewProxy
