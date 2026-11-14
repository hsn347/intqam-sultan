local baseProxy = require("fgui.base.baseProxy")
local WarGemReplaceProxy = class("WarGemReplaceProxy", baseProxy)
function WarGemReplaceProxy:onRegisterEvent()
	print("=======WarGemReplaceProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_UPDATE", handler(self, self.updateView))
end
function WarGemReplaceProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return WarGemReplaceProxy
