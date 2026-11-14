local baseProxy = require("fgui.base.baseProxy")
local suitInfoViewProxy = class("suitInfoViewProxy", baseProxy)
function suitInfoViewProxy:onRegisterEvent()
	print("=======suitInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_METERIAL_MERGE_BACK", handler(self, self.initData))
end
function suitInfoViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return suitInfoViewProxy
