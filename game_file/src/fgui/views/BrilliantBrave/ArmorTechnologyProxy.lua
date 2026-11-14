local baseProxy = require("fgui.base.baseProxy")
local ArmorTechnologyProxy = class("ArmorTechnologyProxy", baseProxy)
function ArmorTechnologyProxy:onRegisterEvent()
	print("=======ArmorTechnologyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMOR_TECHNOLOGY_UI_SWITCH", handler(self, self.updateView))
end
function ArmorTechnologyProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return ArmorTechnologyProxy
