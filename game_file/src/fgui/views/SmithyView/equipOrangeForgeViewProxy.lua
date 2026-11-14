local baseProxy = require("fgui.base.baseProxy")
local equipOrangeForgeViewProxy = class("equipOrangeForgeViewProxy", baseProxy)
function equipOrangeForgeViewProxy:onRegisterEvent()
	print("=======equipOrangeForgeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_FORGE_SELECT", handler(self, self.selectBack))
end
function equipOrangeForgeViewProxy:initData(target, data)
	if data.msg == "MESSAGE_SERVER_EQUIP_FORGE_FINISH" then
		self.view:resetBaseEquip()
		SoraDGetEquip()
	end
	self.view:initData()
end
function equipOrangeForgeViewProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
return equipOrangeForgeViewProxy
