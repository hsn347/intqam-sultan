local baseProxy = require("fgui.base.baseProxy")
local equipMaterialSelectViewProxy = class("equipMaterialSelectViewProxy", baseProxy)
function equipMaterialSelectViewProxy:onRegisterEvent()
	print("=======equipMaterialSelectViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_FORGE_SELECT", handler(self, self.selectBack))
end
function equipMaterialSelectViewProxy:selectBack(target, data)
	self.view:selectBack(target, data)
end
return equipMaterialSelectViewProxy
