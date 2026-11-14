local baseProxy = require("fgui.base.baseProxy")
local citybuffItemViewProxy = class("citybuffItemViewProxy", baseProxy)
function citybuffItemViewProxy:onRegisterEvent()
	print("=======citybuffItemViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
end
function citybuffItemViewProxy:update()
	self.view:update()
end
return citybuffItemViewProxy
