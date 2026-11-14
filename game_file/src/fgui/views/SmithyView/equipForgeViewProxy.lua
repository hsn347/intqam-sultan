local baseProxy = require("fgui.base.baseProxy")
local equipForgeViewProxy = class("equipForgeViewProxy", baseProxy)
function equipForgeViewProxy:onRegisterEvent()
	print("=======equipForgeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.onMsgEquipForgeFinish))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateSteel))
	SoraDAddMessage(self, "MESSAGE_UI_GET_CUR_BUILD_EQUIP", handler(self, self.initAutoData))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_FORGE_SELECT", handler(self, self.selectBack))
end
function equipForgeViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function equipForgeViewProxy:updateSteel(target, data)
	if data.reslist[tostring(gIDDef.STEEL)] then
		self.view:updateSteel(target, data)
	end
end
function equipForgeViewProxy:initAutoData(target, data)
	self.view:initAutoData(data)
end
function equipForgeViewProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
function equipForgeViewProxy:onMsgEquipForgeFinish(...)
	self.view:initData(...)
	SoraDGetEquip()
end
return equipForgeViewProxy
