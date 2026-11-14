local baseProxy = require("fgui.base.baseProxy")
local DecompositionProxy = class("DecompositionProxy", baseProxy)
function DecompositionProxy:onRegisterEvent()
	print("=======DecompositionProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_RESOLVE_SURE_CHOOSE", handler(self, self.updateQualityChoose))
	SoraDAddMessage(self, "MESSAGE_UI_RESOLVE_EXTRA_CHOOSE", handler(self, self.updateExtraChoose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ONEKEY_DISASSEMBLE", handler(self, self.closeView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_LEVEL", handler(self, self.updateLvChoose))
end
function DecompositionProxy:updateQualityChoose(target, data)
	self.view:updateQualityChoose(target, data)
end
function DecompositionProxy:updateExtraChoose(target, data)
	self.view:updateExtraChoose(target, data)
end
function DecompositionProxy:closeView(target, data)
	self.view:close()
end
function DecompositionProxy:updateLvChoose(target, data)
	self.view:updateLvChoose()
end
return DecompositionProxy
