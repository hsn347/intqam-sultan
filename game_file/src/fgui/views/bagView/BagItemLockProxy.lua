local baseProxy = require("fgui.base.baseProxy")
local BagItemLockProxy = class("BagItemLockProxy", baseProxy)
function BagItemLockProxy:onRegisterEvent()
	print("=======BagItemLockProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateLockItem))
end
function BagItemLockProxy:updateLockItem(target, data)
	self.view:updateData()
end
return BagItemLockProxy
