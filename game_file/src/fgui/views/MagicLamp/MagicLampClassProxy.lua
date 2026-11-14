local baseProxy = require("fgui.base.baseProxy")
local MagicLampClassProxy = class("MagicLampClassProxy", baseProxy)
function MagicLampClassProxy:onRegisterEvent()
	print("=======MagicLampClassProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.refreshItem))
end
function MagicLampClassProxy:refreshItem()
	self.view:updateView()
end
return MagicLampClassProxy
