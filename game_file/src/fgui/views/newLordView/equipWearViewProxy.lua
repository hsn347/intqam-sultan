local baseProxy = require("fgui.base.baseProxy")
local equipWearViewProxy = class("equipWearViewProxy", baseProxy)
function equipWearViewProxy:onRegisterEvent()
	print("=======equipWearViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_MENU_SELECT", handler(self, self.menuSelect))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_GET_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LEGEND_LEVELUP", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_WEAR_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.limitTimeOut))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RECAST_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.initData))
end
function equipWearViewProxy:menuSelect(target, data)
	self.view:menuSelect(target, data)
end
function equipWearViewProxy:initData(target, data)
	self.view:initData(data.isWearing)
end
function equipWearViewProxy:limitTimeOut(target, data)
	self.view:limitTimeOut(target, data)
end
return equipWearViewProxy
