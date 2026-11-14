local baseProxy = require("fgui.base.baseProxy")
local itemActivationViewProxy = class("itemActivationViewProxy", baseProxy)
function itemActivationViewProxy:onRegisterEvent()
	print("=======itemActivationViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
end
function itemActivationViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return itemActivationViewProxy
