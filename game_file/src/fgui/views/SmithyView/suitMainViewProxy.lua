local baseProxy = require("fgui.base.baseProxy")
local suitMainViewProxy = class("suitMainViewProxy", baseProxy)
function suitMainViewProxy:onRegisterEvent()
	print("=======suitMainViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_MATERIAL_BACK", handler(self, self.initData))
end
function suitMainViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return suitMainViewProxy
