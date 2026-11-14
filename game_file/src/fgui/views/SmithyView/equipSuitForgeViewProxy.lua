local baseProxy = require("fgui.base.baseProxy")
local equipSuitForgeViewProxy = class("equipSuitForgeViewProxy", baseProxy)
function equipSuitForgeViewProxy:onRegisterEvent()
	print("=======equipSuitForgeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateSteel))
	SoraDAddMessage(self, "MESSAGE_UI_GET_CUR_BUILD_EQUIP", handler(self, self.initAutoData))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_FORGE_SELECT", handler(self, self.selectBack))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_SUIT_CELL_SELECT_ONLY", handler(self, self.selectQualityBack))
end
function equipSuitForgeViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function equipSuitForgeViewProxy:updateSteel(target, data)
	if data.reslist[tostring(gIDDef.STEEL)] then
		self.view:updateSteel(target, data)
	end
end
function equipSuitForgeViewProxy:initAutoData(target, data)
	self.view:initAutoData(data)
end
function equipSuitForgeViewProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
function equipSuitForgeViewProxy:selectQualityBack(target, data)
	self.view:selectQualityBack(target, data)
end
return equipSuitForgeViewProxy
