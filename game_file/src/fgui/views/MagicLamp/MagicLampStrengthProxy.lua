local baseProxy = require("fgui.base.baseProxy")
local MagicLampStrengthProxy = class("MagicLampStrengthProxy", baseProxy)
function MagicLampStrengthProxy:onRegisterEvent()
	print("=======MagicLampStrengthProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshItem))
end
function MagicLampStrengthProxy:refreshItem()
	self.view:updateView()
end
return MagicLampStrengthProxy
