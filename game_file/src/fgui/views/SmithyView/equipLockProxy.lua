local baseProxy = require("fgui.base.baseProxy")
local equipLockProxy = class("equipLockProxy", baseProxy)
function equipLockProxy:onRegisterEvent()
	print("=======equipLockProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIPMENT_LOCK_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function equipLockProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return equipLockProxy
