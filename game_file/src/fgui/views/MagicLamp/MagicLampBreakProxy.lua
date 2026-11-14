local baseProxy = require("fgui.base.baseProxy")
local MagicLampBreakProxy = class("MagicLampBreakProxy", baseProxy)
function MagicLampBreakProxy:onRegisterEvent()
	print("=======MagicLampBreakProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshItem))
end
function MagicLampBreakProxy:refreshItem()
	self.view:updateView()
end
return MagicLampBreakProxy
