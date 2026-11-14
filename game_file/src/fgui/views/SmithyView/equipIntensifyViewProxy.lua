local baseProxy = require("fgui.base.baseProxy")
local equipIntensifyViewProxy = class("equipIntensifyViewProxy", baseProxy)
function equipIntensifyViewProxy:onRegisterEvent()
	print("=======equipIntensifyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK", handler(self, self.intensifyBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateStone))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_DATA_UPDATE", handler(self, self.equipDataUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.equipLimitTimeOut))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateSteel))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RECAST_BACK", handler(self, self.initData))
end
function equipIntensifyViewProxy:intensifyBack(target, data)
	self.view:intensifyBack(target, data)
end
function equipIntensifyViewProxy:updateStone(target, data)
	self.view:updateStone(target, data)
end
function equipIntensifyViewProxy:equipDataUpdate(target, data)
	self.view:equipDataUpdate(target, data)
end
function equipIntensifyViewProxy:equipLimitTimeOut(target, data)
	self.view:equipLimitTimeOut(target, data)
end
function equipIntensifyViewProxy:updateSteel(target, data)
	if data.reslist[tostring(gIDDef.STEEL)] then
		self.view:updateSteel()
	end
end
function equipIntensifyViewProxy:initData(target, data)
	self.view:initData(data.equipCell)
end
return equipIntensifyViewProxy
