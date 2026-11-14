local baseProxy = require("fgui.base.baseProxy")
local commonQuickUseViewProxy = class("commonQuickUseViewProxy", baseProxy)
function commonQuickUseViewProxy:onRegisterEvent()
	print("=======commonQuickUseViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemCountChange))
end
function commonQuickUseViewProxy:itemCountChange(target, data)
	self.view:itemCountChange(target, data)
end
return commonQuickUseViewProxy
