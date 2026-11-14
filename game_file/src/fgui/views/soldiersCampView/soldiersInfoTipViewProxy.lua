local baseProxy = require("fgui.base.baseProxy")
local soldiersInfoTipViewProxy = class("soldiersInfoTipViewProxy", baseProxy)
function soldiersInfoTipViewProxy:onRegisterEvent()
	print("=======soldiersInfoTipViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_ARMY_INFO_CLOSE", handler(self, self.msgCloseSelf))
end
function soldiersInfoTipViewProxy:msgCloseSelf()
	self.view:close()
end
return soldiersInfoTipViewProxy
