local baseProxy = require("fgui.base.baseProxy")
local MagicLampHatchUpProxy = class("MagicLampHatchUpProxy", baseProxy)
function MagicLampHatchUpProxy:onRegisterEvent()
	print("=======MagicLampHatchUpProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshItem))
end
function MagicLampHatchUpProxy:refreshItem()
	self.view:updateView()
end
return MagicLampHatchUpProxy
